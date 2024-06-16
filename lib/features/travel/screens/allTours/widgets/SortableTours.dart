import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tesis3/common/widgets/layout/grid_layout.dart';
import 'package:tesis3/common/widgets/touristPlace/Card/PlaceTouristCardVertical.dart';
import 'package:tesis3/features/travel/controllers/tour/AllToursController.dart';
import 'package:tesis3/features/travel/models/tour_model.dart';
import 'package:tesis3/utils/constants/sizes.dart';

class SortableTours extends StatelessWidget {
  const SortableTours({super.key, required this.tours});

  final List<TourModel> tours;

  @override
  Widget build(BuildContext context) {
    final controller=Get.put(AllToursController());
    controller.assignTour(tours);
    return Column(
      children: [
        DropdownButtonFormField(
          decoration: const InputDecoration(prefixIcon: Icon(Iconsax.sort)),
          value: controller.selectedSortOption.value,
          onChanged: (value) {
            controller.sortTours(value!);
          },
          items: ['Nombre']
              .map((option) => DropdownMenuItem(value: option,child: Text(option)))
              .toList(),
        ),
        const SizedBox(height: Sizes.spaceBtwSection),
        Obx(() => GridLayout(itemCount: controller.tours.length, itemBuilder: (_,index) =>PlaceTouristCardVertical(tour: controller.tours[index])))
      ],
    );
  }
}
