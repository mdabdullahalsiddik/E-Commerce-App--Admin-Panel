import 'package:e_shop_admin/Pages/bottom_navigator_bar_page.dart';
import 'package:e_shop_admin/Static/all_colors.dart';
import 'package:e_shop_admin/Widget/costom_buttom.dart';
import 'package:e_shop_admin/Widget/costom_textfield.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class SingInPage extends StatefulWidget {
  const SingInPage({super.key});

  @override
  State<SingInPage> createState() => _SingInPageState();
}

class _SingInPageState extends State<SingInPage> {
  TextEditingController mailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool passwordValidator = false;
  bool value = false;
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "E-Shop",
          style: TextStyle(
            color: Colors.black,
            fontSize: 50,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          controller: mailController,
                          hintText: "Email",
                          validator: (valueKey) {
                            if (valueKey!.isEmpty) {
                              return ("Enter your mail");
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        CustomTextField(
                          textInputAction: TextInputAction.done,
                          controller: passwordController,
                          hintText: "Password",
                          validator: (valueKey) {
                            if (valueKey!.isEmpty) {
                              return ("Enter your password");
                            }
                            return null;
                          },
                          obscureText: !passwordValidator,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(
                                () {
                                  passwordValidator = !passwordValidator;
                                },
                              );
                            },
                            icon: Icon(
                              passwordValidator
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AllColors.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  CustomButton(
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        try {
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                email: mailController.text,
                                password: passwordController.text,
                              )
                              .then(
                                (value) => Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const BottomNavigatorBarPage(),
                                  ),
                                  (route) => false,
                                ),
                              );
                        } catch (e) {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                e.toString(),
                              ),
                            ),
                          );
                        }
                      }
                    },
                    text: "Sing In",
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
