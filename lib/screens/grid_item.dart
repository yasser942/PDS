import 'package:flutter/material.dart';

class GridItem extends StatelessWidget {
  final int itemNumber;

  const GridItem(this.itemNumber, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: () {
          // Add your action when the grid item is tapped
        },
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'Item $itemNumber',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ),
      ),
    );
  }
}
