import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tesis3/utils/constants/colors.dart';

import '../../../../../common/widgets/app_bar/appBar.dart';

class FAQScreen extends StatelessWidget {
  final List<Map<String, String>> faqs = [
    {
      'question': '¿Cómo puedo crear un nuevo itinerario?',
      'answer':
      'Para crear un nuevo itinerario, simplemente navega a la pantalla Itinerarios y haz clic en el botón "+". Luego, sigue las instrucciones para agregar un nuevo itinerario'
    },
    {
      'question': '¿Cómo puedo editar el nombre de un itinerario existente?',
      'answer':
      'Para editar un itinerario existente, ve a la pantalla Itinerario y haz click en el botón de un lápiz. Luego, podrás modificar el nombre del Itinerario'
    },
    {
      'question': '¿Cómo puedo eliminar un lugar de un itinerario existente?',
      'answer':
      'Para editar un itinerario existente, ve a la pantalla Itinerario y selecciona el itinerario el cual desea modificar. Luego, haciendo click en el botón de un tacho podrás eliminar el lugar del Itinerario'
    },
    {
      'question': '¿Cómo puedo activar las notificaciones?',
      'answer':
      'Para activar las notificaciones, ve a la configuración de la aplicación y habilita la opción de notificaciones. Una vez activadas, recibirás alertas sobre actualizaciones importantes en tus itinerarios y condiciones meteorológicas.'
    },
    {
      'question': '¿Cómo puedo habilitar la geolocalización?',
      'answer':
      'Para habilitar la geolocalización, ve a la configuración de la aplicación y activa la opción de geolocalización. Esto permitirá que la aplicación acceda a tu ubicación actual y te proporcione recomendaciones basadas en ella.'
    },
    {
      'question': '¿Puedo descargar mi itinerario en formato PDF?',
      'answer':
      'Sí, en TripTweaks tienes la opción de descargar tu itinerario en formato PDF. Una vez que hayas finalizado la creación o edición de tu itinerario, simplemente haz clic en ella y haz click en el botón de ícono de descarga y se estará almacenando en tus Archivos.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Preguntas Frecuentes',style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: faqs.length,
          itemBuilder: (context, index) {
            return ExpansionTile(
              title: Text(
                faqs[index]['question']!,
                style: Theme.of(context).textTheme.titleLarge!.apply(color: AppColors.primaryElement),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    faqs[index]['answer']!,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
