import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pds/widgets/animated-list-item.dart';
import 'package:shaky_animated_listview/widgets/animated_listview.dart';

import '../models/Node.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  List<Node> nodes = []; // Initialize empty list to store retrieved nodes

  @override
  void initState() {
    super.initState();
    loadData(); // Load data from Firebase when the widget is initialized
  }

  Future<void> loadData() async {
    nodes = [];
    final ref = FirebaseDatabase.instance.ref('nodes/');
    final snapshot = await ref.get();

    if (snapshot.exists) {
      for (DataSnapshot child in snapshot.children) {
        final node = Node.fromJson(child.value);
        nodes.add(node);
      }
      setState(() {}); // Rebuild widget after data is loaded
      print('Data loaded successfully.');
    } else {
      print('No data available.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Hello'),
    );
  }
}
