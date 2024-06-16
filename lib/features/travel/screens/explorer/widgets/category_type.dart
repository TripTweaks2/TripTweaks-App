import 'package:flutter/cupertino.dart';
import 'package:tesis3/features/travel/controllers/type_controller.dart';
import 'package:tesis3/features/travel/models/category_model.dart';
import 'package:tesis3/utils/constants/sizes.dart';
import 'package:tesis3/utils/helpers/cloud_helper_function.dart';

import '../../../../../common/widgets/brands/brand_show_case.dart';
import '../../../../../common/widgets/effects/BoxesShimmer.dart';
import '../../../../../common/widgets/effects/ListTileShimmer.dart';
import '../../../../../utils/constants/images_string.dart';

class CategoryType extends StatelessWidget {
  const CategoryType({super.key, required this.categoryModel});

  final CategoryModel categoryModel;

  @override
  Widget build(BuildContext context) {
    final controller=TypeController.instance;
    return FutureBuilder(
      future: controller.getTypeForCategory(categoryModel.id),
      builder: (context, snapshot) {
        const loader = Column(
          children: [
            ListTileShimmer(),
            SizedBox(height: Sizes.spaceBtwItems),
            BoxesShimmer(),
            SizedBox(height: Sizes.spaceBtwItems),
          ],
        );
        final widget = CloudHelperFunction.checkMultiRecordState(snapshot: snapshot,loader: loader);
        if(widget !=null) return widget;

        final types = snapshot.data!;

        return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: types.length,
            itemBuilder: (_,index) {
              final type=types[index];
              return FutureBuilder(
                future: controller.getTypeProducts(typeId: type.id,limit: 3),
                builder: (context, snapshot) {
                  final widget = CloudHelperFunction.checkMultiRecordState(snapshot: snapshot,loader: loader);
                  if(widget!=null) return widget;

                  final tours = snapshot.data!;
                  return BrandShowcase(images: tours.map((e) => e.thumbnail).toList(), typeModel: type,);
                }
              );
            },
        );
      }
    );
  }
}
