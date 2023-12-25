// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';
import 'package:e_shop_admin/Widget/custom_elevataed_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
  TextEditingController productAboutController = TextEditingController();

  TextEditingController productSizeController = TextEditingController();

  String? images;
  List sizeList = [];
  List colorList = [];
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
          setState(() {
            _showDialog(context);
          });
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseGetData()
            .productGetData(
              widget.categoryTitle.toString(),
            )
            .asStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 1,
                childAspectRatio: 0.5,
              ),
              itemBuilder: (context, index) {
                // var data = snapshot.data!.snapshot.children.elementAt(index);
                var data = snapshot.data![index];
                return InkWell(
                  onLongPress: () {
                    setState(() {});
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: const Text(
                            "Delete Product?",
                            style: TextStyle(color: Colors.red),
                          ),
                          content: const Text("Are you sure?"),
                          actions: [
                            CupertinoDialogAction(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("No"),
                            ),
                            CupertinoDialogAction(
                                onPressed: () async {
                                  await EasyLoading.show(status: 'loading...');

                                  setState(() {
                                    FirebaseDatabase.instance
                                        .ref("Product")
                                        .child(widget.categoryTitle.toString())
                                        .child(data.id.toString())
                                        .remove();
                                    // FirebaseStorage.instance
                                    //     .ref("Product")
                                    //     .child(data.id.toString())
                                    //     .delete();
                                    Navigator.pop(context);
                                  });
                                  EasyLoading.showSuccess('Great Success!');
                                  EasyLoading.dismiss();
                                },
                                child: const Text("Yes")),
                          ],
                        );
                      },
                    );
                  },
                  child: Card(
                    color: AllColors.primaryColor,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: NetworkImage(
                                data.image.toString(),
                              ),
                            ),
                            Text(
                              "Name : ${data.title.toString()}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Price : ${data.price.toString()}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "ID : ${data.id.toString()}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Color : ${data.color.toString()}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Size : ${data.size.toString()}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
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
                            keyboardType: TextInputType.number,
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
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextField(
                            controller: productAboutController,
                            hintText: "Product About ",
                            maxLines: 100,
                            field_height: 100,
                            validator: (valueKey) {
                              if (valueKey!.isEmpty) {
                                return ("Enter Product About... ");
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .40,
                                child: CustomTextField(
                                  controller: productSizeController,
                                  hintText: "Product Size ",
                                ),
                              ),
                              ElevatedButton(
                                style: const ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                    AllColors.primaryColor,
                                  ),
                                ),
                                onPressed: () {
                                  sizeList.add(productSizeController.text);
                                  productSizeController.clear();
                                },
                                child: const Text(
                                  "+ Add Size",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                style: const ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                    AllColors.primaryColor,
                                  ),
                                ),
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(
                                        builder: (context, setState) {
                                          return Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: SizedBox(
                                                height: 400,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Center(
                                                    child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    const Text("Add Color"),
                                                    Column(
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            CustomElevatedButton(
                                                              sizeList:
                                                                  colorList,
                                                              text: 'White',
                                                              onPressed: () {
                                                                colorList.add(
                                                                    "White");
                                                                setState(() {});
                                                              },
                                                              color: colorList.contains(
                                                                          "White") !=
                                                                      true
                                                                  ? Colors.white
                                                                  : AllColors
                                                                      .primaryColor,
                                                              onLongPress: () {
                                                                setState(
                                                                  () {
                                                                    colorList
                                                                        .remove(
                                                                            "White");
                                                                  },
                                                                );
                                                              },
                                                            ),
                                                            CustomElevatedButton(
                                                              sizeList:
                                                                  colorList,
                                                              text: 'Black',
                                                              onPressed: () {
                                                                setState(
                                                                  () {
                                                                    colorList.add(
                                                                        "Black");
                                                                  },
                                                                );
                                                              },
                                                              color: colorList.contains(
                                                                          "Black") !=
                                                                      true
                                                                  ? Colors.black
                                                                  : AllColors
                                                                      .primaryColor,
                                                              onLongPress: () {
                                                                setState(
                                                                  () {
                                                                    colorList
                                                                        .remove(
                                                                            "Black");
                                                                  },
                                                                );
                                                              },
                                                            ),
                                                            CustomElevatedButton(
                                                              sizeList:
                                                                  colorList,
                                                              text: 'Green',
                                                              onPressed: () {
                                                                colorList.add(
                                                                    "Green");
                                                                setState(() {});
                                                              },
                                                              color: colorList.contains(
                                                                          "Green") !=
                                                                      true
                                                                  ? Colors.green
                                                                  : AllColors
                                                                      .primaryColor,
                                                              onLongPress: () {
                                                                setState(
                                                                  () {
                                                                    colorList
                                                                        .remove(
                                                                            "Green");
                                                                  },
                                                                );
                                                              },
                                                            ),
                                                            CustomElevatedButton(
                                                              sizeList:
                                                                  colorList,
                                                              text: 'Blue',
                                                              onPressed: () {
                                                                colorList.add(
                                                                    "Blue");
                                                                setState(() {});
                                                              },
                                                              color: colorList.contains(
                                                                          "Blue") !=
                                                                      true
                                                                  ? Colors.blue
                                                                  : AllColors
                                                                      .primaryColor,
                                                              onLongPress: () {
                                                                setState(
                                                                  () {
                                                                    colorList
                                                                        .remove(
                                                                            "Blue");
                                                                  },
                                                                );
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                          children: [
                                                            CustomElevatedButton(
                                                              sizeList:
                                                                  colorList,
                                                              text: 'Red',
                                                              onPressed: () {
                                                                setState(
                                                                  () {
                                                                    colorList.add(
                                                                        "Red");
                                                                  },
                                                                );
                                                              },
                                                              color: colorList.contains(
                                                                          "Red") !=
                                                                      true
                                                                  ? Colors.red
                                                                  : AllColors
                                                                      .primaryColor,
                                                              onLongPress: () {
                                                                setState(
                                                                  () {
                                                                    colorList
                                                                        .remove(
                                                                            "Red");
                                                                  },
                                                                );
                                                              },
                                                            ),
                                                            CustomElevatedButton(
                                                              sizeList:
                                                                  colorList,
                                                              text: 'Yellow',
                                                              onPressed: () {
                                                                colorList.add(
                                                                    "Yellow");
                                                                setState(() {});
                                                              },
                                                              color: colorList.contains(
                                                                          "Yellow") !=
                                                                      true
                                                                  ? Colors
                                                                      .yellow
                                                                  : AllColors
                                                                      .primaryColor,
                                                              onLongPress: () {
                                                                setState(
                                                                  () {
                                                                    colorList
                                                                        .remove(
                                                                            "Yellow");
                                                                  },
                                                                );
                                                              },
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    ElevatedButton(
                                                      style: const ButtonStyle(
                                                        backgroundColor:
                                                            MaterialStatePropertyAll(
                                                          AllColors
                                                              .primaryColor,
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text(
                                                        "Add",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ],
                                                ))),
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                                child: const Text(
                                  "+ Add Color",
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
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

                    productAboutController.clear();
                    productSizeController.clear();

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
                    setState(() {});
                    await EasyLoading.show(status: 'loading...');

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
                            size: sizeList.isNotEmpty == true
                                ? sizeList
                                : [productSizeController.text],
                            color:
                                colorList.isNotEmpty == true ? colorList : [""],
                            about: productAboutController.text,
                            title: productTitleController.text,
                            image: images,
                            price: int.parse(productPriceController.text),
                            id: productIDController.text,
                            quantity: 1,
                            categoryID: widget.categoryID,
                          ).toJson(),
                        );
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                    productIDController.clear();
                    productPriceController.clear();
                    productTitleController.clear();
                    productAboutController.clear();
                    productSizeController.clear();
                    sizeList.clear();
                    colorList.clear();
                    image = null;
                    productIDController.clear();
                    EasyLoading.showSuccess('Great Success!');
                    EasyLoading.dismiss();
                  } else {
                    EasyLoading.showError('Failed with Error');
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
              )
            ],
          );
        });
      },
    );
  }
}
