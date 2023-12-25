// ignore_for_file: public_member_api_docs, sort_constructors_first

class ProductModel {
  String? title;
  String? image;
  String? about;
  int? quantity;
  // ignore: prefer_typing_uninitialized_variables
  var price;

  String? id;
  String? categoryID;
  List? size;
  List? color;

  ProductModel({
    required this.title,
    required this.image,
    required this.about,
    this.quantity,
    required this.price,
    required this.id,
    this.size,
    this.color,
    this.categoryID,
  });

  ProductModel.fromJson(dynamic json) {
    title = json['title'];

    image = json['image'];
    about = json['about'];
    quantity = json['quantity'];
    price = json['price'];
    id = json['id'];
    size = json['size'];
    color = json['color'];
    categoryID = json['categoryID'];
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['image'] = image;
    map['about'] = about;

    map['quantity'] = quantity;
    map['price'] = price;
    map['id'] = id;
    map['size'] = size;
    map['color'] = color;
    map['categoryID'] = categoryID;

    return map;
  }
}
