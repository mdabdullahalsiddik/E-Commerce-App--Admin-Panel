// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomElevatedButton extends StatelessWidget {
  CustomElevatedButton({
    super.key,
    required this.sizeList,
    required this.text,
    required this.color,
    required this.onPressed,
    required this.onLongPress,
  });
  String? text;
  final List sizeList;

  void Function()? onPressed;
  var color;
  void Function()? onLongPress;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(color),
      ),
      onPressed: onPressed,
      onLongPress: onLongPress,
      child: Text(
        text ?? "NO Data",
        style: TextStyle(
          color: color != Colors.black ? Colors.black : Colors.white,
        ),
      ),
    );
  }
}
