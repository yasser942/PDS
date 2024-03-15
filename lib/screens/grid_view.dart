import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../models/Node2.dart';
import '../widgets/animated-list-item.dart';

class MyGridView extends StatefulWidget {
  @override
  State<MyGridView> createState() => _MyGridViewState();
}

class _MyGridViewState extends State<MyGridView> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {fetchNodes();});
      },
      child: FutureBuilder<List<Node>>(
        future: fetchNodes(), // Call the asynchronous function to fetch nodes
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Node> nodes = snapshot.data!;

            return ListView(
              physics: const BouncingScrollPhysics(),
              children: List.generate(
                nodes.length,
                (index){
                  Node node = nodes[index];

                  return ListItem(context, index, node);

                },
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching data'));
          } else {
            return Center(child: CircularProgressIndicator());
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

    return nodes;
  }
}
