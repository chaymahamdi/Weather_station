import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:project_cert/Network_front_back/api.dart';
import 'package:project_cert/pages/addStation.dart';
import 'package:project_cert/pages/home.dart';
import 'package:project_cert/pages/login.dart';
import 'package:project_cert/pages/profile.dart';
import 'package:project_cert/pages/station.dart';
import 'package:project_cert/pages/stations.dart';

import '../Widgets/widgets.dart';

enum Menu { itemOne, itemTwo, itemThree, itemFour }

class WeatherData extends StatefulWidget {
  const WeatherData({Key? key}) : super(key: key);

  @override
  State<WeatherData> createState() => _WeatherDataState();
}

class _WeatherDataState extends State<WeatherData> {
  String _selectedMenu = '';

  int _selectedIndex = 0;
  var temperature = [];
  var pressure = [];
  var humidity = [];
  var precipitations = [];
  var luminosity = [];
  void initState() {
    _initTemperature();
    _initHumidity();
    _initPressure();
    _initLuminosity();
  }

  /*var datatime = {
    'start': DateTime.now().toUtc().millisecondsSinceEpoch * 1000000 -
        30 * 24 * 3600,
    'stop': DateTime.now().toUtc().millisecondsSinceEpoch * 1000000,
  };*/
  var datatime = {
    'start': 1670852581858072064,
    'stop': 1673442526905303040,
  };

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

  _initTemperature() async {
    await CallApi()
        .postData(datatime, "influxdb/get/temperature")
        .then((response) {
      setState(() {
        var data = Map.from(json.decode(response.body)["data"]);
        if (data.isEmpty != true) {
          temperature = List.from(data.values);
        }
        /*print("temperature");
        print(temperature);*/
      });
    });
  }

  _initHumidity() async {
    await CallApi()
        .postData(datatime, "influxdb/get/humidity")
        .then((response) {
      setState(() {
        var data = Map.from(json.decode(response.body)["data"]);
        if (data.isEmpty != true) {
          humidity = List.from(data.values);
        }
        /*print("humidity");
        print(humidity);*/
      });
    });
  }

  _export() async {
    var res = await CallApi().getPublicData('export');
    _showMsg("succes");
  }

  _initLuminosity() async {
    await CallApi()
        .postData(datatime, "influxdb/get/luminosity")
        .then((response) {
      setState(() {
        var data = Map.from(json.decode(response.body)["data"]);
        if (data.isEmpty != true) {
          luminosity = List.from(data.values);
        }
      });
    });
  }

  _initPressure() async {
    await CallApi()
        .postData(datatime, "influxdb/get/pressure")
        .then((response) {
      setState(() {
        var data = Map.from(json.decode(response.body)["data"]);
        if (data.isEmpty != true) {
          pressure = List.from(data.values);
        }
      });
    });
  }
  /*_initData() async {
    var response_1 =
        await CallApi().postData(datatime, "influxdb/get/temperature");
    var response_2 =
        await CallApi().postData(datatime, "influxdb/get/humidity");
    /* var response_3 =
        await CallApi().postData(datatime, "influxdb/get/precipitations");*/
    var response_4 =
        await CallApi().postData(datatime, "influxdb/get/luminosity");
    var response_5 =
        await CallApi().postData(datatime, "influxdb/get/pressure");
    setState(() {
      temperature = List.from(json.decode(response_1.body)["data"].values);
      humidity = List.from(json.decode(response_2.body)["data"].values);
      /*precipitations = List.from(json.decode(response_3.body)["data"].values);*/
      luminosity = List.from(json.decode(response_4.body)["data"].values);
      pressure = List.from(json.decode(response_5.body)["data"].values);
      /*timetemperature = List.from(json.decode(response_5.body)["data"].keys);*/
    });
  }*/

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
                      value: Menu.itemOne,
                      child: const Text('Log out'),
                      onTap: () {
                        _logout();
                      },
                    ),
                  ]),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/back.png'), fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.indigo.shade700, //<-- SEE HERE
              ),
              onPressed: () {
                _export();
              },
              child: Container(
                child: const Text(
                  'Export Data',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Column(
              children: data(),
            ),
          ],
        ),
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
            label: 'Stations',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.location_on,
            ),
            label: 'Home',
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
        MaterialPageRoute(builder: (context) => const Home()),
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
    for (var i = 0;
        i <
            [
                  temperature.length,
                  humidity.length,
                  luminosity.length,
                  pressure.length
                ].reduce(min) /
                30;
        i++) {
      list.add(Card(
        elevation: 4,
        child: IntrinsicHeight(
          child: Row(
            children: [
              Column(
                children: [
                  const Text(
                    "Temperature",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    (temperature[i] == -1) ? '' : temperature[i].toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple.shade900),
                  )
                ],
              ),
              const VerticalDivider(
                color: Colors.indigo,
                thickness: 2,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.15,
                child: Column(
                  children: [
                    const Text(
                      "Pressure",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      (pressure[i] == -1) ? '' : pressure[i].toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple.shade800),
                    )
                  ],
                ),
              ),
              VerticalDivider(
                color: Colors.indigo,
                thickness: 2,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.15,
                child: Column(
                  children: [
                    const Text(
                      "Humidity",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      (humidity[i] == -1) ? '' : humidity[i].toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple.shade700),
                    )
                  ],
                ),
              ),
              VerticalDivider(
                color: Colors.indigo,
                thickness: 2,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.15,
                child: Column(
                  children: [
                    const Text(
                      "Luminosity",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      (luminosity[i] == -1) ? '' : luminosity[i].toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple.shade500),
                    )
                  ],
                ),
              ),
              VerticalDivider(
                color: Colors.indigo,
                thickness: 2,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.15,
                child: Column(
                  children: [
                    const Text(
                      "Precipiations",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      '',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ));
    }
    return list; // all widget added now retrun the list here
  }
}
