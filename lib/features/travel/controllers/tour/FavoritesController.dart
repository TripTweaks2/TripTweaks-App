import 'dart:convert';

import 'package:get/get.dart';
import 'package:tesis3/common/widgets/loaders/loaders.dart';
import 'package:tesis3/data/repositories/tour/TourRepository.dart';
import 'package:tesis3/features/travel/models/tour_model.dart';
import 'package:tesis3/utils/local_storage/storage_utility.dart';

class FavoritesController extends GetxController {
  static FavoritesController get instance => Get.find();

  final favorites=<String,bool>{}.obs;

  @override
  void onInit(){
    super.onInit();
    initFavorites();
  }

  Future<void> initFavorites() async{
    final json=LocalStorage.instance().readData('favorites');
    if(json !=null){
      final toursFavorited = jsonDecode(json) as Map<String,dynamic>;
      favorites.assignAll(toursFavorited.map((key, value) => MapEntry(key, value as bool)));
    }
  }

  bool isFavorite(String tourId) {
    return favorites[tourId] ?? false;
  }

  void toggleFavoriteTour(String tourId){
    if(!favorites.containsKey(tourId)){
      favorites[tourId] = true;
      saveFavoritesToStorage();
      Loaders.customToast(message: 'Lugar turístico ha sido agregado a tu lista de Favoritos');
    } else {
      LocalStorage.instance().removeData(tourId);
      favorites.remove(tourId);
      saveFavoritesToStorage();
      favorites.refresh();
      Loaders.customToast(message: 'Lugar turístico ha sido eliminado de tu lista de Favoritos');
    }
  }

  void saveFavoritesToStorage(){
    final encodedFavorites = json.encode(favorites);
    LocalStorage.instance().saveData('favorites', encodedFavorites);
  }

  Future<List<TourModel>> favoriteTours() async{
    return await TourRepository.instance.getFavoriteTours(favorites.keys.toList());
  }
}