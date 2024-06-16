import 'package:cloud_firestore/cloud_firestore.dart';

class TypeCategoryModel{
  final String typeId;
  final String categoryId;

  TypeCategoryModel({required this.typeId, required this.categoryId});

  Map<String,dynamic> toJson(){
    return {
      'typeId':typeId,
      'categoryId':categoryId
    };
  }

  factory TypeCategoryModel.fromSnapshot(DocumentSnapshot snapshot){
    final data=snapshot.data() as Map<String,dynamic>;
    return TypeCategoryModel(
        typeId: data['typeId'] as String,
        categoryId: data['categoryId'] as String
    );
  }
}