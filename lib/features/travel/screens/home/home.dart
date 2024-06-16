import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tesis3/common/widgets/app_bar/appBar.dart';
import 'package:tesis3/features/travel/screens/allTours/all_tours.dart';
import 'package:tesis3/features/travel/screens/explorer/Explorer.dart';
import 'package:tesis3/features/travel/screens/home/widgets/HomeAppBar.dart';
import 'package:tesis3/features/travel/screens/home/widgets/HomeCategories.dart';
import 'package:tesis3/utils/constants/colors.dart';
import 'package:tesis3/utils/constants/sizes.dart';
import 'package:tesis3/utils/constants/text_string.dart';
import 'package:tesis3/utils/device/device_utility.dart';
import 'package:tesis3/utils/helpers/helper_function.dart';
import '../../../../common/widgets/custom_shapes/containers/PrimaryHeaderContainer.dart';
import '../../../../common/widgets/custom_shapes/containers/SearchContainer.dart';
import '../../../../common/widgets/effects/vertical_tour_shimmer.dart';
import '../../../../common/widgets/image_text_widget/VerticalImageText.dart';
import '../../../../common/widgets/itinerary_cart/cart_menu_icon.dart';
import '../../../../common/widgets/layout/grid_layout.dart';
import '../../../../common/widgets/texts/SectionHeadings.dart';
import '../../../../common/widgets/touristPlace/Card/PlaceTouristCardVertical.dart';
import '../../../../localization/GeolocationController.dart';
import '../../../../utils/constants/images_string.dart';
import '../../../weather/controller/WeatherController.dart';
import '../../../weather/screen/WeatherCard.dart';
import '../../../weather/screen/WeatherCarrousel.dart';
import '../../controllers/tour/TourController.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller=Get.put(TourController());
    final weatherController = Get.put(WeatherController());
    final geolocationController = Get.put(GeolocationController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            PrimaryHeaderContainer(
              child: Column(
                children: [
                  ///AppBar
                  const HomeAppBar(),
                  const SizedBox(height: Sizes.spaceBtwSection2),
                  ///SearchBar
                  SearchContainer(
                    text: 'Buscar en lugares turísticos',
                    showBorder: false,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Explorer()),
                      );
                    },
                  ),
                  const SizedBox(height: Sizes.spaceBtwSection2),
                  ///Categories
                  const Padding(
                    padding: EdgeInsets.only(left: Sizes.defaultSpace),
                    child: Column(
                      children: [
                        ///Headings
                        SectionHeading(title: 'Categorías',showActionButton: false, textColor: Colors.white,),
                        SizedBox(height: Sizes.spaceBtwItems),
                        ///Categories
                        HomeCategories()
                      ],
                    ),
                  ),
                  const SizedBox(height: Sizes.spaceBtwSection),
                ],
              )
            ),
            Padding(padding: const EdgeInsets.all(Sizes.defaultSpace),
            child: Column(
              children: [
                Text('Clima',style: Theme.of(context).textTheme.headlineSmall!.apply(color: Colors.black),maxLines: 1,overflow: TextOverflow.ellipsis),
                const SizedBox(height: 10),
                Obx(() {
                  if (!geolocationController.isGeolocationEnabled.value) {
                    // Si la geolocalización está desactivada, muestra un indicador de carga indefinido
                    return Text('Geolocalización desactivada');
                  } else {
                    // Si la geolocalización está activada, muestra el contenido del clima
                    if (weatherController.isLoadingWeather.value) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return WeatherCarousel(weatherData2: weatherController.weatherData2);
                    }
                  }
                }),
                const SizedBox(height: Sizes.spaceBtwSection),
                SectionHeading(title: 'Lugares Turísticos Populares',onPressed: ()=>Get.to(() => AllTours(
                  title: 'Lugares Turísticos Populares',
                  futureMethod: controller.fetchAllFeaturedProducts()
                ))),
                const SizedBox(height: Sizes.spaceBtwItems),
                Obx((){
                  if(controller.isLoading.value) return const VerticalTourShimmer();
                  if(controller.featuredProducts.isEmpty){
                    return Center(child: Text('Información no encontrada',style: Theme.of(context).textTheme.bodyMedium));
                  }
                  return GridLayout(itemCount: controller.featuredProducts.length,itemBuilder: (_,index)=>PlaceTouristCardVertical(tour: controller.featuredProducts[index]));
                }),
              ],
            ),)
          ],
        ),
      ),
    );
  }
}









