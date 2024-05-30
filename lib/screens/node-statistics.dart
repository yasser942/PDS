import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pds/widgets/indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../widgets/animated-list-item.dart';

class NodeStatistics extends StatefulWidget {
  const NodeStatistics({super.key, this.node});

  final node;

  @override
  State<NodeStatistics> createState() => _NodeStatisticsState();
}

class _NodeStatisticsState extends State<NodeStatistics> {
  List<Feed> temperatureFeeds = <Feed>[];
  List<Feed> gasFeeds = <Feed>[];
  List<Feed> soundFeeds = <Feed>[];
  List<Feed> dustFeeds = <Feed>[];
  List<Feed> humidityFeeds = <Feed>[];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Feed>> fetchSensorData(String nodeId, String sensorType) async {
    List<Feed> sensorFeeds = [];
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('nodes')
          .doc(nodeId)
          .collection('sensors')
          .where(sensorType, isGreaterThan: 0) // Filter for existing data
          .get();

      Map<String, List<double>> dailyValues = {};

      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        DateTime date =
            DateTime.parse(data['date']); // Parsing date from string
        String formattedDate = DateFormat('yyyy-MM-dd').format(date);

        if (!dailyValues.containsKey(formattedDate)) {
          dailyValues[formattedDate] = [];
        }
        dailyValues[formattedDate]!.add(data[sensorType]);
      }

      List<String> sortedDates = dailyValues.keys.toList()..sort();
      List<String> recentThreeDays = sortedDates.reversed.take(5).toList();

      for (String date in recentThreeDays) {
        List<double> values = dailyValues[date]!;
        double mean = values.reduce((a, b) => a + b) / values.length;
        mean =
            double.parse(mean.toStringAsFixed(1)); // Round to 1 decimal place
        sensorFeeds.add(Feed(createdAt: date, field1: mean));
      }

