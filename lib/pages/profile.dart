import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:project_cert/Widgets/colors';
import 'package:project_cert/pages/login.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../Network_front_back/api.dart';
import '../Widgets/parametres_End_node.dart';
import 'package:intl/intl.dart';
import 'package:toggle_bar/toggle_bar.dart';

enum Menu { itemOne, itemTwo, itemThree, itemFour }

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String _selectedMenu = '';
  int counter = 0;
  List<String> labels = ["Daily", "Weekly", "Monthly"];
  Map<String, dynamic> user = {};

  /*List<dynamic> user = [];*/
  void initState() {
    _initData();
  }

  _initData() async {
    var response = await CallApi().getData("user");
    setState(() {
      user = json.decode(response.body)["data"];
    });
  }

  _logout() async {
    await CallApi().getData('logout');
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => Login()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple[900],
          actions: <Widget>[
            // This button presents popup menu items.
            PopupMenuButton<Menu>(
                // Callback that sets the selected popup menu item.
                onSelected: (Menu item) {
                  setState(() {
                    _selectedMenu = item.name;
                  });
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<Menu>>[
                      PopupMenuItem<Menu>(
                        value: Menu.itemThree,
                        child: Text('Log out'),
                        onTap: () {
                          _logout();
                        },
                      ),
                    ]),
          ],
        ),
        body: Container(
          width: MediaQuery.of(context).size.width * 1,
          height: MediaQuery.of(context).size.height * 1,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/back.png'), fit: BoxFit.cover),
          ),
          child: Center(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter, //aligns to topCenter
                  child: Padding(
                    //gives empty space around the CircleAvatar
                    padding: EdgeInsets.all(16.0),
                    child: CircleAvatar(
                      radius: 80, //radius is 35.
                      backgroundImage: AssetImage(
                          'assets/profile.jpg'), //AssetImage loads image URL.
                    ),
                  ),
                ),
                Text(
                  (user["name"] == null) ? '' : user["name"],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const SizedBox(height: 4),
                Text(
                  (user["email"] == null) ? '' : user["email"],
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                )
              ],
            ),
          ),
        ));
  }
}
