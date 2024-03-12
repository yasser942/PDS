import 'package:flutter/material.dart';
import 'package:flutter_thingspeak/flutter_thingspeak.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../models/channel_model.dart';

class ThingSpeak extends StatefulWidget {
  const ThingSpeak({super.key});

  @override
  State<ThingSpeak> createState() => _ThingSpeakState();
}

class _ThingSpeakState extends State<ThingSpeak> {
  final flutterThingspeak = FlutterThingspeakClient(
      channelID: '2462238', options: {'results': '10'});
  Channel? channel;
  List<Feed> feeds = <Feed>[];

  Future<void> getTemperatureData() async {
    flutterThingspeak.initialize();
    try {
      // Get data from the ThingSpeak channel
      final result = await flutterThingspeak.getFieldData('1');
      print(result);

      channel = Channel.fromJson(result);
      feeds = (result['feeds'] as List<dynamic>)
          .map((feed) => Feed.fromJson(feed))
          .toList();

      print(feeds);
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
      body: SafeArea(
        child: FutureBuilder(
          future: getTemperatureData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                // Display an error message if there was an error fetching data
                return Center(
                  child: Text('Error loading data: ${snapshot.error}'),
                );
              }

              if (channel != null) {
                return Column(
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
                            title: const Text("Channel ID"),
                            subtitle: Text(channel!.id.toString()),
                          ),
                          ListTile(
                            title: const Text("Channel Name"),
                            subtitle: Text(channel!.name),
                          ),
                          ListTile(
                            title: const Text("Channel Description"),
                            subtitle: Text(channel!.description),
                          ),
                          ListTile(
                            title: const Text("Location"),
                            subtitle: Text(
                                "${channel!.latitude.toString()},${channel!.longitude}"),
                          )
                        ],
                      ),
                    ),
                    SfCartesianChart(
                        primaryXAxis: const CategoryAxis(),
                        // Chart title
                        title: const ChartTitle(text: 'Temperature Data Chart'),
                        // Enable legend
                        legend: const Legend(isVisible: true),
                        // Enable tooltip
                        tooltipBehavior: TooltipBehavior(enable: true),
                        series: <CartesianSeries<Feed, String>>[
                          LineSeries<Feed, String>(
                              dataSource: feeds,
                              xValueMapper: (Feed feed, _) =>
                                  feed.createdAt.toString(),
                              yValueMapper: (Feed feed, _) => feed.field1,
                              name: 'Temperature',
                              // Enable data label
                              dataLabelSettings:  DataLabelSettings(
                                  isVisible: true, color:Theme.of(context).primaryColor))
                        ]),
                  ],
                );
              } else {
                // Display a message when data is not available
                return const Center(
                  child: Text('No data available.'),
                );
              }
            } else {
              // Display a loading indicator while data is being fetched
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
