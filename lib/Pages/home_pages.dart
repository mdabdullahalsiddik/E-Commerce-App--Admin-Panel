import 'dart:io';
import 'package:e_shop_admin/Funcition/firebase_funcition.dart';
import 'package:e_shop_admin/Model/category_model.dart';
import 'package:e_shop_admin/Pages/product_add_page.dart';
import 'package:e_shop_admin/Static/all_colors.dart';
import 'package:e_shop_admin/Widget/costom_textfield.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  XFile? image;
  @override
  void initState() {
    FirebaseGetData().categoryGetData();
    super.initState();
  }

  var formKey = GlobalKey<FormState>();
  TextEditingController categoryNameController = TextEditingController();
  TextEditingController categoryIdController = TextEditingController();

  String? images;
  sendImage() async {
    var dataKye = DateTime.now().microsecond;

    var imagePath = await FirebaseStorage.instance
        .ref(
          "Category",
        )
        .child(
          "${categoryNameController.text}_${categoryIdController.text}",
        )
        .putFile(File(image!.path));
    images = await imagePath.ref.getDownloadURL();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
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
        stream: FirebaseGetData().categoryGetData().asStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 1,
              ),
              itemBuilder: (context, index) {
                // var data = snapshot.data!.snapshot.children.elementAt(index);
                var data = snapshot.data![index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => ProductAddPage(
                          categoryTitle: data.title,
                          categoryID: data.id,
                        ),
                      ),
                    );
                  },
                  onLongPress: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: const Text(
                            "Delete Category?",
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
                                        .ref("Category")
                                        .child(
                                            data.title.toString().toLowerCase())
                                        .remove();
                                    FirebaseDatabase.instance
                                        .ref("Product")
                                        .child(data.title.toString())
                                        .remove();
                                    FirebaseStorage.instance
                                        .ref("Category")
                                        .child(
                                          "${categoryNameController.text}_${categoryIdController.text}",
                                        )
                                        .delete();
                                    FirebaseStorage.instance
                                        .ref("Product")
                                        .child(data.title.toString())
                                        .delete();
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(
                              data.image.toString(),
                            ),
                          ),
                          Text(
                            "Category Name : ${data.title.toString()}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Category ID : ${data.id.toString()}",
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
            title: const Text("Enter Category Details"),
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
                        radius: 50,
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
                            controller: categoryNameController,
                            hintText: "Category Name",
                            validator: (valueKey) {
                              if (valueKey!.isEmpty) {
                                return ("Enter Category Name");
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          CustomTextField(
                            controller: categoryIdController,
                            hintText: "Category ID",
                            keyboardType: TextInputType.number,
                            validator: (valueKey) {
                              if (valueKey!.isEmpty) {
                                return ("Enter Category Id");
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
              ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      AllColors.primaryColor,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context, false);
                    categoryNameController.clear();
                    categoryIdController.clear();
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
                        .ref("Category")
                        .child(
                          categoryNameController.text.toLowerCase(),
                        )
                        .set(
                          CategoryModel(
                            title: categoryNameController.text,
                            image: images,
                            id: categoryIdController.text,
                          ).toJson(),
                        );
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context, false);
                    categoryNameController.clear();
                    categoryIdController.clear();
                    image = null;

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
