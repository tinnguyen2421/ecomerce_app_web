import 'dart:convert';

class BannerModel {
  final String id;
  final String image;

  BannerModel({required this.id, required this.image});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "image": image,
    };
  }

  //Serialization:Convert Map to a Json String
  String toJson() => json.encode(toMap());

  factory BannerModel.fromMap(Map<String, dynamic> map) {
    return BannerModel(
      id: map['_id'] as String,
      image: map['image'] as String,
    );
  }
  factory BannerModel.fromJson(String source) =>
      BannerModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
