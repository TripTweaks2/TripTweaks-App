import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tesis3/features/Questionv2/ItinerarioPlaceV2Model.dart';

import '../../../utils/exceptions/TFirebaseException.dart';
import '../../../utils/exceptions/TPlatformException.dart';
import '../../Question/Itinerario/Itinerario.dart';

class ItinerarioRepository  extends GetxController {
  static ItinerarioRepository get instance => Get.find();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveItinerario(Itinerario itinerario) async {
    try {
      await _db.collection("Itinerarios").doc(itinerario.id).set(itinerario.toJson());
    } catch (e) {
      throw 'Error al guardar el itinerario: $e';
    }
  }

  Future<List<Itinerario>?> fetchItinerariosByUserId(String userId) async {
    print(userId);
    try {
      final querySnapshot = await _db.collection("Itinerarios")
          .where('id', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.map((doc) => Itinerario.fromSnapshot(doc)).toList();
      } else {
        return []; // Retorna una lista vacía si no hay itinerarios para el usuario
      }
    } catch (e) {
      print('Error al obtener los itinerarios del usuario: $e');
      return null;
    }
  }


  Future<void> saveItinerarioV2(ItinerarioV2 itinerariov2) async {
    try {
      final itinerarioData = itinerariov2.toJson();

      // Guardamos el itinerario en Firestore
      final docRef = await FirebaseFirestore.instance.collection('ItinerarioV2').add(itinerarioData);

      // Establecemos el ID del itinerario en Firestore como el ID del documento
      itinerariov2.idItinerario = docRef.id;

      // Actualizamos el itinerario en Firestore con el ID del documento
      await docRef.update({'idItinerario': itinerariov2.idItinerario});

    } catch (e) {
      throw 'Error al guardar el itinerario: $e';
    }
  }


  Future<List<ItinerarioV2>?> fetchItinerariosV2ByUserId(String userId) async {
    print(userId);
    try {
      final querySnapshot = await _db.collection("ItinerarioV2")
          .where('idUser', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.map((e) => ItinerarioV2.fromSnapshot(e)).toList();
      } else {
        return []; // Retorna una lista vacía si no hay itinerarios para el usuario
      }
    } catch (e) {
      print('Error al obtener los itinerarios del usuario: $e');
      return null;
    }
  }

  Future<List<ItinerarioV2>> getFavoriteItineraries(List<String> itineraryIds) async{
    try{
      final snapshot = await _db.collection('ItinerarioV2').where(FieldPath.documentId, whereIn: itineraryIds).get();
      return snapshot.docs.map((querySnapshot) => ItinerarioV2.fromSnapshot(querySnapshot)).toList();
    } on FirebaseException catch (e){
      throw TFirebaseException(e.code).message;
    } on PlatformException catch (e){
      throw TPlatformException(e.code).message;
    } catch (e){
      throw 'Algo salió mal. Intentar más tarde';
    }
  }

  Future<void> updateItineraryNameInFirebase(String itineraryId, String newName) async {
    try {
      await _db.collection('ItinerarioV2').doc(itineraryId).update({'name': newName});
    } catch (e) {
      throw 'Error al actualizar el nombre del itinerario en Firebase: $e';
    }
  }

  Future<void> deleteItineraryFromFirebase(String itineraryId) async {
    try {
      // Eliminar el documento del itinerario de Firebase
      await FirebaseFirestore.instance.collection('ItinerarioV2').doc(itineraryId).delete();
    } catch (error) {
      // Capturar y relanzar cualquier error que ocurra durante la eliminación
      throw 'Error al eliminar el itinerario: $error';
    }
  }


}