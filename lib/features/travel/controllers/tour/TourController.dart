import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tesis3/common/widgets/loaders/loaders.dart';
import 'package:tesis3/features/travel/models/tour_model.dart';

import '../../../../data/repositories/tour/TourRepository.dart';

class TourController extends GetxController {
  static TourController get instance => Get.find();

  final isLoading=false.obs;
  final tourRepository=Get.put(TourRepository());
  RxList<TourModel> featuredProducts=<TourModel>[].obs;

  @override
  void onInit(){
    super.onInit();
    fetchFeaturedProducts();
  }

  void fetchFeaturedProducts() async{
    try{
      isLoading.value=true;

      final tours=await tourRepository.getFeaturedTourModel();

      featuredProducts.assignAll(tours);
      for (var tour in featuredProducts) {
        debugPrint('ID: ${tour.id}, Name: ${tour.title}');
      }
    } catch(e){
      Loaders.errorSnackBar(title: 'Oh vaya!',message: e.toString());
    } finally {
      isLoading.value=false;

    }
  }



  Future<List<TourModel>> fetchAllFeaturedProducts() async{
    try{
      final tours=await tourRepository.getAllFeaturedTourModel();
      for (var tour in tours) {
        print('Tour: ${tour.title}, ${tour.thumbnail}');
      }
      return tours;
    } catch(e){
      Loaders.errorSnackBar(title: 'Oh vayaasfdasfas!',message: e.toString());
      return [];
    }
  }

}