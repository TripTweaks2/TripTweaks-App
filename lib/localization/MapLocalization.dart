import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../common/widgets/app_bar/appBar.dart';
import '../features/Questionv2/ItinerarioPlaceV2Model.dart';
import '../navigation_menu.dart';
import '../utils/constants/sizes.dart';
import 'GeolocationController.dart';

class MapLocalization extends StatefulWidget {
  final List<PlaceItinerary> places;

  MapLocalization({required this.places});

  @override
  _MapLocalizationState createState() => _MapLocalizationState();
}

class _MapLocalizationState extends State<MapLocalization> {
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};
  LatLng? _currentPosition;
  final GeolocationController geolocationController = Get.find();


  @override
  void initState() {
    super.initState();
    _setMarkers();
    _getCurrentLocation();
  }

  void _setMarkers() {
    setState(() {
      _markers = widget.places.map((place) {
        return Marker(
          markerId: MarkerId(place.name),
          position: LatLng(place.latitude, place.longitude),
          infoWindow: InfoWindow(
            title: place.name,
            snippet: 'Ranking: ${place.rating}',
          ),
        );
      }).toSet();
    });
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Los servicios de ubicación están deshabilitados.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Se deniegan los permisos de ubicación');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Los permisos de ubicación están permanentemente denegados, no podemos solicitar permisos.');
    }

    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _markers.add(
        Marker(
          markerId: MarkerId('currentLocation'),
          position: _currentPosition!,
          infoWindow: const InfoWindow(
            title: 'Mi Ubicación Actual',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    });

    _mapController.animateCamera(
      CameraUpdate.newLatLngZoom(_currentPosition!, 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!geolocationController.isGeolocationEnabled.value) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Mapa de Localización'),
          ),
          body: AlertDialog(
            title: Text('Geolocalización desactivada'),
            content: Text('Para usar esta función, debes activar la geolocalización.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cierra la alerta
                  // Redirige al NavigationMenu después de cerrar la alerta
                  Get.offAll(() => NavigationMenu());
// Establece el índice del menú en 3 (índice de SettingClass) después de un pequeño retraso
                  Future.delayed(Duration(milliseconds: 100), () {
                    Get.find<NavigationController>().selectedIndex.value = 3;
                  });
                },
                child: Text('Aceptar'),
              ),
            ],
          ),
        );
      }
      else {
        return Scaffold(
          appBar: AppBar(
            title: Text('Mapa de Localización'),
          ),
          body: _currentPosition == null
              ? Center(child: CircularProgressIndicator())
              : GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentPosition!,
              zoom: 12,
            ),
            markers: _markers,
            onMapCreated: (controller) {
              _mapController = controller;
            },
          ),
        );
      }
    });
  }
}