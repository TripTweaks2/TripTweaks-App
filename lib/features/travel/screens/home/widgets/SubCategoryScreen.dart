import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tesis3/common/widgets/app_bar/appBar.dart';
import 'package:tesis3/common/widgets/effects/horizontal_tour_shimmer.dart';
import 'package:tesis3/common/widgets/effects/vertical_tour_shimmer.dart';
import 'package:tesis3/common/widgets/images/RoundedImage.dart';
import 'package:tesis3/common/widgets/texts/SectionHeadings.dart';
import 'package:tesis3/common/widgets/touristPlace/Card/PlaceTouristCardHorizontal.dart';
import 'package:tesis3/common/widgets/touristPlace/Card/PlaceTouristCardVertical.dart';
import 'package:tesis3/features/travel/controllers/category_controller.dart';
import 'package:tesis3/features/travel/models/category_model.dart';
import 'package:tesis3/features/travel/screens/allTours/all_tours.dart';
import 'package:tesis3/utils/constants/sizes.dart';
import 'package:tesis3/utils/helpers/cloud_helper_function.dart';

class SubCategoryScreen extends StatelessWidget {
  const SubCategoryScreen({super.key, required this.categoryModel});

  final CategoryModel categoryModel;

  @override
  Widget build(BuildContext context) {
    final controller= CategoryController.instance;
    return Scaffold(
      appBar: TAppBar(title: Text(categoryModel.name), showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          child: Column(
            children: [
              FutureBuilder(
                future: controller.getSubCategories(categoryModel.id),
                builder: (context, snapshot) {
                  const loader= VerticalTourShimmer();
                  final widget=CloudHelperFunction.checkMultiRecordState(snapshot: snapshot,loader: loader);
                  if(widget!=null) return widget;

                  final subcategories= snapshot.data!;

                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: subcategories.length,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (_,index){
                        final subcategory=subcategories[index];
                        print(subcategory.name);
                        return FutureBuilder(
                          future: controller.getCategoryTour(categoryId: subcategory.id),
                          builder: (context, snapshot) {

                            const loader= HorizontalTourShimmer();
                            final widget=CloudHelperFunction.checkMultiRecordState(snapshot: snapshot,loader: loader);
                            if(widget!=null) return widget;

                            final tours= snapshot.data!;


                            return Column(
                              children: [
                                SectionHeading(title: subcategory.name,onPressed: () => Get.to(
                                    ()=>AllTours(title: subcategory.name, futureMethod: controller.getCategoryTour(categoryId: subcategory.id,limit: -1)),
                                  )
                                ),
                                const SizedBox(height: Sizes.spaceBtwItems/2),
                                SizedBox(
                                  height: 120,
                                  child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context,index) => PlaceTouristCardHorizontal(tour: tours[index]),
                                      separatorBuilder: (context,index) => const SizedBox(width: Sizes.spaceBtwItems),
                                      itemCount: tours.length
                                  ),
                                )
                              ],
                            );
                          }
                        );
                      }
                  );
                }
              )

            ],
          ),
        ),
      ),
    );
  }
}
