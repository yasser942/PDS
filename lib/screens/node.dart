import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:gemini_flutter/gemini_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:pds/screens/ai_assistance.dart';
import 'package:pds/screens/map_page.dart';
import 'package:pds/widgets/charts/line_chart_sample2.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class NodeDetail extends StatefulWidget {
  const NodeDetail({
    required this.index,
    required this.id,
    required this.temperature,
    required this.humidity,
    required this.gas,
    required this.sound,
    required this.dust,
    required this.nodes,
    required this.address,

    Key? key, required this.latitude, required this.longitude,
  }) : super(key: key);
  final int index;
  final String id;
  final double temperature;
  final double humidity;
  final int gas;
  final double sound;
  final int dust;
  final List nodes;
  final String address;
  final double latitude;
  final double longitude;


  @override
  State<NodeDetail> createState() => _NodeDetailState();
}

class _NodeDetailState extends State<NodeDetail> {
  final List<String> _sensors = ['temperature', 'humidity', 'gas', 'sound', 'dust'];
  final List<Image> _images = [
    Image.asset('assets/temperature.png'),
    Image.asset('assets/humidity.png'),
    Image.asset('assets/gas.png'),
    Image.asset('assets/sound.png'),
    Image.asset('assets/dust.png'),
  ];
  late Map<String, dynamic> data = {
    'temperature': 0,
    'humidity': 0,
    'gas': 0,
    'sound': 0,
    'dust': 0,
  };

  late GoogleMapController mapController;

  @override
  void initState() {
    super.initState();
     data = {
      'temperature': widget.temperature,
      'humidity': widget.humidity,
      'gas': widget.gas,
      'sound': widget.sound,
      'dust': widget.dust,
    };
  }
  String? textData;
  bool isLoading = false;

  getGeminiData() async {

    final response = await GeminiHandler().geminiPro(
        text:
        "I am in Hasan Ağa Bahçesi Izmir,please mention the place ,The weather is :hot and sunny. Potential health concerns: high UV index. Please provide recommendations for better health.");
    textData = response?.candidates?.first.content?.parts?.first.text ??
        "Failed to fetch data";
    textData=textData!.replaceAll('*', '');
    return textData;
  }




  @override
  Widget build(BuildContext context) {
    return DraggableHome(
      floatingActionButton: FloatingActionButton(

        onPressed: () async{
          setState(() { isLoading = true; }); // Start loading

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
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to fetch data')));
            }
          } finally {
            setState(() { isLoading = false; } ); // Stop loading
          }
        },
        child: const Icon(LineIcons.commentDots),
      ),
      appBarColor: Theme.of(context).colorScheme.secondary,
      fullyStretchable: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(widget.address),
      actions: [
        IconButton(onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ThingSpeak(),


            ),
          );

        }, icon: const Icon(Icons.bar_chart)),
      ],
      headerWidget: headerWidget(context ,widget.latitude, widget.longitude),
      headerBottomBar: headerBottomBarWidget(),
      body: [

        listView(),
        const SizedBox(
          height:10
        ),
        if (isLoading)
          const Center(
            child: CircularProgressIndicator(),
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
                    latitude: widget.latitude,
                    longitude: widget.longitude,
                    address: widget.address,
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.directions,
              size: 40,
            )),
      ],
    );
  }

  Widget headerWidget(BuildContext context ,double latitude, double longitude) {
    return GoogleMap(
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      onMapCreated: (GoogleMapController controller) {

        mapController = controller;
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(latitude, longitude),
              zoom: 15,
            ),
          ),
        );
      },
      initialCameraPosition: CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: 15,
      ),
      markers: {
        Marker(
          markerId: const MarkerId('1'),
          position: LatLng(latitude, longitude),
          onTap: () {
            print('Marker Tapped');
          },
        ),
      },
    );
  }

  ListView listView() {

    return ListView.builder(
      padding: const EdgeInsets.only(top: 0),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      shrinkWrap: true,
      itemBuilder: (context, index) => sensor(context,_images,data, _sensors,index),
    );
  }
}

Widget sensor (BuildContext context,List<Image>_images,Map data, List<String> sensors ,int index) {
  return Card(

    child: ListTile(
      leading: _images[index],

      trailing: CircularPercentIndicator(
        animation: true,
        animationDuration: 1500,

        radius: 25.0,
        lineWidth: 5.0,
        percent: index == 0 ? 1 : (index == 1 ? 0.3 : 0.75),

        center:  Text(

          index == 0 ? 'Perfect' : (index == 1 ? 'Bad' : 'Good'),
          style: const TextStyle(
            fontSize: 10,
          )

        ),
        progressColor: index == 0 ? Colors.green : (index == 1 ? Colors.red : Colors.yellow),
      ),
     
      title: Text('${sensors[index].toUpperCase()}'),
      subtitle: Text('${data[sensors[index]]}'),

    ),
  );
}
/*
getGeminiData() async {
  final response = await GeminiHandler().geminiPro(
      text:
      "I am in Hasan Ağa Bahçesi Izmir,please mention the place ,The weather is :hot and sunny. Potential health concerns: high UV index. Please provide recommendations for better health.");
  textData = response?.candidates?.first.content?.parts?.first.text ??
      "Failed to fetch data";
  return textData;
}
*/