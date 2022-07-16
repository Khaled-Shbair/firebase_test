import 'package:flutter/material.dart';

mixin Helpers {
  void showSnackBar(BuildContext context,
      {required String massage, bool erorr = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(massage),
        backgroundColor: erorr ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        dismissDirection: DismissDirection.horizontal,
        padding: const EdgeInsetsDirectional.only(
          start: 20,
          end: 20,
        ),
      ),
    );
  }
}
