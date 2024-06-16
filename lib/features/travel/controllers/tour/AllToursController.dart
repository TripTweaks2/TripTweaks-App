import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tesis3/common/widgets/loaders/loaders.dart';
import 'package:tesis3/data/repositories/tour/TourRepository.dart';
import 'package:tesis3/features/travel/models/tour_model.dart';

class AllToursController extends GetxController {
  static AllToursController get instance => Get.find();

  final repository = TourRepository.instance;
  final RxString selectedSortOption = 'Nombre'.obs;
  final RxList<TourModel> tours=<TourModel>[].obs;

  Future<List<TourModel>> fetchToursByQuery(Query? query) async{
    try{
      if(query == null) return [];
      final tours=await repository.fetchToursByQuery(query);
      return tours;
    } catch (e){
      Loaders.errorSnackBar(title: 'Oh vaya!',message: e.toString());
      return [];
    }
  }

  void sortTours(String sortOption){
    selectedSortOption.value = sortOption;

    switch(sortOption){
      case 'Nombre':
        tours.sort((a,b) => a.title.compareTo(b.title));
        break;
      default:
        tours.sort((a,b) => a.title.compareTo(b.title));
    }

    // Debug print the sorted list
    debugPrint('Sorted tours: $tours');
  }

  void assignTour(List<TourModel> tours){
    this.tours.assignAll(tours);
    sortTours('Nombre');
  }

}
