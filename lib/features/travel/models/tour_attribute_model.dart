class TourAttributeModel{
  String? name;
  final List<String>? values;

  TourAttributeModel({this.name,  this.values});


  toJson() {
    return {
      'Name':name,
      'Values':values,
    };
  }

  factory TourAttributeModel.fromJson(Map<String,dynamic> document){
    final data= document;
    if(data.isEmpty) return TourAttributeModel();
    return TourAttributeModel(
        name: data.containsKey('Name') ?data['Name']:'',
        values: List<String>.from(data['Values']));
  }
}


