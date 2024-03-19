import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/Node2.dart';
import '../widgets/animated-list-item.dart';

class MyGridView extends StatefulWidget {
  @override
  State<MyGridView> createState() => _MyGridViewState();
}

class _MyGridViewState extends State<MyGridView> {
  String _mode = 'walking';
  _switchMapMode() {
    setState(() {
      if (_mode == 'walking') {
        _mode = 'driving';
      } else {
        _mode = 'walking';
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _switchMapMode();
        },
        backgroundColor: Theme.of(context).colorScheme.secondary,
        child: _mode == 'walking'
            ? const Icon(Icons.directions_walk, color: Colors.white,)
            : const Icon(Icons.directions_car, color: Colors.white,),

      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            fetchAndLabelNodes();
          });
        },
        child: FutureBuilder<List<Node>>(
          future: fetchAndLabelNodes(),
          // Call the asynchronous function to fetch nodes
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Node> nodes = snapshot.data!;

              return AnimatedSwitcher(
                  switchInCurve: Curves.elasticOut,
                  switchOutCurve: Curves.ease,
                  reverseDuration: const Duration(milliseconds: 200),
                  duration: const Duration(milliseconds: 1200),
                  transitionBuilder: (child, animation) => ScaleTransition(
                    scale: animation,
                    child: child,
                  ),
                  child: snapshot.connectionState == ConnectionState.waiting
                      ? const Center(child: CircularProgressIndicator.adaptive())
                      : ListView(
                    physics: const BouncingScrollPhysics(),
                    children: List.generate(
                      nodes.length,
                          (index) {
                        Node node = nodes[index];

                        return ListItem(context, index, node);
                      },
                    ),
                  ));
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error fetching data'));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Future<List<Node>> fetchAndLabelNodes() async {
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
    List<Node> labeledNodes = await Node.labelAndOrderNodes(nodes,_mode);

    return labeledNodes;
  }
}
