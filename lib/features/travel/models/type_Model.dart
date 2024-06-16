import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class TypeModel{
  String id;
  String name;
  String image;
  bool? isFeatured;
  int? toursCount;

  TypeModel({required this.id, required this.name, required this.image, this.isFeatured, this.toursCount});

  static TypeModel empty() => TypeModel(id:'',image: '',name: '');

  toJson() {
    return {
      'Id':id,
      'Name':name,
      'Image':image,
      'ToursCount':toursCount,
      'IsFeatured':isFeatured
    };
  }

  factory TypeModel.fromJson(Map<String,dynamic> document){
    final data= document;
    if(data.isEmpty) return TypeModel.empty();
    return TypeModel(
        id: data['Id'] ?? '',
        name: data['Name'] ?? '',
        image: data['Image'] ?? '',
        toursCount: int.parse((data['ToursCount'] ?? 0).toString()),
        isFeatured: data['IsFeatured'] ?? false);
  }

  factory TypeModel.fromSnapshot(DocumentSnapshot<Map<String,dynamic>> document){
    if(document.data() != null){
      final data= document.data()!;

      return TypeModel(id: document.id ?? '', name: data['Name'] ?? '', image: data['Image'] ?? '', toursCount: data['ToursCount'] ?? '', isFeatured: data['IsFeatured'] ?? false);
    } else {
      return TypeModel.empty();
    }
  }



}