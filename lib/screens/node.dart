import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pds/pages/map_page.dart';
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


  @override
  Widget build(BuildContext context) {
    return DraggableHome(
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
        IconButton(onPressed: () {}, icon: const Icon(Icons.bar_chart)),
      ],
      headerWidget: headerWidget(context ,widget.latitude, widget.longitude),
      headerBottomBar: headerBottomBarWidget(),
      body: [
        listView(),
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
          markerId: MarkerId('1'),
          position: LatLng(latitude, longitude),
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
          style: TextStyle(
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