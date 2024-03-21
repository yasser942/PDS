import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:location/location.dart';
import 'package:pds/consts.dart';
import 'package:pds/widgets/indicator.dart';

class MapPage extends StatefulWidget {
  const MapPage(
      {super.key,
      required this.latitude,
      required this.longitude,
      required this.address});

  final double latitude;
  final double longitude;
  final String address;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Location _locationController = new Location();
  var travelMode = TravelMode.driving;
  bool trafficEnabled = true;
  MapType _currentMapType = MapType.normal;

  _swithMapType() {
    setState(() {
      _currentMapType =
          _currentMapType == MapType.normal ? MapType.satellite : MapType.normal;
    });
  }
  _switchMapMode() async {
    setState(() {
      travelMode = (travelMode == TravelMode.walking) ? TravelMode.driving : TravelMode.walking;
      trafficEnabled = !trafficEnabled;
    });
  }

  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  static const LatLng _pGooglePlex =
      LatLng(38.43994359656545, 27.14144055881877);
  static LatLng _pApplePark = const LatLng(38.370573, 27.20091);
  LatLng? _currentP = null;

  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    _pApplePark = LatLng(widget.latitude, widget.longitude);
    getLocationUpdates().then(
      (_) => {
        getPolylinePoints().then((coordinates) => {
              generatePolyLineFromPoints(coordinates),
            }),
      },
    );
    /*
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(45, 45)),
        'assets/dust.png'
    ).then((value) => locationIcon = value);

     */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _currentP == null
            ?  Center(
                child: indicator(context),
              )
            : GoogleMap(
                zoomControlsEnabled: false,
                trafficEnabled: trafficEnabled,
                mapToolbarEnabled: false,
                mapType: _currentMapType,
                onMapCreated: ((GoogleMapController controller) =>
                    _mapController.complete(controller)),
                initialCameraPosition: const CameraPosition(
                  target: _pGooglePlex,
                  zoom: 5,
                ),
                markers: {
                  Marker(
                    markerId: const MarkerId("_currentLocation"),
                    icon: BitmapDescriptor.defaultMarkerWithHue(120.0),
                    position: _currentP!,
                    infoWindow: const InfoWindow(
                      title: "My Location",
                    ),
                  ),
                  Marker(
                      markerId: const MarkerId("_destionationLocation"),
                      icon: BitmapDescriptor.defaultMarker,
                      position: _pApplePark,
                      infoWindow: InfoWindow(
                        title: widget.address,
                      )),
                },
                polylines: Set<Polyline>.of(polylines.values),
              ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(left: 28.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FloatingActionButton(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                onPressed: () {
                  setState(() {
                    _switchMapMode();

                    getPolylinePoints().then((coordinates) => {
                          generatePolyLineFromPoints(coordinates),
                        });
                  });
                },
                child: travelMode == TravelMode.driving
                    ? const Icon(Icons.directions_car, color: Colors.white)
                    : const Icon(Icons.directions_walk, color: Colors.white),
              ),


              const SizedBox(
                width: 10,
              ),
              FloatingActionButton(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                onPressed: () {
                  setState(() {
                    _swithMapType();
                  });
                },
                child: _currentMapType == MapType.normal
                    ? const Icon(Icons.satellite, color: Colors.white)
                    : const Icon(Icons.map, color: Colors.white),
              ),
            ],
          ),
        ));
  }

  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(
      target: pos,
      zoom: 12,
    );
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(_newCameraPosition),
    );
  }

  Future<void> getLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await _locationController.serviceEnabled();
    if (_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          _currentP =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          _cameraToPosition(_currentP!);
          getPolylinePoints().then((coordinates) => {
                generatePolyLineFromPoints(coordinates),
              });
        });
      }
    });
  }

  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      GOOGLE_MAPS_API_KEY,
      PointLatLng(_currentP!.latitude, _currentP!.longitude),
      PointLatLng(_pApplePark.latitude, _pApplePark.longitude),
      travelMode: travelMode,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    return polylineCoordinates;
  }

  void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) async {
    PolylineId id = const PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.blueAccent,
        points: polylineCoordinates,
        width: 4);
    setState(() {
      polylines[id] = polyline;
    });
  }
}
