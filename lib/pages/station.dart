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

class Station extends StatefulWidget {
  const Station({Key? key, required this.name}) : super(key: key);
  final String name;
  @override
  _StationState createState() => _StationState();
}

class _StationState extends State<Station> {
  String _selectedMenu = '';
  double temperature = -1;
  double humidity = -1;
  double pressure = -1;
  int precipitations = -1;
  int luminosity = -1;
  int counter = 0;
  var temperatureMonthly = [];
  var timetemperature = [];
  List<String> labels = ["Daily", "Weekly", "Monthly"];
  String currentdate = DateFormat.yMMMEd().format(DateTime.now());
  var data = {
    'latest': true,
  };
  List<ChartData> chartDataMonthly = [];
  List<ChartData> chartDataDaily = [];
  List<ChartData> chartDataWeekly = [];
  String valeur = "data";

  var dataMonthly = {
    'start':
        DateTime.now().toUtc().millisecondsSinceEpoch * 1000000 - 9 * 24 * 3600,
    'stop': DateTime.now().toUtc().millisecondsSinceEpoch * 1000000,
  };
  void initState() {
    _initTemperature();

    _initPressure();
    _initHumidity();
    _initLuminosity();
    _initTemperatureMonthly();
  }

  _initTemperature() async {
    var response_1 = await CallApi().postData(data, "influxdb/get/temperature");
    setState(() {
      temperature = List.from(json.decode(response_1.body)["data"].values)[0];
    });
  }

  _initPressure() async {
    var response_3 = await CallApi().postData(data, "influxdb/get/pressure");
    setState(() {
      pressure = List.from(json.decode(response_3.body)["data"].values)[0];
    });
  }

  /*_initPrecipitations() async {
    var response_5 =
        await CallApi().postData(data, "influxdb/get/precipitations");
    setState(() {
      precipitations =
          List.from(json.decode(response_5.body)["data"].values)[0];
    });
  }*/
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

  _initHumidity() async {
    var response_2 = await CallApi().postData(data, "influxdb/get/humidity");
    setState(() {
      humidity = List.from(json.decode(response_2.body)["data"].values)[0];
    });
  }

  _initLuminosity() async {
    var response_3 = await CallApi().postData(data, "influxdb/get/luminosity");
    setState(() {
      luminosity = List.from(json.decode(response_3.body)["data"].values)[0];
    });
  }

