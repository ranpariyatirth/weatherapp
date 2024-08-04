import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: WeatherPage(),
    );
  }
}

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final apiKey = '158967843a4e4cf212969a5b6480d58c';//key
  String city = '';
  String temperature = '';
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = position;
    });
    _getAddressFromLatLng();
  }

  _getAddressFromLatLng() async {
    List<Placemark> placemarks = await placemarkFromCoordinates(_currentPosition!.latitude, _currentPosition!.longitude);//takingvaluesny permisen
    Placemark place = placemarks[0];
    setState(() {
      city = '${place.locality}';
    });
    _fetchWeatherData(city);
  }

  Future<void> _fetchWeatherData(String city) async {
    final url = Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric');

    final response = await http.get(url);
    print(response.toString());

    if (response.statusCode == 200) {
      final weatherData = json.decode(response.body);
      final mainData = weatherData['main'];
      setState(() {
        temperature = '${mainData['temp']}°C';
      });
    } else {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Colors.black12,
      appBar: AppBar(

        centerTitle: mounted,
        title: const Text('Weather App',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.lightBlue),),
      ),
      body: Container(

        child: Center(
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Text(
                _currentPosition != null
                    ? 'City: $city'
                    : 'Loading...',
                style: TextStyle(fontSize: 20,color: Colors.cyan),
              ),
              SizedBox(height: 16),
              Icon(Icons.wb_sunny_sharp,size: 40,color:Colors.yellow ),
              ElevatedButton(
                onPressed: () {
                  _getCurrentLocation();
                },

                child: Text('Get Current Location',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
              ),
              SizedBox(height: 16),
              const Text(
                'Temperature:',
                style: TextStyle(fontSize: 20,color: Colors.cyan),
              ),
              
              SizedBox(height: 16),
              Text(
                temperature,
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold,color: Colors.yellow),
              ),
            ],
          ),
        ),
      ),
    );
  }
}