import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tesis3/features/travel/models/category_model.dart';

import '../../../utils/exceptions/TFirebaseException.dart';
import '../../../utils/exceptions/TPlatformException.dart';

class CategoryRepository extends GetxController {
  static CategoryRepository get instance => Get.find();
  final _db=FirebaseFirestore.instance;


  //GET ALL CATEGORIES
  Future<List<CategoryModel>> getAllCategories() async{
    try{
      final snapShot=await _db.collection('Categories').get();
      final list=snapShot.docs.map((document) => CategoryModel.fromSnapShot(document)).toList();
      return list;
    }on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e){
      throw TPlatformException(e.code).message;
    } catch (e){
      throw 'Algo salió mal. Intentar más tarde';
    }
  }


  //GET SUB CATEGORIES
  Future<List<CategoryModel>> getSubCategories(String categoryId) async{
    try{
      final snapshot=await _db.collection('Categories').where('ParentId',isEqualTo: categoryId).get();
      final result=snapshot.docs.map((e) => CategoryModel.fromSnapShot(e)).toList();
      return result;
    }on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e){
      throw TPlatformException(e.code).message;
    } catch (e){
      throw 'Algo salió mal. Intentar más tarde';
    }
  }

}