  _initTemperatureMonthly() async {
    var response_6 =
        await CallApi().postData(dataMonthly, "influxdb/get/temperature");
    setState(() {
      temperatureMonthly =
          List.from(json.decode(response_6.body)["data"].values);
      timetemperature = List.from(json.decode(response_6.body)["data"].keys);
      for (var i = 0, j = 0;
          i < timetemperature.length / 10;
          j < temperatureMonthly.length, i++, j++) {
        chartDataMonthly
            .add(ChartData(timetemperature[i], temperatureMonthly[j]));
      }
      for (var i = 0, j = 0;
          i < timetemperature.length / 14;
          j < temperatureMonthly.length / 5, i++, j++) {
        chartDataDaily
            .add(ChartData(timetemperature[i], temperatureMonthly[j]));
      }
      for (var i = 0, j = 0;
          i < timetemperature.length / 12;
          j < temperatureMonthly.length / 10, i++, j++) {
        chartDataWeekly
            .add(ChartData(timetemperature[i], temperatureMonthly[j]));
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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/back.png'), fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              alignment: Alignment.topLeft,
              child: Text(
                '${widget.name}',
                style: TextStyle(fontSize: 20, height: 2),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              alignment: Alignment.topLeft,
              child: Text(
                currentdate,
                style: const TextStyle(
                    fontSize: 14, color: Colors.blueAccent, height: 1.5),
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.03,
                ),
                Image.asset(
                  'assets/50n.png',
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: 70,
                ),
                // ignore: prefer_const_constructors
                VerticalDivider(
                  width: MediaQuery.of(context).size.width * 0.05,
                  thickness: 5,
                  color: Colors.black,
                ),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: (temperature == -1) ? '' : "$temperature C°",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 40,
                        color: Colors.black,
                      )),
                  TextSpan(
                      text: "11:25 AM",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                        color: Colors.black,
                      ))
                ])),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.95,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.01,
                      ),
                      Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.width * 0.15,
                            width: MediaQuery.of(context).size.height * 0.09,
                            margin: EdgeInsets.all(10),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: CustomColors.dividerLine,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Image.asset('assets/windspeed.png'),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15,
                            height: MediaQuery.of(context).size.height * 0.05,
                            child: Text(
                              (pressure == -1) ? '' : "$pressure hPa",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.005,
                      ),
                      Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.width * 0.15,
                            width: MediaQuery.of(context).size.height * 0.09,
                            margin: EdgeInsets.all(10),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: CustomColors.dividerLine,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Image.asset('assets/50d.png'),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15,
                            height: MediaQuery.of(context).size.height * 0.05,
                            child: Text(
                              (luminosity == -1) ? '' : "$luminosity LUX",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.005,
                      ),
                      Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.width * 0.15,
                            width: MediaQuery.of(context).size.height * 0.09,
                            margin: EdgeInsets.all(10),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: CustomColors.dividerLine,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Image.asset('assets/humidity.png'),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15,
                            height: MediaQuery.of(context).size.height * 0.05,
                            child: Text(
                              (humidity == -1) ? '' : "$humidity %",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.005,
                      ),
                      Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.width * 0.15,
                            width: MediaQuery.of(context).size.height * 0.09,
                            margin: EdgeInsets.all(10),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: CustomColors.dividerLine,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Image.asset('assets/11n.png'),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.15,
                            height: MediaQuery.of(context).size.height * 0.05,
                            child: Text(
                              (precipitations == -1)
                                  ? 'mm'
                                  : "$precipitations mm",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.005,
                      ),
                    ],
                  )
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                width: MediaQuery.of(context).size.width * 0.95,
                child: Column(
                  children: [
                    ToggleBar(
                        labels: labels,
                        textColor: Colors.white,
                        selectedTextColor: Colors.grey,
                        backgroundColor: Colors.purple[900],
                        selectedTabColor: Colors.indigo[900],
                        onSelectionUpdated: (index) {
                          setState(() {
                            counter = index;
                          });
                        } // Do something with index
                        ),
                    Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: MediaQuery.of(context).size.height * 0.9,
                        child: showwidget(counter, chartDataMonthly,
                            chartDataDaily, chartDataWeekly)),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

showwidget(counter, chartDataMonthly, chartDataDaily, chartDataWeekly) {
  if (counter == 0) {
    return Container(
        child: SfCartesianChart(
            primaryYAxis: NumericAxis(
              minimum: 0,
              maximum: 50,
              interval: 10,
              labelFormat: '{value}°',
            ),
            primaryXAxis: CategoryAxis(),
            title: ChartTitle(text: 'Temperature Chart'),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <ChartSeries>[
          StackedLineSeries<ChartData, String>(
              dataSource: chartDataDaily,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              markerSettings: MarkerSettings(isVisible: true),
              dataLabelSettings: DataLabelSettings(isVisible: true)),
        ]));
  } else if (counter == 1) {
    return Container(
        child: SfCartesianChart(
            primaryYAxis: NumericAxis(
              minimum: 0,
              maximum: 50,
              interval: 10,
              labelFormat: '{value}°',
            ),
            primaryXAxis: CategoryAxis(),
            title: ChartTitle(text: 'Temperature Chart'),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <ChartSeries>[
          StackedLineSeries<ChartData, String>(
              dataSource: chartDataWeekly,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              markerSettings: MarkerSettings(isVisible: false),
              dataLabelSettings: DataLabelSettings(isVisible: true)),
        ]));
  } else {
    return Container(
        child: SfCartesianChart(
            primaryYAxis: NumericAxis(
              minimum: 0,
              maximum: 50,
              interval: 10,
              labelFormat: '{value}°',
            ),
            primaryXAxis: CategoryAxis(),
            title: ChartTitle(text: 'Temperature Chart'),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <ChartSeries>[
          StackedLineSeries<ChartData, String>(
              dataSource: chartDataMonthly,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              markerSettings: MarkerSettings(isVisible: false),
              dataLabelSettings: DataLabelSettings(isVisible: true)),
        ]));
  }
}

class ChartData {
  ChartData(this.x, this.y);

  final String x;
  final double y;
}
