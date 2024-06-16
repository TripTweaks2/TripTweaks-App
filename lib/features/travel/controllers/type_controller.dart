import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tesis3/data/repositories/tour/TourRepository.dart';
import 'package:tesis3/features/travel/models/tour_model.dart';

import '../../../common/widgets/loaders/loaders.dart';
import '../../../data/repositories/types/type_repository.dart';
import '../models/type_Model.dart';

class TypeController extends GetxController {
  static TypeController get instance => Get.find();

  RxBool isLoading=true.obs;
  final RxList<TypeModel> featuredTypes = <TypeModel>[].obs;
  final RxList<TypeModel> allTypes = <TypeModel>[].obs;
  final typeRepository= Get.put(TypeRepository());

  @override
  void onInit(){
    super.onInit();
    getFeaturedTypes();
  }


  Future<void> getFeaturedTypes() async{
    try{
      isLoading.value=true;
      final types=await typeRepository.getAllTypes();
      allTypes.assignAll(types);
      featuredTypes.assignAll(allTypes.where((type) => type.isFeatured ?? false));
    } catch (e){
      Loaders.errorSnackBar(title: 'Oh vaya!', message: e.toString());
    } finally {
      isLoading.value=false;
    }
  }

  Future<List<TypeModel>> getTypeForCategory(String categoryId) async{
    try{
      print("categoryId" + categoryId);
      final types =  await typeRepository.getTypeForCategory(categoryId);
      return types;
    } catch (e) {
      Loaders.errorSnackBar(title: 'Oh vaya!', message: e.toString());
      return [];
    }
  }

  Future<List<TourModel>> getTypeProducts({required String typeId, int limit = -1}) async{
    try{
      final tours =  await TourRepository.instance.getToursForType(typeId: typeId, limit: limit);
      return tours;
    } catch (e) {
      Loaders.errorSnackBar(title: 'Oh vaya!', message: e.toString());
      return [];
    }
  }

}