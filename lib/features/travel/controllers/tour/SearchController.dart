import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:tesis3/data/repositories/tour/TourRepository.dart';
import 'package:tesis3/features/travel/models/tour_model.dart';

class TSearchController extends GetxController {
  static TSearchController get instance => Get.find();

  RxList<TourModel> searchResults = <TourModel>[].obs;
  RxBool isLoading = false.obs;
  RxString lastSearchQuery = ''.obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedCategoryId = ''.obs;
  List<String> sortingOptions = ['Nombre'];
  RxString selectedSortingOption = 'Nombre'.obs; // Default sorting option

  void search() {
    searchProducts(
      searchQuery.value,
      categoryId: selectedCategoryId.value.isNotEmpty ? selectedCategoryId.value : null,
      sortingOption: selectedSortingOption.value,
    );
  }


  void searchProducts(String query, {String? categoryId, String? brandId, required String sortingOption}) async {
    lastSearchQuery.value = query;
    isLoading.value = true;

    try {
      print(query);
      final results = await TourRepository.instance
          .searchProducts(query, categoryId: categoryId, brandId: brandId);

      print(results);

      // Apply sorting
      switch (sortingOption) {
        case 'Nombre':
        // Sort by name
          results.sort((a, b) => a.title.compareTo(b.title));
          break;
        default:
          results.sort((a, b) => a.title.compareTo(b.title));
          break;
      }

      // Update searchResults with sorted results
      searchResults.assignAll(results);
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching data: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }
}