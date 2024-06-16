import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WeatherCard extends StatelessWidget {
  final Map<String, dynamic> weatherData;

  WeatherCard({required this.weatherData});

  @override
  Widget build(BuildContext context) {
    final temp = weatherData['main']['temp'];
    final description = weatherData['weather'][0]['description'];
    final iconCode = weatherData['weather'][0]['icon'];

    return Card(
      child: Column(
        children: [
          Image.network('https://openweathermap.org/img/w/$iconCode.png'),
          Text('$temp°C', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(description, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}



class WeatherCard2 extends StatelessWidget {
  final List<Map<String, dynamic>> weatherData2;

  WeatherCard2({required this.weatherData2});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: weatherData2.length,
      itemBuilder: (context, index) {
        final temp = weatherData2[index]['temp']['day'];
        final description = weatherData2[index]['weather'][0]['description'];
        final iconCode = weatherData2[index]['weather'][0]['icon'];

        return Card(
          child: Column(
            children: [
              Image.network('https://openweathermap.org/img/w/$iconCode.png'),
              Text('$temp°C', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(description, style: TextStyle(fontSize: 12)),
            ],
          ),
        );
      },
    );
  }
}