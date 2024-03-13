import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/Node2.dart';





class Test extends StatefulWidget {
  @override
  _Test createState() => _Test();
}

class _Test extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore Data Example'),
      ),
      body: FutureBuilder<List<Node>>(
        future: fetchNodes(),
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
                  title: Text(node.name),
                  subtitle: Text('Latitude: ${node.latitude}, Longitude: ${node.longitude}'),
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

  Future<List<Node>> fetchNodes() async {
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
    print(nodes[0].sensors[0]);

    return nodes;
  }
}

