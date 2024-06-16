import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel{
  String id;
  String name;
  String image;
  String parentId;
  bool isFeatured;


  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.parentId,
    required this.isFeatured,
  });

  static CategoryModel empty()=> CategoryModel(
      id: '',
      name: '',
      image: '',
      parentId: '',
      isFeatured: false,
    );

  Map<String, dynamic> toJson() {
    return {
      'Name' : name,
      'Image' : image,
      'ParentId' : parentId,
      'IsFeatured' : isFeatured,
    };
  }

  factory CategoryModel.fromSnapShot(DocumentSnapshot<Map<String,dynamic>> documentSnapshot){
    if(documentSnapshot.data()!=null){
      final data=documentSnapshot.data()!;
      return CategoryModel(id: documentSnapshot.id, name: data['Name'] ?? '', image: data['Image'] ?? '', parentId: data['ParentId'] ?? '', isFeatured: data['isFeatured'] ?? false);
    } else{
      return CategoryModel.empty();
    }
  }
}