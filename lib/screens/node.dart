import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pds/screens/MapPage.dart';

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
    // TODO: implement initState
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
      expandedBody: MapPage(),
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
                MaterialPageRoute(builder: (context) => MapPage()),
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
      mapToolbarEnabled: false,
      zoomControlsEnabled: false,
      scrollGesturesEnabled: false,
      initialCameraPosition:  CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: 15,
      ),
      markers: Set<Marker>.from([
        Marker(
          markerId: const MarkerId('marker_1'),
          position:  LatLng(latitude, longitude),
          infoWindow: InfoWindow(
            title: '${widget.id}',
            snippet: '5 Star Rating',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      ]),
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

      trailing: _images[index],
     
      title: Text('${sensors[index]}'),
      subtitle: Text('${data[sensors[index]]}'),

    ),
  );
}