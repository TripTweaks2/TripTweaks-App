import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tesis3/features/travel/models/tour_model.dart';

import '../../../features/travel/models/tour_attribute_model.dart';
import '../../../utils/exceptions/TFirebaseException.dart';
import '../../../utils/exceptions/TPlatformException.dart';

class TourRepository extends GetxController {
  static TourRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;


  Future<List<TourModel>> getFeaturedTourModel() async{
    try{
      final snapshot=await _db.collection('Places').where('IsFeatured',isEqualTo: true).limit(4).get();
      final tourModels = snapshot.docs.map((e) => TourModel.fromSnapShot(e)).toList();
      return tourModels;
    } on FirebaseException catch (e){
    throw TFirebaseException(e.code).message;
    } on PlatformException catch (e){
    throw TPlatformException(e.code).message;
    } catch (e){
    throw 'Algo salió mal. Intentar más tarde';
    }
  }


  Future<List<TourModel>> getAllFeaturedTourModel() async{
    try{
      final snapshot=await _db.collection('Places').where('IsFeatured',isEqualTo: true).get();
      final tourModels = snapshot.docs.map((e) => TourModel.fromSnapShot(e)).toList();
      // Debug print the JSON representation of each TourModel
      for (var tour in tourModels) {
        debugPrint('TourModel JSON: ${tour.toJson()}');
      }
      return tourModels;
    } on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e){
      throw TPlatformException(e.code).message;
    } catch (e){
      throw 'Algo salió mal. Intentar más tarde';
    }
  }


  Future<List<TourModel>> fetchToursByQuery(Query query) async{
    try{
      final querySnapshot = await query.get();
      final List<TourModel> tourList=querySnapshot.docs.map((doc) => TourModel.fromQuerySnapshot(doc)).toList();
      return tourList;
    } on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e){
      throw TPlatformException(e.code).message;
    } catch (e){
      throw 'Algo salió mal. Intentar más tarde';
    }
  }


  Future<List<TourModel>> getToursForType({required String typeId, int limit = -1}) async{
    try{
      final querySnapshot = limit  == -1 ? await _db.collection('Places').where('Type.Id',isEqualTo: typeId).get() :
          await _db.collection('Places').where('Type.Id',isEqualTo: typeId).limit(limit).get();
      final tours=querySnapshot.docs.map((doc) => TourModel.fromSnapShot(doc)).toList();
      return tours;
    } on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e){
      throw TPlatformException(e.code).message;
    } catch (e){
      throw 'Algo salió mal. Intentar más tarde';
    }
  }

  Future<List<TourModel>> getToursforCategory({required String categoryId, int limit = -1}) async{
    try{
      QuerySnapshot tourCategorySnapshot = limit  == -1 ? await _db.collection('PlaceCategory').where('categoryId',isEqualTo: categoryId).get() :
      await _db.collection('PlaceCategory').where('categoryId',isEqualTo: categoryId).limit(limit).get();

      List<String> toursIds = tourCategorySnapshot.docs.map((doc) => doc['tourId'] as String).toList();

      final toursQuery = await _db.collection('Places').where(FieldPath.documentId,whereIn: toursIds).get();

      List<TourModel> tours = toursQuery.docs.map((doc) => TourModel.fromSnapShot(doc)).toList();

      return tours;
    } on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e){
      throw TPlatformException(e.code).message;
    } catch (e){
      throw 'Algo salió mal. Intentar más tarde';
    }
  }


  Future<List<TourModel>> getFavoriteTours(List<String> toursIds) async{
    try{
      final snapshot = await _db.collection('Places').where(FieldPath.documentId, whereIn: toursIds).get();
      return snapshot.docs.map((querySnapshot) => TourModel.fromSnapShot(querySnapshot)).toList();
    } on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e){
      throw TPlatformException(e.code).message;
    } catch (e){
      throw 'Algo salió mal. Intentar más tarde';
    }
  }


  Future<List<TourModel>> searchProducts(String query, {String? categoryId, String? brandId}) async {
    try {
      // Reference to the 'products' collection in Firestore
      CollectionReference productsCollection = FirebaseFirestore.instance.collection('Places');

      // Start with a basic query to search for products where the name contains the query
      Query queryRef = productsCollection;

      // Apply the search filter
      if (query.isNotEmpty) {
        queryRef = queryRef.where('Title', isGreaterThanOrEqualTo: query);
      }

      // Apply filters
      if (categoryId != null) {
        print("query" + categoryId);
        queryRef = queryRef.where('CategoryId', isEqualTo: categoryId);
      }

      if (brandId != null) {
        print("query" + brandId);
        queryRef = queryRef.where('Type.Id', isEqualTo: brandId);
      }


      // Execute the query
      QuerySnapshot querySnapshot = await queryRef.get();


      // Map the documents to ProductModel objects
      final products = querySnapshot.docs.map((doc) => TourModel.fromQuerySnapshot(doc)).toList();

      return products;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      print('Error en searchProducts: $e');
      print('Tipo de e: ${e.runtimeType}');
      throw 'Algo salió mal. Por favor intenta más tarde';
    }
  }



  Future<List<String>> getUniqueTourAttributeValuesForSubcategory(String subcategoryId) async {
    try {
      final tourCategorySnapshot = await _db.collection('PlaceCategory').where('categoryId', isEqualTo: subcategoryId).get();
      final List<String> toursIds = tourCategorySnapshot.docs.map((doc) => doc['tourId'] as String).toList();

      final toursQuery = await _db.collection('Places').where(FieldPath.documentId, whereIn: toursIds).get();
      final List<String> uniqueAttributeValues = [];

      toursQuery.docs.forEach((doc) {
        final TourModel tourModel = TourModel.fromSnapShot(doc);
        final List<TourAttributeModel>? attributes = tourModel.tourAttributes;

        if (attributes != null) {
          attributes.forEach((attribute) {
            uniqueAttributeValues.addAll(attribute.values ?? []);
          });
        }
      });

      // Convertir a un conjunto para obtener valores únicos
      final uniqueSet = uniqueAttributeValues.toSet();
      // Convertir de nuevo a una lista
      final List<String> uniqueList = uniqueSet.toList();
      return uniqueList;
    } catch (e) {
      throw 'Error al obtener valores de atributos únicos para la subcategoría $subcategoryId: $e';
    }
  }

}