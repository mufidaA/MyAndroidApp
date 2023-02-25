import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class ChartScreen extends StatefulWidget {
  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  List<ChartData> _chartData = [];

  @override
  void initState() {
    super.initState();
    _loadChartData();
  }

  Future<void> _loadChartData() async {
    final chartData = await fetchPropertyConsumption();
    setState(() {
      _chartData = chartData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _chartData.isEmpty
            ? CircularProgressIndicator()
            : SfCartesianChart(
                primaryXAxis: DateTimeAxis(),
                series: <LineSeries<ChartData, DateTime>>[
                  LineSeries<ChartData, DateTime>(
                    dataSource: _chartData,
                    xValueMapper: (ChartData data, _) => data.dateTime,
                    yValueMapper: (ChartData data, _) =>
                        data.consumptionInKWh,
                  ),
                ],
              ),
      ),
    );
  }
}

class ChartData {
  final double consumptionInKWh;
  final String startingHour;
  final DateTime dateTime;

  ChartData({
    required this.consumptionInKWh,
    required this.startingHour,
    required this.dateTime,
  });
}

Future<List<ChartData>> fetchPropertyConsumption() async {
  final response = await http.get(Uri.parse(
      'https://api.ouka.fi/v1/properties_consumption_hourly?property_id=eq.629101&year=eq.2019&month=eq.12&consumption_measure=eq.S%C3%A4hk%C3%B6&order=day.asc,starting_hour.asc&limit=744'));

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    final List<ChartData> chartDataList = jsonList.map((json) {
      final double consumption = json['consumption'];
      final String startingHour = json['starting_hour'];
      final DateTime dateTime = DateTime(json['year'], json['month'],
          json['day'], int.parse(json['starting_hour']));
      return ChartData(
          consumptionInKWh: consumption / 1000,
          startingHour: startingHour,
          dateTime: dateTime);
    }).toList();
    return chartDataList;
  } else {
    throw Exception('Failed to load property consumption data');
  }
}