import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tesis3/common/widgets/chips/OptionChoiceChip.dart';
import 'package:tesis3/common/widgets/texts/SectionHeadings.dart';
import 'package:tesis3/utils/constants/sizes.dart';
import 'package:tesis3/utils/helpers/helper_function.dart';

import '../../../../../common/widgets/texts/forms/RoundedText.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../controllers/tour/TourController.dart';
import '../../../models/tour_model.dart';

class TourAttribute extends StatelessWidget {
  const TourAttribute({Key? key, required this.tourModel}) : super(key: key);

  final TourModel tourModel;

  @override
  Widget build(BuildContext context) {
    final controller = TourController.instance;

    return Column(
      children: tourModel.tourAttributes != null
          ? tourModel.tourAttributes!.map((attribute) {
        final options = attribute.values ?? []; // Obtener las opciones del atributo
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SectionHeading(title: attribute.name ?? '', showActionButton: false),
            const SizedBox(height: Sizes.spaceBtwItems / 2),
            SizedBox(
              height: 52, // Altura fija para el ListView horizontal
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: options.length,
                separatorBuilder: (_, __) => SizedBox(width: Sizes.spaceBtwItems),
                itemBuilder: (_, index) {
                  final option = options[index]; // Obtiene la opción actual
                  return GestureDetector(
                    child: RoundedText(
                      width: 150,
                      text: option,
                      backgroundColor: AppColors.secondaryElement,
                      borderRadius: Sizes.md,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }).toList()
          : [], // Si tourModel.tourAttributes es null, devolver una lista vacía
    );
  }
}