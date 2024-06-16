import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tesis3/common/widgets/app_bar/appBar.dart';
import 'package:tesis3/common/widgets/layout/grid_layout.dart';
import 'package:tesis3/common/widgets/texts/SectionHeadings.dart';
import 'package:tesis3/common/widgets/touristPlace/Card/BrandCard.dart';
import 'package:tesis3/features/travel/controllers/type_controller.dart';
import 'package:tesis3/features/travel/models/type_Model.dart';
import 'package:tesis3/features/travel/screens/typesTours/TypesTours.dart';
import 'package:tesis3/utils/constants/sizes.dart';

import '../../../../common/widgets/effects/TypeShimmer.dart';

class AllTypesScreen extends StatelessWidget {
  const AllTypesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final typeController=TypeController.instance;
    return Scaffold(
      appBar: const TAppBar(title: Text('Tipos de Sitios Turísticos'),showBackArrow: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Sizes.defaultSpace),
          child: Column(
            children: [
              const SectionHeading(title: 'Tipos de Sitios Turísticos',showActionButton: false),
              const SizedBox(height: Sizes.spaceBtwItems),
              Obx((){
                    if(typeController.isLoading.value) return const TypeShimmer();
                    if(typeController.featuredTypes.isEmpty) return Center(child:Text('No hay información!',style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.white)));

                    return GridLayout(itemCount: typeController.allTypes.length,mainAxisExtent: 80, itemBuilder: (_,index){
                      final type=typeController.allTypes[index];
                      return BrandCard(showBorder:true, type: type,onTap: () => Get.to(() => TypesTours(typeModel: type,)),);
                    });
                  }
              )
            ],
          ),
        ),
      ),
    );
  }
}
