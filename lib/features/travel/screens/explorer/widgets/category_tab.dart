import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tesis3/common/widgets/layout/grid_layout.dart';
import 'package:tesis3/common/widgets/texts/SectionHeadings.dart';
import 'package:tesis3/common/widgets/touristPlace/Card/PlaceTouristCardVertical.dart';
import 'package:tesis3/features/travel/controllers/category_controller.dart';
import 'package:tesis3/features/travel/models/category_model.dart';
import 'package:tesis3/features/travel/screens/allTours/all_tours.dart';
import 'package:tesis3/utils/helpers/cloud_helper_function.dart';

import '../../../../../common/widgets/brands/brand_show_case.dart';
import '../../../../../common/widgets/effects/vertical_tour_shimmer.dart';
import '../../../../../utils/constants/images_string.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/tour/TourController.dart';
import 'category_type.dart';

class CategoryTab extends StatelessWidget {
  const CategoryTab({super.key, required this.category});

  final CategoryModel category;


  @override
  Widget build(BuildContext context) {
    final controller=CategoryController.instance;
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          child: Column(
            children: [
              CategoryType(categoryModel: category),
              const SizedBox(height: Sizes.spaceBtwItems),
              FutureBuilder(
                  future: controller.getCategoryTour(categoryId: category.id),
                  builder: (context,snapshot) {

                    final response= CloudHelperFunction.checkMultiRecordState(snapshot: snapshot,loader: const VerticalTourShimmer());
                    if(response !=null) return response;

                    final tours=snapshot.data!;
                    print(tours.length);

                    return Column(
                      children: [
                        SectionHeading(title: 'Te podría gustar',onPressed: () => Get.to(AllTours(title: category.name, futureMethod: controller.getCategoryTour(categoryId: category.id,limit: -1)))),
                        const SizedBox(height: Sizes.spaceBtwItems),
                        GridLayout(itemCount:tours.length,itemBuilder: (_,index)=>PlaceTouristCardVertical(tour: tours[index]))
                      ],
                    );
                  }
              ),
              const SizedBox(height: Sizes.spaceBtwSection),
            ],
          ),
        ),
      ]
    );
  }
}
