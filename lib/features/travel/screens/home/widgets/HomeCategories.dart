import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tesis3/common/widgets/effects/Category_Shimmer.dart';
import 'package:tesis3/features/travel/controllers/category_controller.dart';

import '../../../../../common/widgets/image_text_widget/VerticalImageText.dart';
import '../../../../../utils/constants/images_string.dart';
import 'SubCategoryScreen.dart';

class HomeCategories extends StatelessWidget {
  const HomeCategories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final categoryController=Get.put(CategoryController());
    return Obx((){
          if(categoryController.isLoading.value) return const CategoryShimmer();
          if(categoryController.featuredCategories.isEmpty){
            return Center(child: Text('Información no encontrada',style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.white)));
          }
          return SizedBox(
            height: 80,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: categoryController.featuredCategories.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_,index){
                final category=categoryController.featuredCategories[index];
                return VerticalImageText(image: category.image, title: category.name, onTap: () => Get.to(() => SubCategoryScreen(categoryModel: category)));
              },
            ),
          );
        }
    );
  }
}
