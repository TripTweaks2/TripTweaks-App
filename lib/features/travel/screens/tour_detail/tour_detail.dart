import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:iconsax/iconsax.dart';
import 'package:readmore/readmore.dart';
import 'package:tesis3/common/widgets/Icons/CircularIcon.dart';
import 'package:tesis3/common/widgets/app_bar/appBar.dart';
import 'package:tesis3/common/widgets/custom_shapes/curved_edges/CurvedEdgeWidget.dart';
import 'package:tesis3/common/widgets/image_text_widget/TourImageText.dart';
import 'package:tesis3/common/widgets/images/RoundedImage.dart';
import 'package:tesis3/common/widgets/texts/SectionHeadings.dart';
import 'package:tesis3/features/travel/models/tour_model.dart';
import 'package:tesis3/features/travel/screens/tour_detail/widgets/TourAttributes.dart';
import 'package:tesis3/features/travel/screens/tour_detail/widgets/TourMetaData.dart';
import 'package:tesis3/features/travel/screens/tour_detail/widgets/tour_detail_slide_image.dart';
import 'package:tesis3/utils/constants/colors.dart';
import 'package:tesis3/utils/constants/images_string.dart';
import 'package:tesis3/utils/constants/sizes.dart';
import 'package:tesis3/utils/helpers/helper_function.dart';

class TourDetail extends StatelessWidget {
  const TourDetail({super.key, required this.tour});

  final TourModel tour;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ImageSlider(tour: tour),
            Padding(
                padding: EdgeInsets.only(right:Sizes.defaultSpace,left: Sizes.defaultSpace,bottom: Sizes.defaultSpace),
                child: Column(
                  children: [
                    TouMetaData(tourModel: tour),
                    const SizedBox(height: Sizes.spaceBtwItems/1.5),
                    const Divider(),
                    const SizedBox(height: Sizes.spaceBtwItems/1.5),
                    TourAttribute(tourModel: tour),
                    const SizedBox(height: Sizes.spaceBtwItems/1.5),
                    const Divider(),
                    const SectionHeading(title: 'Descripción', showActionButton: false),
                    const SizedBox(height: Sizes.spaceBtwItems),
                    ReadMoreText(
                      tour.description ?? '',
                      trimLines: 7,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: ' Más',
                      trimExpandedText: ' Menos',
                      moreStyle: const TextStyle(fontSize: 14,fontWeight: FontWeight.w800),
                      lessStyle: const TextStyle(fontSize: 14,fontWeight: FontWeight.w800),
                    ),

                  ],
                )
            )
          ],
        ),
      ),
    );
  }
}

