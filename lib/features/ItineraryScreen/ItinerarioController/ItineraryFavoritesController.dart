import 'dart:convert';

import 'package:get/get.dart';
import 'package:tesis3/features/ItineraryScreen/ItineraryRepository/ItineraryRepository.dart';
import 'package:tesis3/features/Questionv2/ItinerarioPlaceV2Model.dart';

import '../../../common/widgets/loaders/loaders.dart';
import '../../../utils/local_storage/storage_utility.dart';

class ItineraryFavoritesController extends GetxController {
  static ItineraryFavoritesController get instance => Get.find();

  final favorites = <String, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    Get.put(ItinerarioRepository()); // Registrar aquí el repositorio
    initFavorites();
  }

  Future<void> initFavorites() async {
    final json = LocalStorage.instance().readData('itineraryFavorites');
    if (json != null) {
      final itinerariosFavoritos = jsonDecode(json) as Map<String, dynamic>;
      favorites.assignAll(itinerariosFavoritos.map((key, value) => MapEntry(key, value as bool)));
    }
  }

  bool isFavorite(String itineraryId) {
    return favorites[itineraryId] ?? false;
  }

  void toggleFavoriteItinerary(String itineraryId) {
    if (!favorites.containsKey(itineraryId)) {
      favorites[itineraryId] = true;
      saveFavoritesToStorage();
      Loaders.customToast(message: 'Itinerario ha sido agregado a tu lista de Favoritos');
    } else {
      LocalStorage.instance().removeData(itineraryId);
      favorites.remove(itineraryId);
      saveFavoritesToStorage();
      favorites.refresh();
      Loaders.customToast(message: 'Itinerario ha sido eliminado de tu lista de Favoritos');
    }
  }

  void saveFavoritesToStorage() {
    final encodedFavorites = json.encode(favorites);
    LocalStorage.instance().saveData('itineraryFavorites', encodedFavorites);
  }

  Future<List<ItinerarioV2>> favoritesItinerarios() async{
    return await ItinerarioRepository.instance.getFavoriteItineraries(favorites.keys.toList());
  }
}