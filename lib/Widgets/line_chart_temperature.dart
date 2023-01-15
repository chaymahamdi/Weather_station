import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TemperatureChart extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  TemperatureChart({Key? key}) : super(key: key);

  @override
  TemperatureChartState createState() => TemperatureChartState();
}

class TemperatureChartState extends State<TemperatureChart> {
  final List<ChartData> chartData = [
    ChartData('11:00', 27),
    ChartData('11:15', 30),
    ChartData('11:30', 35),
    ChartData('12:00', 29),
    ChartData('12:15', 35),
    ChartData('12:30', 35),
    ChartData('13:00', 29),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SfCartesianChart(
            primaryYAxis: NumericAxis(
              minimum: 0,
              maximum: 50,
              interval: 20,
              labelFormat: '{value}°',
            ),
            primaryXAxis: CategoryAxis(),
            title: ChartTitle(text: 'Temperature Chart'),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <ChartSeries>[
          StackedLineSeries<ChartData, String>(
              dataSource: chartData,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              markerSettings: MarkerSettings(isVisible: true),
              dataLabelSettings: DataLabelSettings(isVisible: true)),
        ]));
  }
}

class ChartData {
  ChartData(this.x, this.y);

  final String x;
  final double y;
}
