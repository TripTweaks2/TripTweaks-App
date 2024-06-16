import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:tesis3/data/repositories/categories/category_repository.dart';
import 'package:tesis3/data/repositories/tour/TourRepository.dart';
import 'package:tesis3/features/travel/models/tour_model.dart';

import '../../../common/widgets/loaders/loaders.dart';
import '../models/category_model.dart';

class CategoryController extends GetxController{
  static CategoryController get instance => Get.find();

  final isLoading=false.obs;
  final _categoryRepository=Get.put(CategoryRepository());
  RxList<CategoryModel> allCategories=<CategoryModel>[].obs;
  RxList<CategoryModel> featuredCategories=<CategoryModel>[].obs;
  RxList<CategoryModel> parentIdCategories= <CategoryModel>[].obs;

  @override
  void onInit(){
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async{
    try{
      isLoading.value=true;
      final categories = await _categoryRepository.getAllCategories();
      allCategories.assignAll(categories);

      featuredCategories.assignAll(allCategories.where((category) => category.isFeatured && category.parentId.isEmpty).toList());
      // Imprime el contenido de featuredCategories en la consola
      // Dentro de la función fetchCategories
      //for (var category in featuredCategories) {
      //  debugPrint('ID: ${category.id}, Name: ${category.name}, Image URL: ${category.image}');
      //}
    } catch(e){
      Loaders.warningSnackBar(title: 'Oh vaya!', message: e.toString());
    } finally {
      isLoading.value=false;
    }
  }

  Future<List<CategoryModel>> getSubCategories(String categoryId) async {
    try{
      final subcategories = await _categoryRepository.getSubCategories(categoryId);
      //for (var category in subcategories){
      //  debugPrint('Subcategorías de ${category.name}: $subcategories');
      //}
      return subcategories;
    } catch(e){
      Loaders.warningSnackBar(title: 'Oh vaya!', message: e.toString());
      return [];
    }
  }

  Future<List<TourModel>> getCategoryTour({required String categoryId, int limit =4}) async{
    final tours = await TourRepository.instance.getToursforCategory(categoryId: categoryId,limit:limit);
    for (var tour in tours){
      debugPrint('TOURS de ${tour.title}');
    }
    return tours;
  }


  Future<List<String>> getUniqueTourAttributeValuesForSubcategory(String subcategoryId) async {
    try {
      final uniqueValues = await TourRepository.instance.getUniqueTourAttributeValuesForSubcategory(subcategoryId);
      return uniqueValues;
    } catch (e) {
      throw 'Error al obtener valores de atributos únicos para la subcategoría $subcategoryId: $e';
    }
  }
}