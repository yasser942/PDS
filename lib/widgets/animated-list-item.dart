import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../screens/node.dart';


Widget ListItem (BuildContext context ,int index,String imageUrl ,String id,double temperature,double humidity,int gas,double sound,int dust ,List nodes) {
  return Container(
    margin: const EdgeInsets.all(10),
    height: 400,
    width: 200,
    decoration: BoxDecoration(
      image:  DecorationImage(
        image: CachedNetworkImageProvider(imageUrl),
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
          opacity: 0.8,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.white,
                  Color(0xFF000000).withOpacity(0.2),
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
                    id: id,
                    temperature: temperature,
                    humidity: humidity,
                    gas: gas,
                    sound: sound,
                    dust: dust,
                    nodes: nodes,

                  )),
                );
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
                          Text(
                            '$id',
                            style:
                            Theme.of(context).textTheme.headline6,
                          ),
                          const Spacer(),
                           CircularPercentIndicator(
                            radius: 35.0,
                            lineWidth: 5.0,
                            percent: 1.0,
                            center:  const Text("Good"),
                            progressColor: Colors.green,
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