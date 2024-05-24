import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pds/widgets/indicator.dart';

import '../models/Node.dart';
import '../widgets/animated-list-item.dart';

class MyGridView extends StatefulWidget {
  @override
  State<MyGridView> createState() => _MyGridViewState();
}

class _MyGridViewState extends State<MyGridView> {
  String _mode = 'walking';

  _switchMapMode() async {
    setState(() {
      _mode = (_mode == 'walking') ? 'driving' : 'walking';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Show indicator while fetching data
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AlertDialog(
                content: Row(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(width: 20),
                    Text('Fetching data...'),
                  ],
                ),
              );
            },
          );

          // Fetch and label nodes
          await fetchAndLabelNodes(_mode);
          _switchMapMode();
          // Close the indicator dialog
          Navigator.of(context).pop();
        },
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: _mode == 'walking'
            ? const Icon(
                Icons.directions_walk,
                color: Colors.white,
              )
            : const Icon(
                Icons.directions_car,
                color: Colors.white,
              ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() async {
            await fetchAndLabelNodes(_mode);
          });
        },
        child: FutureBuilder<List<Node>>(
          future: fetchAndLabelNodes(_mode),
          // Call the asynchronous function to fetch nodes
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Node> nodes = snapshot.data!;

              return ListView(
                physics: const BouncingScrollPhysics(),
                children: List.generate(
                  nodes.length,
                  (index) {
                    Node node = nodes[index];

                    return listItem(context, index, node, true);
                  },
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error fetching data'));
            } else {
              return Center(child: indicator(context));
            }
          },
        ),
      ),
    );
  }

  Future<List<Node>> fetchAndLabelNodes(String mode) async {
    print('Fetching nodes and sensors from Firestore...');
    QuerySnapshot nodesSnapshot =
        await FirebaseFirestore.instance.collection('nodes').get();

    List<Node> nodes = [];
    for (DocumentSnapshot nodeDoc in nodesSnapshot.docs) {
      // Get node data
      Map<String, dynamic> nodeData = nodeDoc.data() as Map<String, dynamic>;

      // Query for sensors subcollection
      QuerySnapshot sensorsSnapshot =
          await nodeDoc.reference.collection('sensors').get();

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
    List<Node> labeledNodes = await Node.labelAndOrderNodes(nodes, mode);

    return labeledNodes;
  }
}
