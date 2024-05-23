import 'package:flutter/material.dart';
import 'package:pds/widgets/indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class NodeStatistics extends StatefulWidget {
  const NodeStatistics({super.key, this.node});

  final node;

  @override
  State<NodeStatistics> createState() => _NodeStatisticsState();
}

class _NodeStatisticsState extends State<NodeStatistics> {
  List<Feed> feeds = <Feed>[];
  List<Feed> gasFeeds = <Feed>[];
  List<Feed> soundFeeds = <Feed>[];
  List<Feed> dustFeeds = <Feed>[];
  List<Feed> humidityFeeds = <Feed>[];

  Future<void> getTemperatureData() async {
    try {
      // Dummy data
      final List<Map<String, dynamic>> dummyData = [
        {'created_at': '2024-05-10', 'field1': 23.5},
        {'created_at': '2024-05-11', 'field1': 24.0},
        {'created_at': '2024-05-12', 'field1': 22.8},
        {'created_at': '2024-05-13', 'field1': 23.1},
        {'created_at': '2024-05-14', 'field1': 23.9},
        {'created_at': '2024-05-15', 'field1': 24.3},
        {'created_at': '2024-05-16', 'field1': 22.7},
        {'created_at': '2024-05-17', 'field1': 23.4},
        {'created_at': '2024-05-18', 'field1': 24.1},
        {'created_at': '2024-05-19', 'field1': 23.6},
      ];

      feeds = dummyData.map((data) => Feed.fromJson(data)).toList();
    } catch (e) {
      print(e);
    }
  }

  Future<void> getGazData() async {
    try {
      // Dummy data
      final List<Map<String, dynamic>> dummyData = [
        {'created_at': '2024-05-10', 'field1': 100.5},
        {'created_at': '2024-05-11', 'field1': 101.0},
        {'created_at': '2024-05-12', 'field1': 102.8},
        {'created_at': '2024-05-13', 'field1': 103.1},
        {'created_at': '2024-05-14', 'field1': 104.9},
        {'created_at': '2024-05-15', 'field1': 105.3},
        {'created_at': '2024-05-16', 'field1': 106.7},
        {'created_at': '2024-05-17', 'field1': 107.4},
        {'created_at': '2024-05-18', 'field1': 108.1},
        {'created_at': '2024-05-19', 'field1': 109.6},
      ];

      gasFeeds = dummyData.map((data) => Feed.fromJson(data)).toList();
    } catch (e) {
      print(e);
    }
  }

  Future<void> getSoundDta() async {
    try {
      // Dummy data
      final List<Map<String, dynamic>> dummyData = [
        {'created_at': '2024-05-10', 'field1': 50.5},
        {'created_at': '2024-05-11', 'field1': 51.0},
        {'created_at': '2024-05-12', 'field1': 52.8},
        {'created_at': '2024-05-13', 'field1': 53.1},
        {'created_at': '2024-05-14', 'field1': 54.9},
        {'created_at': '2024-05-15', 'field1': 55.3},
        {'created_at': '2024-05-16', 'field1': 56.7},
        {'created_at': '2024-05-17', 'field1': 57.4},
        {'created_at': '2024-05-18', 'field1': 58.1},
        {'created_at': '2024-05-19', 'field1': 59.6},
      ];

      soundFeeds = dummyData.map((data) => Feed.fromJson(data)).toList();
    } catch (e) {
      print(e);
    }
  }

  Future<void> getDustData() async {
    try {
      // Dummy data
      final List<Map<String, dynamic>> dummyData = [
        {'created_at': '2024-05-10', 'field1': 75.5},
        {'created_at': '2024-05-11', 'field1': 76.0},
        {'created_at': '2024-05-12', 'field1': 77.8},
        {'created_at': '2024-05-13', 'field1': 78.1},
        {'created_at': '2024-05-14', 'field1': 79.9},
        {'created_at': '2024-05-15', 'field1': 80.3},
        {'created_at': '2024-05-16', 'field1': 81.7},
        {'created_at': '2024-05-17', 'field1': 82.4},
        {'created_at': '2024-05-18', 'field1': 83.1},
        {'created_at': '2024-05-19', 'field1': 84.6},
      ];

      dustFeeds = dummyData.map((data) => Feed.fromJson(data)).toList();
    } catch (e) {
      print(e);
    }
  }

  Future<void> getHumidityData() async {
    try {
      // Dummy data
      final List<Map<String, dynamic>> dummyData = [
        {'created_at': '2024-05-10', 'field1': 60.5},
        {'created_at': '2024-05-11', 'field1': 61.0},
        {'created_at': '2024-05-12', 'field1': 62.8},
        {'created_at': '2024-05-13', 'field1': 63.1},
        {'created_at': '2024-05-14', 'field1': 64.9},
        {'created_at': '2024-05-15', 'field1': 65.3},
        {'created_at': '2024-05-16', 'field1': 66.7},
        {'created_at': '2024-05-17', 'field1': 67.4},
        {'created_at': '2024-05-18', 'field1': 68.1},
        {'created_at': '2024-05-19', 'field1': 69.6},

      ];

      humidityFeeds = dummyData.map((data) => Feed.fromJson(data)).toList();
    } catch (e) {
      print(e);
    }
  }

  Future<void> getSensorsData() async {
    try {
      await getTemperatureData();
      await getGazData();
      await getSoundDta();
      await getDustData();
      await getHumidityData();
    } catch (e) {
      print(e);
    }
  }


  @override
  void initState() {
    super.initState();
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

              if (feeds.isNotEmpty) {
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
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
                      ),
                      Chart(
                          feeds: feeds,
                          name: 'Temperature',
                          label: 'Temperature',
                          color: Colors.redAccent),
                      const SizedBox(height: 10),
                      Chart(
                          feeds: humidityFeeds,
                          name: 'Humidity',
                          label: 'Humidity',
                          color: Colors.blueAccent),
                      const SizedBox(height: 10),
                      Chart(
                          feeds: gasFeeds,
                          name: 'Gas',
                          label: 'Gas',
                          color: Colors.greenAccent),
                      const SizedBox(height: 10),
                      Chart(
                          feeds: soundFeeds,
                          name: 'Sound',
                          label: 'Sound',
                          color: Colors.purpleAccent),
                      const SizedBox(height: 10),
                      Chart(
                          feeds: dustFeeds,
                          name: 'Dust',
                          label: 'Dust',
                          color: Colors.orangeAccent),
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

class Chart extends StatelessWidget {
  final List<Feed> feeds;
  final name;
  final label;
  final Color color;

  const Chart(
      {super.key,
      required this.feeds,
      this.name,
      this.label,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: const CategoryAxis(),
      title: ChartTitle(text: '$name Data Chart'),
      legend: const Legend(isVisible: true),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CartesianSeries<Feed, String>>[
        LineSeries<Feed, String>(
          dataSource: feeds,
          xValueMapper: (Feed feed, _) => feed.createdAt.toString(),
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

  factory Feed.fromJson(Map<String, dynamic> json) {
    return Feed(
      createdAt: json['created_at'] as String,
      field1: (json['field1'] as num).toDouble(),
    );
  }
}
