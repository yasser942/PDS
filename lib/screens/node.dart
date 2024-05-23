import 'dart:collection';

import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:gemini_flutter/gemini_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pds/screens/ai_assistance.dart';
import 'package:pds/screens/map_page.dart';
import 'package:pds/screens/node-statistics.dart';
import 'package:pds/widgets/indicator.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../models/Node2.dart';

class NodeDetail extends StatefulWidget {
  const NodeDetail({
    required this.index,
    required this.node,
    Key? key,
  }) : super(key: key);
  final int index;
  final Node node;

  @override
  State<NodeDetail> createState() => _NodeDetailState();
}

class _NodeDetailState extends State<NodeDetail> {
  final List<Image> _images = [
    Image.asset('assets/temperature.png'),
    Image.asset('assets/humidity.png'),
    Image.asset('assets/gas.png'),
    Image.asset('assets/sound.png'),
    Image.asset('assets/dust.png'),
  ];

  final List<String> _sensors = [
    'temperature',
    'humidity',
    'gas',
    'sound',
    'dust'
  ];
  final List<String> _units = ['°C', '%', 'ppm', 'dB', 'ppm'];
  Map<String, double> averageValues = {};
  Map<String, String> sensorStatus = {};

  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
  }

  Future<Map<String, double>> fetchSensorData() async {
    try {
      Map<String, double> averageValues =
          await widget.node.getAverageSensorValues();
      sensorStatus = widget.node.evaluateSensors(averageValues);

      return averageValues;
    } catch (e) {
      throw e;
    }
  }

  String? textData;
  bool isLoading = false;

  getGeminiData() async {
    if (averageValues.isEmpty) {
      averageValues = await widget.node.getAverageSensorValues();
      sensorStatus = widget.node.evaluateSensors(averageValues);
    }
    final response = await GeminiHandler().geminiPro(
        text:
            "I am in ${widget.node.name} , the latitude is ${widget.node.latitude} and the longitude is ${widget.node.longitude} ,"
            "The temperature is ${averageValues['temperature']} degrees,"
            "The humidity is ${averageValues['humidity']} percent,"
            "The gas level is ${averageValues['gas']} ppm,"
            "The sound level is ${averageValues['sound']} decibels,"
            "The dust level is ${averageValues['dust']} ppm,"
            "Please provide recommendation.");
    textData = response?.candidates?.first.content?.parts?.first.text ??
        "Failed to fetch data";
    return textData;
  }

  @override
  Widget build(BuildContext context) {
    return DraggableHome(

      backgroundColor: Theme.of(context).colorScheme.background,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        onPressed: () async {
          setState(() {
            isLoading = true;
          }); // Start loading

          try {
            await getGeminiData();
            // Navigate only if the data fetch was successful
            if (textData != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AIAssistance(textData: textData),
                ),
              );
            } else {
              // Handle the error case, e.g., display an error message
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to fetch data')));
            }
          } finally {
            setState(() {
              isLoading = false;
            }); // Stop loading
          }
        },
        child: const Icon(LineIcons.commentDots, color: Colors.white),
      ),
      appBarColor: Theme.of(context).colorScheme.secondary,
      fullyStretchable: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(widget.node.name),
      actions: [
        IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>  NodeStatistics(node:widget.node ),
                ),
              );
            },
            icon: const Icon(Icons.bar_chart)),
      ],
      headerWidget: headerWidget(context, double.parse(widget.node.latitude),
          double.parse(widget.node.longitude)),
      headerBottomBar: headerBottomBarWidget(),
      body: [
        listView(),
        const SizedBox(height: 10),
        if (isLoading)
          Center(
            child: indicator(context),
          )
      ],
    );
  }

  Row headerBottomBarWidget() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapPage(
                    latitude: double.parse(widget.node.latitude),
                    longitude: double.parse(widget.node.longitude),
                    address: widget.node.name,
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.directions,
              color: Colors.white,
              size: 40,
            )),
      ],
    );
  }

  Widget headerWidget(BuildContext context, double latitude, double longitude) {
    return Image.network(
      widget.node.imageUrl,
      fit: BoxFit.cover,
    );
  }

  Widget listView() {
    return FutureBuilder<Map<String, double>>(
      future: fetchSensorData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: indicator(context));
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          Map<String, double> averageValues = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.only(top: 0),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            shrinkWrap: true,
            itemBuilder: (context, index) => sensor(
                context,
                _images,
                widget.node.sensors,
                averageValues,
                index,
                _sensors,
                _units,
                sensorStatus),
          );
        }
      },
    );
  }
}

Widget sensor(
    BuildContext context,
    List<Image> _images,
    List<Sensor> sensors,
    Map<String, dynamic> averageValues,
    int index,
    List<String> _sensors,
    List<String> _units,
    Map<String, String> sensorStatus) {
  return Card(
    color: Theme.of(context).colorScheme.secondary,
    child: ListTile(
      leading: _images[index],
      isThreeLine: true,
      trailing: CircularPercentIndicator(
        animation: true,
        animationDuration: 1500,
        radius: 25.0,
        lineWidth: 5.0,
        percent: sensorStatus[_sensors[index]] == 'Perfect'
            ? 1
            : (sensorStatus[_sensors[index]] == 'Bad' ? 0.3 : 0.75),
        center: Text(sensorStatus[_sensors[index]] ?? '',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
            )),
        progressColor: sensorStatus[_sensors[index]] == 'Perfect'
            ? Colors.green
            : (sensorStatus[_sensors[index]] == 'Bad'
                ? Colors.red
                : Colors.yellow),
      ),
      title: Text(
        _sensors[index].toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
        ),
      ),
      subtitle: Text('${averageValues[_sensors[index]]} ${_units[index]}',
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          )),
    ),
  );
}
