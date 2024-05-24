import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../models/Node.dart';
import '../screens/node.dart';

Widget listItem(BuildContext context, int index, Node node, bool clickable) {
  return Container(
    margin: const EdgeInsets.all(10),
    height: 400,
    width: double.infinity,
    // Make the width take the full available width
    decoration: BoxDecoration(
      image: DecorationImage(
        image: CachedNetworkImageProvider(node.imageUrl),
        fit: BoxFit.cover,
      ),
      borderRadius: BorderRadius.circular(25),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Theme.of(context).colorScheme.secondary,
          Theme.of(context).colorScheme.primary
        ],
      ),
    ),
    child: Stack(
      children: [
        Opacity(
          opacity: 1,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Theme.of(context).colorScheme.background,
                  const Color(0xFF000000).withOpacity(0.2),
                ],
              ),
            ),
            child: InkWell(
              onTap: () {
                // Add your onPressed action here
                if (clickable) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NodeDetail(
                              index: index,
                              node: node,
                            )),
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              '${node.name}',
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                              softWrap: true,
                            ),
                          ),
                          const Spacer(),
                          CircularPercentIndicator(
                            animation: true,
                            animationDuration: 1500,
                            radius: 40.0,
                            lineWidth: 5.0,
                            percent: node.status == 'Perfect'
                                ? 1
                                : (node.status == 'Bad' ? 0.3 : 0.75),
                            center: Text(
                              textAlign: TextAlign.center,
                              '${node.distance}\n km',
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            progressColor: node.status == 'Perfect'
                                ? Colors.green
                                : (node.status == 'Bad'
                                    ? Colors.red
                                    : Colors.yellow),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
