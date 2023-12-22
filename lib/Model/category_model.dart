// ignore_for_file: public_member_api_docs, sort_constructors_first

class CategoryModel {
  String? title;
  String? image;
  String? id;

  CategoryModel({
    required this.title,
    required this.image,
    required this.id,
  });

  CategoryModel.fromJson(dynamic json) {
    title = json['title'];

    image = json['image'];
    id = json['id'];
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['image'] = image;

    map['id'] = id;

    return map;
  }
}
