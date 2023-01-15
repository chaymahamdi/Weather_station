import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:project_cert/pages/home.dart';
import 'package:project_cert/pages/login.dart';
import 'package:project_cert/pages/stations.dart';
import '../Widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_cert/Network_front_back/api.dart';

enum Menu { itemOne, itemTwo, itemThree, itemFour }

class AddStation extends StatefulWidget {
  const AddStation({Key? key}) : super(key: key);

  @override
  AddStationState createState() => AddStationState();
}

class AddStationState extends State<AddStation> {
  bool hidePassword = true;
  TextEditingController nameController = TextEditingController();
  TextEditingController locationtextController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();

  _showMsg(msg) {
    //
    final snackBar = SnackBar(
      backgroundColor: Color(0xFF363f93),
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _logout() async {
    await CallApi().getData('logout');
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => Login()));
  }

  String _selectedMenu = '';

  _addStation() async {
    var data = {
      'name': nameController.text,
      'location': locationtextController.text,
      'longitude': longitudeController.text,
      'latitude': latitudeController.text,
    };

    var res = await CallApi().postTokenData(data, 'stations');
    var body = json.decode(res.body);
    if (body['success']) {
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => Stations()));
    } else {
      _showMsg(body['message']);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/back.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
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
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.02,
                bottom: MediaQuery.of(context).size.width * 0.01,
              ),
              child: Column(
                children: [
                  const Text(
                    'Add Station',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 33,
                        fontWeight: FontWeight.bold),
                  ),
                  SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.01),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 35, right: 35),
                            child: Column(
                              children: [
                                TextField(
                                  controller: nameController,
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(Icons
                                          .supervised_user_circle_outlined),
                                      fillColor: Colors.grey.shade100,
                                      filled: true,
                                      hintText: "Name",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextField(
                                  controller: locationtextController,
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.location_city),
                                      fillColor: Colors.grey.shade100,
                                      filled: true,
                                      hintText: "Location",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextField(
                                  controller: longitudeController,
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.location_on),
                                      fillColor: Colors.grey.shade100,
                                      filled: true,
                                      hintText: "Longitude",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                TextField(
                                  controller: latitudeController,
                                  style: TextStyle(color: Colors.black),
                                  decoration: InputDecoration(
                                      prefixIcon:
                                          Icon(Icons.location_on_rounded),
                                      fillColor: Colors.grey.shade100,
                                      filled: true,
                                      hintText: "Latitude",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                button(
                                    val: 'Submit',
                                    onTap: () {
                                      _addStation();
                                    }),
                                const SizedBox(
                                  height: 40,
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
