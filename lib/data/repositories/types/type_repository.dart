import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:tesis3/features/travel/models/type_Model.dart';
import 'package:tesis3/utils/exceptions/TFormatException.dart';

import '../../../utils/exceptions/TFirebaseException.dart';
import '../../../utils/exceptions/TPlatformException.dart';

class TypeRepository extends GetxController {
  static TypeRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;

  Future<List<TypeModel>> getAllTypes() async{
    try {
      final snapshot= await _db.collection('Types').get();
      debugPrint('Snapshot: $snapshot');
      final result = snapshot.docs.map((e) => TypeModel.fromSnapshot(e)).toList();
      debugPrint('Result: $result');
      return result;
    }on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_){
      throw const TFormatException();
    } on PlatformException catch (e){
      throw TPlatformException(e.code).message;
    } catch (e){
      throw 'Algo salió mal. Intentar más tarde';
    }
  }



  Future<List<TypeModel>> getTypeForCategory(String categoryId) async{
    try {
      QuerySnapshot typeCategoryQuery = await _db.collection('TypeCategory').where('categoryId',isEqualTo: categoryId).get();

      List<String> typesId = typeCategoryQuery.docs.map((doc) => doc['typeId'] as String).toList();

      final typeQuery = await _db.collection('Types').where(FieldPath.documentId,whereIn: typesId).limit(2).get();

      List<TypeModel> types=typeQuery.docs.map((doc) => TypeModel.fromSnapshot(doc)).toList();

      for (TypeModel type in types) {
        print(type.name); // Por ejemplo, imprimir cada objeto TypeModel
      }
      return types;
    }on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_){
      throw const TFormatException();
    } on PlatformException catch (e){
      throw TPlatformException(e.code).message;
    } catch (e){
      throw 'Algo salió mal. Intentar más tarde';
    }
  }


}