import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

import '../consts.dart';
enum SensorStatus { Perfect, Good, Bad }

class Node {
  final String id;
  final String name;
  final String latitude;
  final String longitude;
  final String imageUrl;
  final List<Sensor> sensors;
  String status;
  double? distance;

  Node({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.sensors,
    required this.imageUrl,
    this.status = '',
    this.distance,
  });

  factory Node.fromMap(Map<String, dynamic> map, List<Sensor> sensors) {
    return Node(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      latitude: map['latitude'] ?? '',
      longitude: map['longitude'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      sensors: sensors,
    );
  }

  Future<Map<String, double>> getAverageSensorValues() async {
    Map<String, double> averageValues = {};
    for (String sensorType in ['temperature', 'humidity', 'gas', 'sound', 'dust']) {
      QuerySnapshot sensorSnapshot = await FirebaseFirestore.instance
          .collection('nodes')
          .doc(id)
          .collection('sensors')
          .orderBy('date', descending: true)
          .limit(5)
          .get();

      List<double> sensorValues = sensorSnapshot.docs
          .map((doc) => Sensor.fromSnapshot(doc).getSensorValue(sensorType))
          .toList();

      double averageValue = sensorValues.reduce((a, b) => a + b) / sensorValues.length;
      averageValue = double.parse(averageValue.toStringAsFixed(2));

      averageValues[sensorType] = averageValue;
    }
    return averageValues;
  }

  String evaluateNodeStatus(Map<String, double> averageValues) {
    double dust = averageValues['dust'] ?? 0.0;
    double gas = averageValues['gas'] ?? 0.0;
    double sound = averageValues['sound'] ?? 0.0;

    if (dust < 110 && gas < 154 && sound < 70) {
      return 'Perfect';
    } else if (dust < 70 && gas < 70 && sound < 70) {
      return 'Good';
    } else {
      return 'Bad';
    }
  }

  /*static Future<List<Node>> labelAndOrderNodes(List<Node> nodes) async {
    List<Node> labeledNodes = [];
    for (Node node in nodes) {
      Map<String, double> averageValues = await node.getAverageSensorValues();
      String status = node.evaluateNodeStatus(averageValues);
      labeledNodes.add(Node(
        id: node.id,
        name: node.name,
        latitude: node.latitude,
        longitude: node.longitude,
        sensors: node.sensors,
        imageUrl: node.imageUrl,
        status: status,
      ));
    }

    // Sort labeled nodes based on status (best to worst)
    labeledNodes.sort((a, b) {
      // Define the order of statuses
      Map<String, int> statusOrder = {'Perfect': 0, 'Good': 1, 'Bad': 2};
      // Compare nodes based on status order
      return statusOrder[a.status]!.compareTo(statusOrder[b.status]!);
    });

    return labeledNodes;
  }

   */

  static Future<List<Node>> labelAndOrderNodes(List<Node> nodes) async {
    // Get the user's current location
    Position? userPosition = await _getCurrentLocation();

    if (userPosition == null) {
      // Handle the case where user location is not available
      return nodes;
    }

    // Calculate distances for each node
    for (Node node in nodes) {
      double distance = await _calculateDistance(
        userPosition.latitude,
        userPosition.longitude,
        double.parse(node.latitude),
        double.parse(node.longitude),
      );

      Map<String, double> averageValues = await node.getAverageSensorValues();
      String status = node.evaluateNodeStatus(averageValues);
      node.status = status;
      node.distance = distance;
    }

    // Sort labeled nodes based on distance (closest to farthest)
    nodes.sort((a, b) {
      return a.distance!.compareTo(b.distance!);
    });

    // Resort nodes based on status (best to worst)
    nodes.sort((a, b) {
      // Define the order of statuses
      Map<String, int> statusOrder = {'Perfect': 0, 'Good': 1, 'Bad': 2};
      // Compare nodes based on status order
      return statusOrder[a.status]!.compareTo(statusOrder[b.status]!);
    });

    return nodes;
  }





  static Future<Position> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  static Future<double> _calculateDistance(
      double startLatitude,
      double startLongitude,
      double endLatitude,
      double endLongitude,
      ) async {
    String apiKey = GOOGLE_MAPS_API_KEY;
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$startLatitude,$startLongitude&destination=$endLatitude,$endLongitude&mode=driving&key=$apiKey';

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var routes = jsonResponse['routes'][0];
      var legs = routes['legs'][0];
      var distance = legs['distance'];
      distance = double.parse(distance['value'].toString())/1000;
      return distance;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      return double.infinity;
    }
  }

  Map<String, String> evaluateSensors(Map<String, double> sensorValues) {
    Map<String, String> sensorStatus = {};

    // Define the thresholds for each sensor type as ranges
    Map<String, Map<String, List<double>>> thresholds = {
      'temperature': {'Perfect': [0.0, 25.0], 'Good': [25.0, 30.0]},
      'humidity': {'Perfect': [0.0, 50.0], 'Good': [50.0, 60.0]},
      'gas': {'Perfect': [0.0, 100.0], 'Good': [100.0, 200.0]},
      'sound': {'Perfect': [0.0, 50.0], 'Good': [50.0, 75.0]},
      'dust': {'Perfect': [0.0, 10.0], 'Good': [10.0, 20.0]},
    };

    // Evaluate each sensor type
    sensorValues.forEach((type, value) {
      if (thresholds.containsKey(type)) {
        Map<String, List<double>> threshold = thresholds[type]!;
        String status = 'Bad'; // Default status if not within any range
        threshold.forEach((statusLabel, range) {
          if (value >= range[0] && value < range[1]) {
            status = statusLabel;
          }
        });
        sensorStatus[type] = status;
      } else {
        sensorStatus[type] = 'Undefined'; // Sensor type not defined in thresholds
      }
    });

    return sensorStatus;
  }




}

class Sensor {
  final double temperature;
  final double humidity;
  final double gas;
  final double sound;
  final double dust;
  final String date;

  Sensor({
    required this.temperature,
    required this.humidity,
    required this.gas,
    required this.sound,
    required this.dust,
    required this.date,
  });

  factory Sensor.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Sensor(
      temperature: data['temperature'] ?? 0.0,
      humidity: data['humidity'] ?? 0.0,
      gas: data['gas'] ?? 0.0,
      sound: data['sound'] ?? 0.0,
      dust: data['dust'] ?? 0.0,
      date: data['date'] ?? '',
    );
  }

  double getSensorValue(String sensorType) {
    switch (sensorType) {
      case 'temperature':
        return temperature;
      case 'humidity':
        return humidity;
      case 'gas':
        return gas;
      case 'sound':
        return sound;
      case 'dust':
        return dust;
      default:
        return 0.0;
    }
  }


}
