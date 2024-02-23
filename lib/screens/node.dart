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
    Key? key,
  }) : super(key: key);
  final int index;
  final String id;
  final double temperature;
  final double humidity;
  final int gas;
  final double sound;
  final int dust;
  final List nodes;


  @override
  State<NodeDetail> createState() => _NodeDetailState();
}

class _NodeDetailState extends State<NodeDetail> {
  final List<String> _sensors = ['temperature', 'humidity', 'gas', 'sound', 'dust'];

  late GoogleMapController mapController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return DraggableHome(
      fullyStretchable: false,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text('${widget.id}'),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.bar_chart)),
      ],
      headerWidget: headerWidget(context),
      headerBottomBar: headerBottomBarWidget(),
      body: [
        listView(),
      ],
      expandedBody: MapPage(),
      backgroundColor: Colors.white,
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

  Widget headerWidget(BuildContext context) {
    return GoogleMap(
      mapToolbarEnabled: false,
      zoomControlsEnabled: false,
      scrollGesturesEnabled: false,
      initialCameraPosition: const CameraPosition(
        target: LatLng(38.382829, 27.179650),
        zoom: 15,
      ),
      markers: Set<Marker>.from([
        Marker(
          markerId: const MarkerId('marker_1'),
          position: const LatLng(38.382829, 27.179650),
          infoWindow: InfoWindow(
            title: '${widget.id}',
            snippet: '5 Star Rating',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      ]),
    );
    ;
  }

  ListView listView() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 0),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      shrinkWrap: true,
      itemBuilder: (context, index) => Sensor(context,Icon(Icons.thermostat_outlined),widget.nodes,widget.index),
    );
  }
}

Widget Sensor (BuildContext context,Icon icon,List nodes ,int index, ) {
  return Card(
    child: ListTile(
      leading: CircleAvatar(
        child: icon,
      ),
      title: Text('${nodes[index].id}'),
      subtitle: Text('Humidity:'),

    ),
  );
}