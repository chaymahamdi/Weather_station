import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:project_cert/functions/search_station.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:project_cert/Network_front_back/api.dart';
import 'package:project_cert/pages/profile.dart';
import 'package:project_cert/pages/station.dart';
import 'package:project_cert/pages/stations.dart';
import 'package:project_cert/pages/login.dart';

enum Menu { itemOne, itemTwo, itemThree, itemFour }

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _selectedMenu = '';
  var stations = [];
  String value = "";
  int _selectedIndex = 0;
  List<LatLng> points = [];
  TextEditingController _searchController = TextEditingController();
  void initState() {
    _initData();
  }

  _logout() async {
    await CallApi().getData('logout');
    Navigator.push(
        context, new MaterialPageRoute(builder: (context) => Login()));
  }

  _initData() async {
    var res = await CallApi().getData("stations");
    setState(() {
      stations = List.from(json.decode(res.body)["data"]);

      for (var station in stations) {
        LatLng point = LatLng(double.parse(station["latitude"]),
            double.parse(station["longitude"]));
        points.add(point);
      }
    });
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
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: TextFormField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: value,
                ),
                onChanged: (value) {
                  print(value);
                },
              )),
              IconButton(
                onPressed: () {
                  LocationService().getPlaceId(_searchController.text);
                },
                icon: const Icon(Icons.search),
              )
            ],
          ),
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(36.8917497, 10.1874518),
                zoom: 15,
              ),
              nonRotatedChildren: [
                AttributionWidget.defaultWidget(
                  source: 'Weather Stations',
                  onSourceTapped: null,
                ),
              ],
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(
                  markers: points
                      .map(
                        (e) => Marker(
                          point: e,
                          width: 80,
                          height: 30,
                          builder: (context) => Container(
                              color: Colors.white,
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                  ),
                                  SizedBox(
                                    width: 2,
                                  ),
                                  Text("Station1"),
                                ],
                              )),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.purple[900],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(.60),
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
}
