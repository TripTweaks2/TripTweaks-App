import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tesis3/features/travel/models/tour_model.dart';
import 'package:tesis3/utils/constants/sizes.dart';

class ImagesController extends GetxController {
  static ImagesController get instance => Get.find();

  RxString selectedProductImage=''.obs;

  List<String> getAllProductImages(TourModel tourModel) {
    Set<String> images = {};
    
    images.add(tourModel.thumbnail);

    selectedProductImage.value=tourModel.thumbnail;

    if(tourModel.images!=null){
      images.addAll(tourModel.images!);
    }

    return images.toList();
  }

  void showEnlargedImage(String image){
    Get.to(
      fullscreenDialog: true,
        ()=>Dialog.fullscreen(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(padding: const EdgeInsets.symmetric(vertical: Sizes.defaultSpace* 2,horizontal: Sizes.defaultSpace),
              child: CachedNetworkImage(imageUrl: image),
              ),
              const SizedBox(height: Sizes.spaceBtwSection),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: 150,
                  child: OutlinedButton(onPressed: ()=>Get.back(),child: const Text('Cerrar'),),
                ),
              )
            ],
          ),
        )
    );
  }

}
