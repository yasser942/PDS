import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
   Map<String, dynamic>? _weatherData;

  Future<Position> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }


  Future<Map<String, dynamic>> _fetchWeatherData(Position position) async {
    final response = await http.get(
      Uri.parse(
        'http://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=bebf311168a3d7cf781942f2cae082ee',
      ),
    );

    if (response.statusCode == 200) {
      print(response.body);
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadWeatherData();
  }

  Future<void> _loadWeatherData() async {
    final position = await _getCurrentLocation();
    final weatherData = await _fetchWeatherData(position);

    setState(() {
      _weatherData = weatherData;
    });
  }

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       body: _weatherData == null
           ? const Center(child: CircularProgressIndicator())
           : SingleChildScrollView(
         child: Padding(
           padding: const EdgeInsets.all(0.0),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: <Widget>[
               // Location Card
               Card(
                 shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(15.0),
                 ),
                 elevation: 5.0,
                 child: Padding(
                   padding: const EdgeInsets.all(16.0),
                   child: Column(
                     children: <Widget>[
                       const Text(
                         'Location:',
                         style: TextStyle(
                           fontSize: 18,
                           fontWeight: FontWeight.bold,
                         ),
                       ),
                       const SizedBox(height: 5.0),
                       Text(
                         '${_weatherData!['name']}, ${_weatherData!['sys']['country']}',
                         style: const TextStyle(
                           fontSize: 16,
                         ),
                       ),
                     ],
                   ),
                 ),
               ),

               // Weather Card
               Card(
                 shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(15.0),
                 ),
                 elevation: 5.0,
                 child: Padding(

                   padding: const EdgeInsets.all(16.0),
                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: <Widget>[
                       // Temperature
                       Column(
                         children: <Widget>[
                           const Text(
                             'Temperature:',
                             style: TextStyle(
                               fontSize: 18,
                               fontWeight: FontWeight.bold,
                             ),
                           ),
                           const SizedBox(height: 5.0),
                           Text(
                             '${(_weatherData!['main']['temp'] - 273.15).toStringAsFixed(2)}°C',
                             style: const TextStyle(
                               fontSize: 16,
                             ),
                           ),
                           Text(
                              'Min: ${(_weatherData!['main']['temp_min'] - 273.15).toStringAsFixed(2)}°C',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              'Max: ${(_weatherData!['main']['temp_max'] - 273.15).toStringAsFixed(2)}°C',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                           Text(
                              'Feels Like: ${(_weatherData!['main']['feels_like'] - 273.15).toStringAsFixed(2)}°C',
                              style: const TextStyle(
                                fontSize: 16,
                              ),

                           ),
                           Text(
                              'Pressure: ${(_weatherData!['main']['pressure'])} hPa',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                           ),
                           Text(
                              'Visibility: ${(_weatherData!['visibility'])} m',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                           ),

                           Text(
                              'Description: ${_weatherData!['weather'][0]['description']}',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                           ),
                           Text(
                             'Description: ${_weatherData!['weather'][0]['main']}',
                             style: const TextStyle(
                               fontSize: 16,
                             ),
                           ),



                         ],
                       ),
                       // Weather Icon
                       CachedNetworkImage(
                         imageUrl: 'http://openweathermap.org/img/wn/${_weatherData!['weather'][0]['icon']}@2x.png',
                         placeholder: (context, url) => const CircularProgressIndicator(),
                         errorWidget: (context, url, error) => const Icon(Icons.error),
                         width: 80.0,
                         height: 80.0,
                                     ),
                     ],
                   ),
                 ),
               ),

               // Additional Details Card
               Card(
                 shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(15.0),
                 ),
                 elevation: 5.0,
                 child: Padding(
                   padding: const EdgeInsets.all(16.0),
                   child: Column(
                     children: <Widget>[
                       const Text(
                         'Additional Details:',
                         style: TextStyle(
                           fontSize: 18,
                           fontWeight: FontWeight.bold,
                         ),
                       ),
                       const SizedBox(height: 5.0),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: <Widget>[
                           // Wind Speed
                           const Text(
                             'Wind Speed:',
                             style: TextStyle(
                               fontSize: 16,
                             ),
                           ),
                           Text(
                             '${_weatherData!['wind']['speed']} m/s',
                             style: const TextStyle(
                               fontSize: 16,
                             ),
                           ),
                         ],
                       ),
                       const SizedBox(height: 5.0),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: <Widget>[
                           // Humidity
                           const Text(
                             'Humidity:',
                             style: TextStyle(
                               fontSize: 16,
                             ),
                           ),
                           Text(
                             '${_weatherData!['main']['humidity']}%',
                             style: const TextStyle(
                               fontSize: 16,
                             ),
                           ),
                         ],
                       ),
                     ],
                   ),
                 ),
               ),
             ],
           ),
         ),
       ),
     );
   }

}
