import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/Node2.dart';

class Test extends StatefulWidget {
  @override
  _Test createState() => _Test();
}

class _Test extends State<Test> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //calculateDistance();
    getDistance();
  }

  void calculateDistance() async {
    // Let's assume these are your coordinates

    double startLatitude = 38.3548489070842;
    double startLongitude = 27.231289842590055;

    // And these are the coordinates of the other point

    double endLatitude = 38.41528959118612 ;
    double endLongitude = 27.122969807156785;

    // Calculate the distance between the points
    double distanceInMeters = Geolocator.distanceBetween(startLatitude, startLongitude, endLatitude, endLongitude);
    double distanceInKm = distanceInMeters / 1000;

    print('The distance between the two points is $distanceInKm km.');
  }
  void getDistance() async {
    String startLatitude = '38.3548489070842';
    String startLongitude = '27.231289842590055';
    String endLatitude = '38.41528959118612';
    String endLongitude = '27.122969807156785';
    String apiKey = 'AIzaSyAIETSLzFWijOhzN-aCTTW8C-mzFs-5FBs';

    //String url = 'https://maps.googleapis.com/maps/api/directions/json?origin=$startLatitude,$startLongitude&destination=$endLatitude,$endLongitude&key=$apiKey';
    String url = 'https://maps.googleapis.com/maps/api/directions/json?origin=$startLatitude,$startLongitude&destination=$endLatitude,$endLongitude&mode=walking&key=$apiKey';

    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var routes = jsonResponse['routes'][0];
      var legs = routes['legs'][0];
      var distance = legs['distance'];
      print('The distance between the two points is ${distance['text']}');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore Data Example'),
      ),
      body: FutureBuilder<List<Node>>(
        future: fetchAndLabelNodes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('No data available');
          } else {
            List<Node> nodes = snapshot.data!;
            return ListView.builder(
              itemCount: nodes.length,
              itemBuilder: (context, index) {
                Node node = nodes[index];
                return ListTile(
                  title: Text(node.status + ' ' + node.name),
                  subtitle: Text(node.distance.toString() + ' km'   ),
                  onTap: () {
                    // Handle node tap
                    // You can access node.sensors for sensor data
                    print('Node tapped: ${node.name}');
                  },
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Node>> fetchAndLabelNodes() async {
    QuerySnapshot nodesSnapshot = await FirebaseFirestore.instance.collection('nodes').get();

    List<Node> nodes = [];
    for (DocumentSnapshot nodeDoc in nodesSnapshot.docs) {
      // Get node data
      Map<String, dynamic> nodeData = nodeDoc.data() as Map<String, dynamic>;

      // Query for sensors subcollection
      QuerySnapshot sensorsSnapshot = await nodeDoc.reference.collection('sensors').get();

      // Extract sensor data
      List<Sensor> sensors = [];
      for (DocumentSnapshot sensorDoc in sensorsSnapshot.docs) {
        sensors.add(Sensor.fromSnapshot(sensorDoc));
      }

      // Create Node object with sensors
      Node node = Node.fromMap(nodeData, sensors);
      nodes.add(node);
    }

    // Label the nodes
    List<Node> labeledNodes = await Node.labelAndOrderNodes(nodes,"walking");

    return labeledNodes;
  }
}
