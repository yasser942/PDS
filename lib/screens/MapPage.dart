import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  final LatLng _initialLocation = const LatLng(38.382829, 27.179650); // San Francisco coordinates
  final List<Marker> _markers = []; // List to store markers for places

  // List of places with their coordinates
  final List<Place> _places = [
    Place(name: 'Place 1', latitude: 37.7749, longitude: -122.4194),
    Place(name: 'Place 2', latitude: 37.7858, longitude: -122.4064),
    // Add more places as needed
  ];

  @override
  void initState() {
    super.initState();
    // Add markers for each place
    _places.forEach((place) {
      _markers.add(
        Marker(
          markerId: MarkerId(place.name),
          position: LatLng(place.latitude, place.longitude),
          infoWindow: InfoWindow(title: place.name),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      myLocationEnabled: true,
      initialCameraPosition: CameraPosition(
        target: _initialLocation,
        zoom: 12.0,
      ),
      onMapCreated: (GoogleMapController controller) {
        setState(() {
          mapController = controller;
        });
      },
      markers: Set<Marker>.from(_markers), // Set the markers on the map
    );
  }
}

// Model class for a place
class Place {
  final String name;
  final double latitude;
  final double longitude;

  Place({
    required this.name,
    required this.latitude,
    required this.longitude,
  });
}
