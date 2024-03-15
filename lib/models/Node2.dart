import 'package:cloud_firestore/cloud_firestore.dart';

class Node {
  final String id;
  final String name;
  final String latitude;
  final String longitude;
  final String imageUrl;
  final List<Sensor> sensors;

  Node({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.sensors,
    required this.imageUrl,
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

  Future<Map<String, double>> getAverageSensorValues(String nodeId) async {
    Map<String, double> averageValues = {};
    for (String sensorType in ['temperature', 'humidity', 'gas', 'sound', 'dust']) {
      QuerySnapshot sensorSnapshot = await FirebaseFirestore.instance
          .collection('nodes')
          .doc(nodeId)
          .collection('sensors')
          .orderBy('date', descending: true)
          .limit(5)
          .get();

      List<double> sensorValues = sensorSnapshot.docs
          .map((doc) => Sensor.fromSnapshot(doc).getSensorValue(sensorType))
          .toList();

      double averageValue = sensorValues.reduce((a, b) => a + b) / sensorValues.length;
      averageValue=double.parse(averageValue.toStringAsFixed(2));

      averageValues[sensorType] = averageValue;
    }
    return averageValues;
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
