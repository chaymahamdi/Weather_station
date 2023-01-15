import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:project_cert/Network_front_back/api.dart';
import 'package:project_cert/pages/addStation.dart';
import 'package:project_cert/pages/login.dart';
import 'package:project_cert/pages/profile.dart';
import 'package:project_cert/pages/station.dart';

import '../Widgets/widgets.dart';

enum Menu { itemOne, itemTwo, itemThree, itemFour }

class Stations extends StatefulWidget {
  const Stations({Key? key}) : super(key: key);

  @override
  State<Stations> createState() => _StationsState();
}

class _StationsState extends State<Stations> {
  String _selectedMenu = '';
  var stations = [];
  int _selectedIndex = 0;
  var Favorites = [];
  void initState() {
    _initFavorites();
    _initData();
  }

  _initData() async {
    var res = await CallApi().getData("stations");
    setState(() {
      stations = List.from(json.decode(res.body)["data"]);
    });
  }

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

  _DeleteStation(id) async {
    var data = {
      'id': id,
    };

    var res = await CallApi().postTokenData(data, 'stations/delete');
    var body = json.decode(res.body);
    if (body['success']) {
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => Stations()));
    } else {
      _showMsg(body['message']);
    }
  }

  _initFavorites() async {
    var response = await CallApi().getData("favorites");
    setState(() {
      Favorites = List.from(json.decode(response.body)["data"]);
      print(Favorites);
    });
  }

  _logout() async {
    await CallApi().getData('logout');
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => Login()));
  }

  _addFavorite(id) async {
    var data = {
      'id': id,
    };
    var response = await CallApi().postTokenData(data, 'user/addFavorite');
    setState(() {
      _initData();
    });
  }

  bool isSwitched = false;
  var textValue = 'Switch is OFF';
  void toggleSwitch(bool value) {
    if (isSwitched == false) {
      setState(() {
        isSwitched = true;
      });
      print('ON');
    } else {
      setState(() {
        isSwitched = false;
      });
      print('OFF');
    }
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
                      value: Menu.itemOne,
                      child: Text('Log out'),
                      onTap: () {
                        _logout();
                      },
                    ),
                  ]),
        ],
      ),
      body: Column(
        children: [
          Column(
            children: data(),
          ),
          SizedBox(
            height: 50,
          ),
          button(
              val: 'Add Station',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddStation()),
                );
              }),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.purple[900],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.6),
        selectedFontSize: 14,
        unselectedFontSize: 14,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.location_on,
            ),
            label: 'Stations',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Stations()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Stations()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Profile()),
      );
    }
  }

  List<Widget> data() {
    List<Widget> list = [];
    for (var station in stations) {
      list.add(Container(
          height: 80,
          width: double.maxFinite,
          child: Card(
            elevation: 5,
            child: Row(
              children: [
                const SizedBox(
                  width: 20,
                ),
                NameStation(station),
                const SizedBox(
                  width: 60,
                ),
                ON_OFF(station["state"] == 1),
                const SizedBox(
                  width: 10,
                ),
                StarButton(
                  isStarred: (Favorites.contains(station["id"])),
                  // iconDisabledColor: Colors.white,
                  valueChanged: (_isStarred) {
                    _addFavorite(station["id"]);
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  iconSize: 24.0,
                  color: Colors.red,
                  onPressed: () {
                    _DeleteStation(station["id"]);
                  },
                ),
              ],
            ),
          )));

      print(station["name"]);
    }
    return list; // all widget added now retrun the list here
  }

  Widget NameStation(station) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          TextButton(
              child: Text(
                station["name"],
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 20),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Station(name: station["name"])),
                );
              }),
          RichText(
            text: TextSpan(
                text: station["location"],
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget ON_OFF(isSwitched) {
    return Align(
      alignment: Alignment.topRight,
      child: Container(
          width: 40,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.9,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Transform.scale(
                  scale: 1,
                  child: Switch(
                    onChanged: toggleSwitch,
                    value: isSwitched,
                    activeColor: Colors.blue,
                    activeTrackColor: Colors.lightBlue,
                    inactiveThumbColor: Colors.redAccent,
                    inactiveTrackColor: Colors.red,
                  )),
            ]),
          )),
    );
  }
}
