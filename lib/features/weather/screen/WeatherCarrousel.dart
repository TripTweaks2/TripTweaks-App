import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:tesis3/utils/constants/colors.dart';

class WeatherCarousel extends StatelessWidget {
  final List<Map<String, dynamic>> weatherData2;

  WeatherCarousel({required this.weatherData2});

  @override
  Widget build(BuildContext context) {
    Map<DateTime, Map<String, dynamic>> filteredData = {};
    // Obtener la fecha actual
    var now = DateTime.now();
    print(now);


    // Iterar sobre los datos recibidos y filtrar los registros
    for (var dayData in weatherData2) {
      // Obtener la fecha y hora del registro actual
      var dateTime = DateTime.parse(dayData['dt_txt']);

      // Si es el día actual, seleccionar el horario más cercano a las 12:00:00
      if (dateTime.day == now.day) {
        print("entrando acá");
        if (filteredData[now] == null){
        filteredData[now] = dayData;
        }
      }
      // Si es otro día, seleccionar el horario de las 12:00:00
      else {
        var day = DateTime(dateTime.year, dateTime.month, dateTime.day);
        if (filteredData[day] == null) {
          filteredData[day] = dayData;
        }
      }
    }
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filteredData.length, // Utiliza la longitud de filteredData
        itemBuilder: (BuildContext context, int index) {
          var dayData = filteredData.values.toList()[index];
          var date = DateTime.parse(dayData['dt_txt']);
          var temperature = (dayData['main']['temp']).toStringAsFixed(1); // Temperatura en Celsius
          var iconCode = dayData['weather'][0]['icon'];
          var iconUrl = 'https://openweathermap.org/img/wn/$iconCode.png';

          var formattedDate = _formatDate(date);

          // Verificar si es el día actual
          bool isToday = date.day == now.day && date.month == now.month && date.year == now.year;

          return Container(
            width: 100, // Ancho del 80% del ancho de la pantalla
            margin: EdgeInsets.all(5), // Margen para separar los contenedores
            decoration: BoxDecoration(
              // Aplicar estilo especial si es el día actual
              border: isToday ? Border.all(color: AppColors.primaryElement, width: 2) : null,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Card(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      formattedDate,
                      style: TextStyle(fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Image.network(iconUrl, width: 50, height: 50),
                    SizedBox(height: 10),
                    Text(
                      '$temperature °C',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    var dayNames = ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'];
    var monthNames = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];

    var dayOfMonth = '${date.day}';
    var month = monthNames[date.month - 1];

    return '${dayNames[date.weekday - 1]}\n$dayOfMonth - $month';
  }
}