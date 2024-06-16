import 'package:cloud_firestore/cloud_firestore.dart';

class TourCategoryModel{
  final String tourId;
  final String categoryId;

  TourCategoryModel({required this.tourId, required this.categoryId});

  Map<String,dynamic> toJson(){
    return {
      'tourId':tourId,
      'categoryId':categoryId
    };
  }

  factory TourCategoryModel.fromSnapshot(DocumentSnapshot snapshot){
    final data=snapshot.data() as Map<String,dynamic>;
    return TourCategoryModel(
        tourId: data['tourId'] as String,
        categoryId: data['categoryId'] as String
    );
  }
}