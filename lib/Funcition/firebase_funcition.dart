import 'dart:convert';

import 'package:e_shop_admin/Model/category_model.dart';
import 'package:e_shop_admin/Model/product_model.dart';

import 'package:firebase_database/firebase_database.dart';

class FirebaseGetData {
  Future<List<CategoryModel>> categoryGetData() async {
    List<CategoryModel> data = [];
    await FirebaseDatabase.instance.ref("Category").orderByKey().get().then(
      (value) {
        for (var i in value.children) {
          data.add(
            CategoryModel.fromJson(
              jsonDecode(
                jsonEncode(i.value),
              ),
            ),
          );
        }
      },
    );
    return data;
  }

  Future<List<ProductModel>> productGetData(String categoryTitle) async {
    List<ProductModel> data = [];
    await FirebaseDatabase.instance
        .ref("Product")
        .child(categoryTitle)
        .orderByKey()
        .get()
        .then(
      (value) {
        for (var i in value.children) {
          data.add(
            ProductModel.fromJson(
              jsonDecode(
                jsonEncode(i.value),
              ),
            ),
          );
        }
      },
    );
    return data;
  }
}
