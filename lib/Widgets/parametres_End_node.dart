import 'package:flutter/material.dart';
import 'package:project_cert/main.dart';


/// General utility widget used to render a cell divided into three rows
/// First row displays [label]
/// second row displays [iconData]
/// third row displays [value]
class ValueTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData iconData;

  ValueTile(this.label, this.value,  this.iconData);

  @override
  Widget build(BuildContext context) {


    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          this.label,
          style: TextStyle(
              color: Colors.black,
        )),
         SizedBox(
          height: 5,
        ),
        this.iconData != null
            ? Icon(
          iconData,
          color: Colors.black,
          size: 20,
        )
            : Text("no widget"),
        SizedBox(
          height: 10,
        ),
        Text(
          this.value,
          style: TextStyle(color: Colors.black),
        ),
      ],
    );
  }
}