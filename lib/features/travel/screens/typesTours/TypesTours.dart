import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tesis3/common/widgets/app_bar/appBar.dart';
import 'package:tesis3/common/widgets/effects/vertical_tour_shimmer.dart';
import 'package:tesis3/common/widgets/touristPlace/Card/BrandCard.dart';
import 'package:tesis3/features/travel/controllers/type_controller.dart';
import 'package:tesis3/features/travel/screens/allTours/widgets/SortableTours.dart';
import 'package:tesis3/utils/constants/sizes.dart';
import 'package:tesis3/utils/helpers/cloud_helper_function.dart';

import '../../models/type_Model.dart';

class TypesTours extends StatelessWidget {
  const TypesTours({super.key, required this.typeModel});

  final TypeModel typeModel;

  @override
  Widget build(BuildContext context) {
    final controller=TypeController.instance;
    return Scaffold(
      appBar: TAppBar(title: Text(typeModel.name),showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(padding: const EdgeInsets.all(Sizes.defaultSpace),
        child: Column(
          children: [
            BrandCard(showBorder: true, type: typeModel),
            const SizedBox(height: Sizes.spaceBtwSection),
            FutureBuilder(
              future: controller.getTypeProducts(typeId: typeModel.id),
              builder: (context, snapshot) {
                const loader=VerticalTourShimmer();
                final widget=CloudHelperFunction.checkMultiRecordState(snapshot: snapshot,loader: loader);
                if(widget != null) return widget;
                final typeProducts=snapshot.data!;
                return SortableTours(tours: typeProducts);
              }
            )
          ],
        ),),
      ),
    );
  }
}