      return sensorFeeds;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Feed>> fetchPredictions(String nodeId, String sensorType) async {
    List<Feed> predictions = [];
    try {
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
      final response = await http.get(
          Uri.parse('http://192.168.1.104:5001/predict/$nodeId/$sensorType'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        predictions =
            data.map((item) => Feed.fromJson(item, sensorType)).toList();
        print('Predictions fetched for $sensorType: $predictions');
        // Close the indicator dialog
        Navigator.of(context).pop();
      } else {
        throw Exception('Failed to load predictions');
      }
    } catch (e) {
      print(e);
    }
    return predictions;
  }

  Future<void> getSensorsData() async {
    try {
      temperatureFeeds = await fetchSensorData(widget.node!.id, 'temperature');
      gasFeeds = await fetchSensorData(widget.node!.id, 'gas');
      soundFeeds = await fetchSensorData(widget.node!.id, 'sound');
      dustFeeds = await fetchSensorData(widget.node!.id, 'dust');
      humidityFeeds = await fetchSensorData(widget.node!.id, 'humidity');
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getSensorsData();
  }

  void showPredictionDialog(BuildContext context, String sensorType,
      List<Feed> predictions, Color color) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: Chart(
              feeds: predictions,
              name: '$sensorType Predictions',
              label: '$sensorType Predictions',
              color: color,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.node!.name} Statistics'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: getSensorsData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error loading data: ${snapshot.error}'),
                );
              }

              if (temperatureFeeds.isNotEmpty ||
                  gasFeeds.isNotEmpty ||
                  soundFeeds.isNotEmpty ||
                  dustFeeds.isNotEmpty ||
                  humidityFeeds.isNotEmpty) {
                return SingleChildScrollView(
                  child: Column(

                    children: [
                      /*Container(
                        margin: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black45, width: .5),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                        ),
                        child: ListBody(
                          children: [
                            ListTile(
                              title: const Text("Park ID"),
                              subtitle: Text(widget.node!.id.toString()),
                            ),
                            ListTile(
                              title: const Text("Park Name"),
                              subtitle: Text(widget.node!.name),
                            ),
                            ListTile(
                              title: const Text("Location"),
                              subtitle: Text(
                                  "${widget.node!.latitude.toString()},${widget.node!.longitude}"),
                            ),
                          ],
                        ),
                      ),*/
                      listItem(context, 0, widget.node ,false),
                      const Divider(
                        color: Colors.black54,
                        thickness: 0.5,
                      ),
                      SensorCard(
                        sensorName: 'Temperature',
                        sensorType: 'temperature °C',
                        feeds: temperatureFeeds,
                        color: Colors.redAccent,
                        onPredict: () async {
                          List<Feed> predictions = await fetchPredictions(
                              widget.node!.id, 'temperature');
                          showPredictionDialog(context, 'Temperature',
                              predictions, Colors.redAccent);
                        },
                      ),
                      const Divider(
                        color: Colors.black54,
                        thickness: 0.5,
                      ),
                      SensorCard(
                        sensorName: 'Humidity',
                        sensorType: 'humidity %',
                        feeds: humidityFeeds,
                        color: Colors.blueAccent,
                        onPredict: () async {
                          List<Feed> predictions = await fetchPredictions(
                              widget.node!.id, 'humidity');
                          showPredictionDialog(context, 'Humidity', predictions,
                              Colors.blueAccent);
                        },
                      ),
                      const Divider(
                        color: Colors.black54,
                        thickness: 0.5,
                      ),
                      SensorCard(
                        sensorName: 'Gas',
                        sensorType: 'gas ppm',
                        feeds: gasFeeds,
                        color: Colors.greenAccent,
                        onPredict: () async {
                          List<Feed> predictions =
                              await fetchPredictions(widget.node!.id, 'gas');
                          showPredictionDialog(
                              context, 'Gas', predictions, Colors.greenAccent);
                        },
                      ),
                      const Divider(
                        color: Colors.black54,
                        thickness: 0.5,
                      ),
                      SensorCard(
                        sensorName: 'Sound',
                        sensorType: 'sound dB',
                        feeds: soundFeeds,
                        color: Colors.purpleAccent,
                        onPredict: () async {
                          List<Feed> predictions =
                              await fetchPredictions(widget.node!.id, 'sound');
                          showPredictionDialog(context, 'Sound', predictions,
                              Colors.purpleAccent);
                        },
                      ),
                      const Divider(
                        color: Colors.black54,
                        thickness: 0.5,
                      ),
                      SensorCard(
                        sensorName: 'Dust',
                        sensorType: 'dust ppm',
                        feeds: dustFeeds,
                        color: Colors.orangeAccent,
                        onPredict: () async {
                          List<Feed> predictions =
                              await fetchPredictions(widget.node!.id, 'dust');
                          showPredictionDialog(context, 'Dust', predictions,
                              Colors.orangeAccent);
                        },
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: Text('No data available.'),
                );
              }
            } else {
              return Center(
                child: indicator(context),
              );
            }
          },
        ),
      ),
    );
  }
}

class SensorCard extends StatelessWidget {
  final String sensorName;
  final String sensorType;
  final List<Feed> feeds;
  final Color color;
  final VoidCallback onPredict;

  const SensorCard({
    super.key,
    required this.sensorName,
    required this.sensorType,
    required this.feeds,
    required this.color,
    required this.onPredict,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Chart(
          feeds: feeds,
          name: sensorName,
          label: sensorType,
          color: color,
        ),
        IconButton(
          onPressed: onPredict,
          icon: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.show_chart,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(width: 5),
              Text(
                'Discover the ${sensorName.toLowerCase()} for the next 3 days',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          tooltip:
              'Discover the ${sensorName.toLowerCase()} for the next 3 days',
          color: Theme.of(context).colorScheme.secondary,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class Chart extends StatelessWidget {
  final List<Feed> feeds;
  final String name;
  final String label;
  final Color color;

  const Chart({
    super.key,
    required this.feeds,
    required this.name,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      enableAxisAnimation: true,
      primaryXAxis: const CategoryAxis(),
      title: ChartTitle(text: '$name'),
      legend: const Legend(isVisible: true),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CartesianSeries<Feed, String>>[
        LineSeries<Feed, String>(
          dataSource: feeds,
          xValueMapper: (Feed feed, _) => feed.createdAt,
          yValueMapper: (Feed feed, _) => feed.field1,
          name: label,
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            color: color,
          ),
        ),
      ],
    );
  }
}

class Feed {
  String createdAt;
  double field1;

  Feed({required this.createdAt, required this.field1});

  factory Feed.fromJson(Map<String, dynamic> json, String sensorType) {
    return Feed(
      createdAt: json['date'] as String,
      field1:
          json[sensorType] != null ? (json[sensorType] as num).toDouble() : 0.0,
    );
  }
}
