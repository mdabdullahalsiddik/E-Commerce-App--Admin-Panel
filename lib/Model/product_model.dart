// ignore_for_file: public_member_api_docs, sort_constructors_first

class ProductModel {
  String? title;
  String? image;
  int? quantity;
  var price;

  String? id;
  String? categoryID;
  List? size;
  List? color;

  ProductModel({
    required this.title,
    required this.image,
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

    map['quantity'] = quantity;
    map['price'] = price;
    map['id'] = id;
    map['size'] = size;
    map['color'] = color;
    map['categoryID'] = categoryID;

    return map;
  }
}
