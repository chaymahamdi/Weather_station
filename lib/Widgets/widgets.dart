import 'package:flutter/material.dart';

Widget button({required String val, required Function onTap}) {
  // ignore: deprecated_member_use
  return Container(
    height: 50,
    width: 400,
    child: Center(
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(
            color: Colors.transparent,
          ),
        ),
        onPressed: () {
          onTap();
        },
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 91, 96, 139),
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Container(
            constraints: BoxConstraints(maxWidth: 220.0, minHeight: 50.0),
            alignment: Alignment.center,
            child: Text(
              val,
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
          ),
        ),
      ),
    ),
  );
}
