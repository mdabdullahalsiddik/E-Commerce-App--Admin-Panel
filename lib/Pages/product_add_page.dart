// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:e_shop_admin/Funcition/firebase_funcition.dart';
import 'package:e_shop_admin/Model/product_model.dart';

import 'package:e_shop_admin/Static/all_colors.dart';
import 'package:e_shop_admin/Widget/costom_textfield.dart';

// ignore: must_be_immutable
class ProductAddPage extends StatefulWidget {
  String? categoryTitle;
  String? categoryID;
  ProductAddPage({
    super.key,
    this.categoryTitle,
    this.categoryID,
  });

  @override
  State<ProductAddPage> createState() => _ProductAddPageState();
}

class _ProductAddPageState extends State<ProductAddPage> {
  XFile? image;
  @override
  void initState() {
    FirebaseGetData().categoryGetData();
    super.initState();
  }

  var formKey = GlobalKey<FormState>();
  TextEditingController productIDController = TextEditingController();

  TextEditingController productTitleController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();

  String? images;
  sendImage() async {
    // var dataKye = DateTime.now().microsecond;

    var imagePath = await FirebaseStorage.instance
        .ref(
          "Product",
        )
        .child(productIDController.text)
        .child(
            "${widget.categoryTitle}_${productTitleController.text}_${productIDController.text}")
        .putFile(File(image!.path));
    images = await imagePath.ref.getDownloadURL();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.categoryTitle.toString()),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AllColors.primaryColor,
        onPressed: () {
          _showDialog(context);
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      body: FutureBuilder(
        future: FirebaseGetData().productGetData(
          widget.categoryTitle.toString(),
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 1,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                // var data = snapshot.data!.snapshot.children.elementAt(index);
                var data = snapshot.data![index];
                return InkWell(
                  onTap: () async {
                    setState(() {
                      FirebaseDatabase.instance
                          .ref("Product")
                          .child(widget.categoryTitle.toString())
                          .child(data.id.toString())
                          .remove();
                    });
                    await FirebaseStorage.instance
                        .ref("Product")
                        .child(data.id.toString())
                        .delete();
                  },
                  child: Card(
                    color: AllColors.primaryColor,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: NetworkImage(
                              data.image.toString(),
                            ),
                          ),
                          Text(
                            "Name : ${data.title.toString()}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Price : ${data.price.toString()}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "ID : ${data.id.toString()}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  _showDialog(BuildContext context) {
    return showDialog(
      useRootNavigator: false,
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text("Enter Product Details"),
            content: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    InkWell(
                      onTap: () async {
                        ImagePicker p = ImagePicker();
                        image = await p.pickImage(source: ImageSource.gallery);
                        setState(
                          () {},
                        );
                      },
                      child: CircleAvatar(
                        radius: 58,
                        backgroundImage: image == null
                            ? const AssetImage("assets/images/camera.png")
                                as ImageProvider
                            : FileImage(
                                File(image!.path),
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            controller: productIDController,
                            hintText: "Product ID",
                            validator: (valueKey) {
                              if (valueKey!.isEmpty) {
                                return ("Enter Product ID");
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextField(
                            controller: productTitleController,
                            hintText: "Product Name ",
                            validator: (valueKey) {
                              if (valueKey!.isEmpty) {
                                return ("Enter Product Name ");
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextField(
                            controller: productPriceController,
                            hintText: "Product Price ",
                            validator: (valueKey) {
                              if (valueKey!.isEmpty) {
                                return ("Enter Product Price ");
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                          AllColors.primaryColor,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context, false);
                        productIDController.clear();
                        productPriceController.clear();
                        productTitleController.clear();

                        image = null;
                      },
                      child: const Text(
                        "No",
                        style: TextStyle(color: Colors.black),
                      )),
                  ElevatedButton(
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                        AllColors.primaryColor,
                      ),
                    ),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        await sendImage();
                        await FirebaseDatabase.instance
                            .ref("Product")
                            .child(
                              widget.categoryTitle.toString(),
                            )
                            .child(
                              productIDController.text.toLowerCase(),
                            )
                            .set(
                              ProductModel(
                                size: ["1", "2", "3"],
                                title: productTitleController.text,
                                image: images,
                                price: int.parse(productPriceController.text),
                                id: productIDController.text,
                                quantity: 1,
                                categoryID: widget.categoryID,
                              ).toJson(),
                            );
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context, false);
                        productIDController.clear();
                        productPriceController.clear();
                        productTitleController.clear();

                        image = null;

                        productIDController.clear();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Fill all the field",
                            ),
                          ),
                        );
                      }
                    },
                    child: const Text(
                      "Yes",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              )
            ],
          );
        });
      },
    );
  }
}
