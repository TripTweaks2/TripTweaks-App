import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tesis3/common/widgets/Icons/CircularIcon.dart';
import 'package:tesis3/common/widgets/app_bar/appBar.dart';
import 'package:tesis3/common/widgets/layout/grid_layout.dart';
import 'package:tesis3/common/widgets/loaders/animation_loader.dart';
import 'package:tesis3/common/widgets/touristPlace/Card/PlaceTouristCardVertical.dart';
import 'package:tesis3/features/travel/controllers/tour/FavoritesController.dart';
import 'package:tesis3/features/travel/screens/explorer/Explorer.dart';
import 'package:tesis3/features/travel/screens/home/home.dart';
import 'package:tesis3/navigation_menu.dart';
import 'package:tesis3/utils/constants/images_string.dart';
import 'package:tesis3/utils/constants/sizes.dart';
import 'package:tesis3/utils/helpers/cloud_helper_function.dart';

import '../../../../common/widgets/effects/vertical_tour_shimmer.dart';
import '../../../../data/repositories/tour/TourRepository.dart';
import '../../controllers/tour/TourController.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FavoritesController());
    Get.put(TourRepository()); // Asegúrate de que TourRepository esté inicializado
    Get.put(TourController()); // Inicializa TourController también

    return Scaffold(
      appBar: TAppBar(
        title: Text('Lista de Favoritos',style: Theme.of(context).textTheme.headlineMedium),
        actions: [
          CircularIcon(icon: Iconsax.add,onPressed: ()=>Get.to(const Explorer())),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(Sizes.defaultSpace),
            child: Obx(
              () => FutureBuilder (
                future:controller.favoriteTours(),
                builder: (context,snapshot) {
                  final emptyWidget = AnimationLoaderWidget(
                      text: 'La lista de favoritos está vacía...',
                      animation: Images.pencil,
                      showAction: true,
                      actionText: 'Agreguemos algo',
                      onActionPressed: () => Get.off(() => const NavigationMenu()),
                  );
                  
                  const loader = VerticalTourShimmer(itemCount: 6);
                  final widget = CloudHelperFunction.checkMultiRecordState(snapshot: snapshot,loader: loader,nothingFound: emptyWidget);
                  if(widget !=null) return widget;
              
                  final tours=snapshot.data!;
              
                  return GridLayout(itemCount: tours.length,itemBuilder: (_,index)=>PlaceTouristCardVertical(tour: tours[index]));
                }
                         ),
            )
        ),
      ),
    );
  }
}
