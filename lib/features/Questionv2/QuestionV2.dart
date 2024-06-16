import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../common/styles/SpacingStyle.dart';
import '../../common/widgets/app_bar/appBar.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/constants/text_string.dart';
import 'QuestionV2Controller.dart';

class QuestionVersion2 extends StatelessWidget {
  final Function(Location) onLocationSelected;

  QuestionVersion2({required this.onLocationSelected});

  @override
  Widget build(BuildContext context) {
    final QuestionV2Controller controller =Get.put(QuestionV2Controller());

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: controller.searchPlaceController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  labelText: '¿A dónde deseas viajar?',
                ),
                onChanged: (query) {
                  controller.getSuggestions(query);
                },
              ),
            ),
            Obx(() {
              return ListView.builder(
                shrinkWrap: true,
                itemCount: controller.suggestions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(controller.suggestions[index]),
                    onTap: () async {
                      final selectedAddress = controller.suggestions[index];
                      controller.searchPlaceController.text = selectedAddress;
                      controller.suggestions.clear();
                      await controller.getCoordinates(selectedAddress);
                      final location = controller.selectedLocation.value;
                      if (location != null) {
                        onLocationSelected(location);
                      }
                    },
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}