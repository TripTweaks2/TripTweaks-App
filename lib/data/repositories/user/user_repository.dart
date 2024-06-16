import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tesis3/data/repositories/authentication/authentication_repository.dart';
import '../../../features/personalization/models/user_model.dart';
import '../../../utils/exceptions/TFirebaseException.dart';
import '../../../utils/exceptions/TPlatformException.dart';

class UserRepository extends GetxController{
  static UserRepository get instance =>Get.find();

  final FirebaseFirestore _db=FirebaseFirestore.instance;

  Future<void> saveUserRecord(UserModel user) async{
    try{
      await _db.collection("Users").doc(user.id).set(user.toJson());
    } on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_){
      throw const FormatException();
    } on PlatformException catch (e){
      throw TPlatformException(e.code).message;
    } catch (e){
      throw 'Algo salió mal. Intentar más tarde';
    }
  }

  Future<UserModel> fetchUserDetails() async{
    try{
      final documentSnapshot=await _db.collection("Users").doc(AuthenticationRepository.instance.authUser?.uid).get();
      if(documentSnapshot.exists){
        return UserModel.fromSnapshot(documentSnapshot);
      }else{
        return UserModel.empty();
      }

    } on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_){
      throw const FormatException();
    } on PlatformException catch (e){
      throw TPlatformException(e.code).message;
    } catch (e){
      throw 'Algo salió mal. Intentar más tarde';
    }
  }




  Future<void> updateUserDetails(UserModel updatedUser) async{
    try{
     await _db.collection("Users").doc(updatedUser.id).update(updatedUser.toJson());
    } on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_){
      throw const FormatException();
    } on PlatformException catch (e){
      throw TPlatformException(e.code).message;
    } catch (e){
      throw 'Algo salió mal. Intentar más tarde';
    }
  }


  Future<void> updateSingleField(Map<String,dynamic> json) async{
    try{
      await _db.collection("Users").doc(AuthenticationRepository.instance.authUser?.uid).update(json);
    } on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_){
      throw const FormatException();
    } on PlatformException catch (e){
      throw TPlatformException(e.code).message;
    } catch (e){
      throw 'Algo salió mal. Intentar más tarde';
    }
  }


  Future<void> removeUser(String userId) async{
    try{
      await _db.collection("Users").doc(userId).delete();
    } on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_){
      throw const FormatException();
    } on PlatformException catch (e){
      throw TPlatformException(e.code).message;
    } catch (e){
      throw 'Algo salió mal. Intentar más tarde';
    }
  }

  Future<String> uploadImage(String path,XFile image) async{
    try{
      final ref=FirebaseStorage.instance.ref(path).child(image.name);
      await ref.putFile(File(image.path));
      final url= await ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_){
      throw const FormatException();
    } on PlatformException catch (e){
      throw TPlatformException(e.code).message;
    } catch (e){
      throw 'Algo salió mal. Intentar más tarde';
    }
  }



}