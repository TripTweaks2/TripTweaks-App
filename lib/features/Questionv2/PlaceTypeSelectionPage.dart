import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

import '../../utils/constants/places.dart';

class PlaceTypeSelectionPage extends StatefulWidget {
  final Function(List<String>) onNextPage;
  final Location? selectedLocation;
  final Function(Location?) updateSelectedLocation;
  final List<String> selectedTypes;
  final Function(List<String>) updateSelectedTypes; // Agregar esta línea

  PlaceTypeSelectionPage({
    required this.onNextPage,
    required this.updateSelectedLocation,
    required this.selectedTypes,
    required this.updateSelectedTypes,
    this.selectedLocation,
  });

  @override
  _PlaceTypeSelectionPageState createState() => _PlaceTypeSelectionPageState();
}

class _PlaceTypeSelectionPageState extends State<PlaceTypeSelectionPage> {
  List<String> selectedTypes = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '¿Qué tipo de lugar prefieres visitar?',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16.0),
        Expanded(
          child: ListView.builder(
            itemCount: placeTypeDescriptions.length,
            itemBuilder: (context, index) {
              final placeType = placeTypeDescriptions.keys.toList()[index];
              final placeTypeName = placeTypeDescriptions[placeType];
              final isSelected = selectedTypes.contains(placeType);
              return CheckboxListTile(
                title: Text(placeTypeName ?? placeType),
                value: isSelected,
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      selectedTypes.add(placeType);
                    } else {
                      selectedTypes.remove(placeType);
                    }
                    widget.updateSelectedTypes(selectedTypes); // Actualizar selectedTypes
                    widget.updateSelectedLocation(widget.selectedLocation); // Actualizar selectedLocation
                  });
                },
              );
            },
          ),
        ),
      ],
    );
  }
}