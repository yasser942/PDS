import 'package:flutter/material.dart';
import 'grid_item.dart';

class MyGridView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      itemCount: 3,
      itemBuilder: (BuildContext context, int index) {
        return GridItem(index + 1);
      },
    );
  }
}
