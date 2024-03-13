import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../models/Node2.dart';
import '../screens/node.dart';


Widget ListItem (BuildContext context ,int index,Node node) {
  return Container(
    margin: const EdgeInsets.all(10),
    height: 400,
    width: 200,
    decoration: BoxDecoration(
      image:  DecorationImage(
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
                  Colors.white,
                  const Color(0xFF000000).withOpacity(0.2),
                ],
              ),
            ),
            child: InkWell(
              onTap: () {
                // Add your onPressed action here
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NodeDetail(
                    index: index,
                    node: node,
                  )),
                );

              /*  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NodeDetail(
                    index: index,
                    id: id,
                    temperature: temperature,
                    humidity: humidity,
                    gas: gas,
                    sound: sound,
                    dust: dust,
                    nodes: nodes,
                    address: address,
                    latitude: latitude,
                    longitude: longitude,
                  )),
                );*/
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
                              style:const TextStyle(
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

                            radius: 35.0,
                            lineWidth: 5.0,
                             percent: index == 0 ? 1 : (index == 1 ? 0.3 : 0.75),

                             center:  Text(
                               index == 0 ? 'Perfect' : (index == 1 ? 'Bad' : 'Good'),

                             ),
                            progressColor: index == 0 ? Colors.green : (index == 1 ? Colors.red : Colors.yellow),
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