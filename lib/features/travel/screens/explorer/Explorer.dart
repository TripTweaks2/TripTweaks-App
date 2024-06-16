import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tesis3/common/widgets/custom_shapes/containers/RoundedContainer.dart';
import 'package:tesis3/common/widgets/images/CircularImage.dart';
import 'package:tesis3/common/widgets/layout/grid_layout.dart';
import 'package:tesis3/common/widgets/texts/SectionHeadings.dart';
import 'package:tesis3/features/travel/controllers/category_controller.dart';
import 'package:tesis3/features/travel/controllers/type_controller.dart';
import 'package:tesis3/features/travel/screens/explorer/widgets/SearchScreen.dart';
import 'package:tesis3/features/travel/screens/explorer/widgets/category_tab.dart';
import 'package:tesis3/features/travel/screens/typesTours/all_types.dart';
import 'package:tesis3/utils/constants/colors.dart';
import 'package:tesis3/utils/constants/enums.dart';
import 'package:tesis3/utils/constants/images_string.dart';
import 'package:tesis3/utils/constants/sizes.dart';
import 'package:tesis3/utils/helpers/helper_function.dart';

import '../../../../common/widgets/app_bar/appBar.dart';
import '../../../../common/widgets/app_bar/tabBar.dart';
import '../../../../common/widgets/brands/brand_show_case.dart';
import '../../../../common/widgets/custom_shapes/containers/SearchContainer.dart';
import '../../../../common/widgets/effects/TypeShimmer.dart';
import '../../../../common/widgets/texts/BrandTitleWithVerifiedIcon.dart';
import '../../../../common/widgets/touristPlace/Card/BrandCard.dart';

class Explorer extends StatelessWidget {
  const Explorer({super.key});

  @override
  Widget build(BuildContext context) {
    final typeController=Get.put(TypeController());
    final categories=CategoryController.instance.featuredCategories;
    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: TAppBar(
          title: Text('Navegar',style: Theme.of(context).textTheme.headlineMedium),
          showBackArrow: true,
        ),
        body: NestedScrollView(headerSliverBuilder: (_,innerBoxIsScrolled){
          return[
            SliverAppBar(
              automaticallyImplyLeading: false,
              pinned: true,
              floating: true,
              backgroundColor: HelperFunctions.isDarkMode(context) ? AppColors.black:AppColors.white,
              expandedHeight: 440,
              flexibleSpace: Padding(
                padding: const EdgeInsets.all(Sizes.defaultSpace),
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children:  [
                    ///SearchBar
                    SearchContainer(text: 'Explorando',showBorder: true,showBackground: false,padding: EdgeInsets.zero,onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SearchScreen()),
                      );
                    }),
                    const SizedBox(height: Sizes.spaceBtwSection2),
                    ///Featured General Category
                    SectionHeading(title: 'Tipo de Sitios Turísticos',onPressed: () => Get.to(() => const AllTypesScreen())),
                    const SizedBox(height: Sizes.spaceBtwItems/1.5),
                    Obx(
                      (){
                        if(typeController.isLoading.value) return const TypeShimmer();
                        if(typeController.featuredTypes.isEmpty) return Center(child:Text('No hay información!',style: Theme.of(context).textTheme.bodyMedium!.apply(color: Colors.white)));

                        return GridLayout(itemCount: typeController.featuredTypes.length,mainAxisExtent: 80, itemBuilder: (_,index){
                          final type=typeController.featuredTypes[index];
                          return BrandCard(showBorder:true, type: type);
                        });
                      }
                    )
                  ],
                ),
              ),
              bottom: tabBar(tabs: categories.map((category) => Tab(child: Text(category.name))).toList()),
            ),
          ];},
          body: TabBarView(children:  categories.map((category) => CategoryTab(category: category)).toList()),
        ),

      ),
    );
  }
}







