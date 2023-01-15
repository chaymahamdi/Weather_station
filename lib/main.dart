// @dart=2.9
import 'package:flutter/material.dart';
import 'package:project_cert/pages/home.dart';
import 'package:project_cert/pages/login.dart';
import 'package:project_cert/pages/profile.dart';
import 'package:project_cert/pages/register.dart';
import 'package:project_cert/pages/station.dart';
import 'package:project_cert/pages/stations.dart';
import 'package:project_cert/pages/welcome.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/welcome',
      routes: {
        '/home': (context) => Home(),
        '/login': (context) => Login(),
        '/stations': (context) => Stations(),
        '/register': (context) => Register(),
        '/welcome': (context) => Welcome(),
        '/profile': (context) => Profile(),
      },
    ));
