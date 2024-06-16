import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tesis3/features/travel/models/tour_attribute_model.dart';
import 'package:tesis3/features/travel/models/type_Model.dart';

class TourModel{
  String id;
  TypeModel? typeModel;
  String title;
  bool? isFeatured;
  String? categoryId;
  String? description;
  List<String>? images;
  List<TourAttributeModel>? tourAttributes;
  String? tipoIngreso;
  String thumbnail;


  TourModel({
    required this.id,
    required this.title,
    this.typeModel,
    this.isFeatured,
    this.categoryId,
    this.description,
    this.images,
    this.tourAttributes,
    this.tipoIngreso,
    required this.thumbnail
  });

  static TourModel empty() => TourModel(id: '', title: '', thumbnail: '');

  toJson(){
    return {
      'Title':title,
      'Images':images ?? [],
      'IsFeatured':isFeatured,
      'CategoryId':categoryId,
      'Type':typeModel!.toJson(),
      'Descripcion':description,
      'Thumbnail':thumbnail,
      'TourAttributes': tourAttributes!=null ? tourAttributes!.map((e) => e.toJson()).toList() : [],
      'TipoIngreso':tipoIngreso
    };
  }

  factory TourModel.fromSnapShot(DocumentSnapshot<Map<String, dynamic>> documentSnapshot) {
    if (documentSnapshot.data() == null) return TourModel.empty();
    final data = documentSnapshot.data()!;
    return TourModel(
      id: documentSnapshot.id,
      title: data['Title'],
      isFeatured: data['IsFeatured'] ?? false,
      images: data['Images'] != null ? List<String>.from(data['Images']) : [],
      categoryId: data['CategoryId'] ?? '',
      typeModel: TypeModel.fromJson(data['Type']),
      description: data['Descripcion'] ?? '',
      tourAttributes: data['TourAttributes'] != null
          ? (data['TourAttributes'] as List<dynamic>).map((e) => TourAttributeModel.fromJson(e)).toList()
          : null, // Aquí se maneja el caso en el que TourAttributes sea nulo
      tipoIngreso: data['TipoIngreso'] ?? '',
      thumbnail: data['Thumbnail'] ?? '',
    );
  }

  factory TourModel.fromQuerySnapshot(QueryDocumentSnapshot<Object?> document){
    final data=document.data() as Map<String,dynamic>;
    return TourModel(
      id: document.id,
      title: data['Title'] ?? '',
      isFeatured: data['IsFeatured'] ?? false,
      images: data['Images'] !=null ? List<String>.from(data['Images']):[],
      categoryId: data['CategoryId'] ?? '',
      typeModel: TypeModel.fromJson(data['Type']),
      description: data['Descripcion']?? '',
      tourAttributes: data['TourAttributes'] != null
          ? (data['TourAttributes'] as List<dynamic>).map((e) => TourAttributeModel.fromJson(e)).toList()
          : null,
      tipoIngreso:  data['TipoIngreso'] ?? '',
      thumbnail: data['Thumbnail'] ?? '',
    );
  }
}