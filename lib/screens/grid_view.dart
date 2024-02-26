import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../models/Node.dart';
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
            final nodes = snapshot.data!;
            return ListView(
              physics: const BouncingScrollPhysics(),
              children: List.generate(
                nodes.length,
                (index) => ListItem(
                  context,
                  index,
                  nodes[index].imageUrl,
                  nodes[index].id,
                  nodes[index].temperature,
                  nodes[index].humidity,
                  nodes[index].gas,
                  nodes[index].sound,
                  nodes[index].dust,
                  nodes,
                  nodes[index].address,
                  nodes[index].latitude,
                  nodes[index].longitude,
                ),
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
    final ref = FirebaseDatabase.instance.ref('nodes/');
    final snapshot = await ref.get();

    final nodes = <Node>[];
    if (snapshot.exists) {
      for (DataSnapshot child in snapshot.children) {
        final node = Node.fromJson(child.value);
        nodes.add(node);
      }
    }
    return nodes;
  }
}
