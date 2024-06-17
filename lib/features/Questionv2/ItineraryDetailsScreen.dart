import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tesis3/utils/constants/colors.dart';
import 'package:http/http.dart' as http;
import 'package:tesis3/utils/constants/sizes.dart';

import '../../common/widgets/Icons/CircularIcon.dart';
import '../../common/widgets/app_bar/appBar.dart';
import '../../localization/MapLocalization.dart';
import '../../utils/constants/api_constants.dart';
import '../../utils/constants/images_string.dart';
import '../../utils/popups/fullScreenLoader.dart';
import '../ItineraryScreen/ItinerarioController/ItinerarioController.dart';
import '../personalization/controllers/user_controller.dart';
import 'ItinerarioPlaceV2Model.dart';
import 'package:pdf/widgets.dart' as pw;


class ItineraryDetailsScreen extends StatefulWidget {
  final ItinerarioV2 itinerario;

  ItineraryDetailsScreen({required this.itinerario});

  @override
  _ItineraryDetailsScreenState createState() => _ItineraryDetailsScreenState();
}

class _ItineraryDetailsScreenState extends State<ItineraryDetailsScreen> {
  late ItinerarioV2 itinerario; // Declare itinerario como una variable mutable
  bool itinerarioEliminado = false;

  @override
  void initState() {
    super.initState();
    itinerario = widget.itinerario; // Inicializa itinerario en el initState
  }

  String _buildPhotoUrl(String photoReference) {
    // Construir la URL según la referencia de la foto
    return 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=300&photoreference=$photoReference&key='+ApiConstants.secretApiKeyGoogleMaps;
  }

