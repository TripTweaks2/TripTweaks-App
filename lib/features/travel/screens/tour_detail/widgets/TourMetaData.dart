import 'package:flutter/cupertino.dart';
import 'package:tesis3/common/widgets/images/CircularImage.dart';
import 'package:tesis3/common/widgets/texts/BrandTitleWithVerifiedIcon.dart';
import 'package:tesis3/features/travel/controllers/tour/TourController.dart';
import 'package:tesis3/features/travel/models/tour_model.dart';
import 'package:tesis3/utils/constants/colors.dart';
import 'package:tesis3/utils/constants/enums.dart';
import 'package:tesis3/utils/helpers/helper_function.dart';

import '../../../../../common/widgets/image_text_widget/TourImageText.dart';
import '../../../../../utils/constants/sizes.dart';

class TouMetaData extends StatelessWidget {
  const TouMetaData({super.key, required this.tourModel,});

  final TourModel tourModel;

  @override
  Widget build(BuildContext context) {
    final controller=TourController.instance;
    final dark=HelperFunctions.isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: Sizes.spaceBtwItems/1.5),
        TourTitleText(title: tourModel.title),
        const SizedBox(height: Sizes.spaceBtwItems/1.5),
        Row(
          children: [
            BrandTitleWithVerifiedIcon(title: tourModel.typeModel != null ? tourModel.typeModel!.name : '',textSizes: TextSizes.medium)
          ],
        ),
        const SizedBox(height: Sizes.spaceBtwItems/1.5),
        Text('Tipo de Ingreso: ${tourModel.tipoIngreso}')
      ],
    );
  }
}