  Future<void> eliminarLugarDeItinerario(String lugarId) async {
    try {
      // Filtrar los lugares del itinerario para eliminar el lugar específico
      final nuevosLugares = itinerario.places.where((place) => place.id != lugarId).toList();

      print(nuevosLugares.toList());

      if (nuevosLugares.isEmpty) {
        // Si no quedan lugares en el itinerario, mostrar un diálogo de confirmación
        final confirmacion = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Eliminar itinerario'),
            content: Text('¿Estás seguro de que deseas eliminar este itinerario?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false), // No eliminar el itinerario
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true), // Confirmar eliminación del itinerario
                child: Text('Eliminar'),
              ),
            ],
          ),
        );

        // Si el usuario confirma la eliminación del itinerario
        if (confirmacion == true) {
          // Eliminar el documento en Firestore
          await FirebaseFirestore.instance.collection('ItinerarioV2').doc(itinerario.idItinerario).delete();
          Get.find<ItinerarioController>().fetchItinerariosV2(); // Actualizar los datos después de crear el itinerario
          Get.find<ItinerarioController>().notifyItinerariosUpdated(); // Notificar a la pantalla ItinerarioScreen
          Get.back();
          print('Itinerario eliminado debido a la eliminación del último lugar');

          setState(() {
            itinerarioEliminado = true;
          });

          // Resto del código...
          return;
        }
      }

      // Obtener referencia al documento del itinerario
      final itinerarioRef = FirebaseFirestore.instance.collection('ItinerarioV2').doc(itinerario.idItinerario);

      // Actualizar el itinerario en Firestore con los nuevos lugares
      await itinerarioRef.update({'places': nuevosLugares.map((place) => place.toJson()).toList()});

      print('Lugar eliminado del itinerario correctamente');

      final controller = UserController.instance;

      // Crear un nuevo objeto ItinerarioV2 con la lista actualizada de lugares
      final itinerarioActualizado = ItinerarioV2(
        idUser: controller.user.value.id,
        name: itinerario.name,
        places: nuevosLugares,
        hour: itinerario.hour,
        idItinerario: itinerario.idItinerario,
      );

      // Actualizar el estado con el nuevo itinerario
      setState(() {
        itinerario = itinerarioActualizado;
      });
    } catch (e) {
      print('Error al eliminar el lugar del itinerario: $e');
    }
  }

  Future<Uint8List?> _downloadPhoto(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      } else {
        print('Error al descargar la foto: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al descargar la foto: $e');
    }
    return null;
  }

  Map<int, List<PlaceItinerary>> agruparLugaresPorDia(List<PlaceItinerary> lugares) {
    final Map<int, List<PlaceItinerary>> lugaresPorDia = {};
    for (final lugar in lugares) {
      lugaresPorDia.putIfAbsent(lugar.day, () => []).add(lugar);
    }
    return lugaresPorDia;
  }

    Future<void> _generatePdfAndSave(BuildContext context, ItinerarioV2 itinerario) async {

      // Mostrar el loader
      FullScreenLoader.openLoadingDialog('Generando PDF...', Images.loading);


      var status = await Permission.storage.request();

      print(status);
      if (status.isDenied || status.isPermanentlyDenied || status.isRestricted) {
        // Solicitar permisos
        status = await Permission.storage.request();
      }

      if (await Permission.manageExternalStorage.request().isGranted) {
        final pdf = pw.Document();

        final fontData = await rootBundle.load("assets/fonts/Arial.ttf");
        final ttf = pw.Font.ttf(fontData);

        final fontBoldData = await rootBundle.load("assets/fonts/Arial.ttf");
        final ttfBold = pw.Font.ttf(fontBoldData);

        // Obtener el directorio de descargas en el almacenamiento externo
        final directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          await directory.create(recursive: true);
        }

        final lugaresPorDia = agruparLugaresPorDia(itinerario.places);
        final dias = lugaresPorDia.keys.toList()..sort();

        for (final dia in dias) {
          final lugares = lugaresPorDia[dia]!;
          final fotos = await Future.wait(lugares.map((place) => _downloadPhoto(_buildPhotoUrl(place.photo_reference))));

          final page = pw.Page(
            pageFormat: PdfPageFormat.a4.landscape,
            build: (pw.Context context) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Día $dia', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, font: ttfBold)),
                pw.SizedBox(height: 20),
                pw.Table(
                  border: pw.TableBorder.all(),
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.all(4),
                          child: pw.Text('HORA', style: pw.TextStyle(fontWeight: pw.FontWeight.bold,font: ttfBold)),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(4),
                          child: pw.Text('NOMBRE', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: ttfBold)),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(4),
                          child: pw.Text('CLASIFICACIÓN', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: ttfBold)),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(4),
                          child: pw.Text('LATITUD', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: ttfBold)),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(4),
                          child: pw.Text('LONGITUD', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: ttfBold)),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(4),
                          child: pw.Text('FOTO', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, font: ttfBold)),
                        ),
                      ],
                    ),
                    for (var i = 0; i < lugares.length; i++)
                      pw.TableRow(
                        children: [
                          pw.Padding(padding: pw.EdgeInsets.all(4), child: pw.Text(lugares[i].time,style: pw.TextStyle(font: ttf))),
                          pw.Padding(padding: pw.EdgeInsets.all(4), child: pw.Text(lugares[i].name,style: pw.TextStyle(font: ttf))),
                          pw.Padding(padding: pw.EdgeInsets.all(4), child: pw.Text(lugares[i].rating.toString(),style: pw.TextStyle(font: ttf))),
                          pw.Padding(padding: pw.EdgeInsets.all(4), child: pw.Text(lugares[i].latitude.toStringAsFixed(2),style: pw.TextStyle(font: ttf))),
                          pw.Padding(padding: pw.EdgeInsets.all(4), child: pw.Text(lugares[i].longitude.toStringAsFixed(2),style: pw.TextStyle(font: ttf))),
                          pw.Padding(
                            padding: pw.EdgeInsets.all(4),
                            child: fotos[i] != null
                                ? pw.Image(pw.MemoryImage(fotos[i]!), width: 50)
                                : pw.Text('No Imagen', style: pw.TextStyle(font: ttf)),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          );

          pdf.addPage(page);
        }

        final path = '${directory.path}/${itinerario.name}.pdf';
        final file = File(path);
        try {
          await file.writeAsBytes(await pdf.save());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('PDF guardado en $path')),
          );
        } catch (e) {
          // Manejar el error de escritura de archivo
          print('Error al guardar el archivo PDF: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al guardar el archivo PDF')),
          );
        }
        finally {
          // Cerrar el loader después de completar la generación del PDF
          FullScreenLoader.stopLoading();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Permiso denegado')),
        );
        FullScreenLoader.stopLoading();
      }
    }

  String replaceSpecialCharacters(String text) {
    return text.replaceAll(RegExp(r'[^\w\s&]'), '');
  }


  @override
  Widget build(BuildContext context) {
    final lugaresPorDia = agruparLugaresPorDia(itinerario.places);
    final dias = lugaresPorDia.keys.toList()..sort();

    return Scaffold(
      appBar: TAppBar(
        title: Text(
          'Detalles del Itinerario',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        showBackArrow: true,
        actions: [
          CircularIcon(
            icon: Iconsax.map_1,
            onPressed: () => Get.to(() => MapLocalization(places: itinerario.places)),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: dias.length,
        itemBuilder: (context, diaIndex) {
          final dia = dias[diaIndex];
          final lugares = lugaresPorDia[dia]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Sizes.spaceBtwItems),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: Center(
                  child: Text(
                    'Día $dia',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: Sizes.spaceBtwItems),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: lugares.length,
                itemBuilder: (context, index) {
                  final place = lugares[index];
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primaryElement),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListTile(
                      title: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              place.time,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const VerticalDivider(color: AppColors.dark),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  place.name,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('Clasificación: ${place.rating}'),
                                SizedBox(width: 8),
                                Text('Latitud: ${place.latitude.toStringAsFixed(2)}'),
                                SizedBox(width: 8),
                                Text('Longitud: ${place.longitude.toStringAsFixed(2)}')
                              ],
                            ),
                          ),
                          place.photo_reference.isNotEmpty
                              ? Image.network(
                            _buildPhotoUrl(place.photo_reference),
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          )
                              : Image.network(
                            'https://i.ytimg.com/vi/UqsC0C3NJuU/maxresdefault.jpg',
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          IconButton(
                            icon: Icon(Iconsax.trash),
                            onPressed: () {
                              eliminarLugarDeItinerario(place.id);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
      floatingActionButton: Visibility(
        visible: itinerario.places.length >= 1,
        child: FloatingActionButton(
          onPressed: () => _generatePdfAndSave(context, itinerario),
          child: Icon(Icons.download),
        ),
      ),
    );
  }
}