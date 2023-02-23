import 'dart:convert';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;

class PropertyConsumption {
  final String propertyId;
  final String propertyInternalId;
  final String propertyName;
  final String consumptionMeasure;
  final int year;
  final int month;
  final int day;
  final String startingHour;
  final double consumption;

  PropertyConsumption({
    required this.propertyId,
    required this.propertyInternalId,
    required this.propertyName,
    required this.consumptionMeasure,
    required this.year,
    required this.month,
    required this.day,
    required this.startingHour,
    required this.consumption,
  });

  factory PropertyConsumption.fromJson(Map<String, dynamic> json) {
    return PropertyConsumption(
      propertyId: json['property_id'],
      propertyInternalId: json['property_internal_id'],
      propertyName: json['property_name'],
      consumptionMeasure: json['consumption_measure'],
      year: json['year'],
      month: json['month'],
      day: json['day'],
      startingHour: json['starting_hour'],
      consumption: json['consumption'],
    );
  }
}

Future<List<ChartData>> fetchPropertyConsumption() async {
  final response = await http.get(Uri.parse('https://api.ouka.fi/v1/properties_consumption_hourly?property_id=eq.629101&year=eq.2019&month=eq.12&consumption_measure=eq.S%C3%A4hk%C3%B6&order=day.asc,starting_hour.asc&limit=744'));

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = jsonDecode(response.body);
    final List<ChartData> chartDataList = jsonList.map((json) {
      final double consumption = json['consumption'];
      final String startingHour = json['starting_hour'];
      final DateTime dateTime = DateTime(json['year'], json['month'], json['day'], int.parse(json['starting_hour']));
      return ChartData(consumptionInKWh: consumption/1000, startingHour: startingHour, dateTime: dateTime);
    }).toList();
    return chartDataList;
  } else {
    throw Exception('Failed to load property consumption data');
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
  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: FutureBuilder<List<ChartData>>(
      future: fetchPropertyConsumption(),
      builder: (BuildContext context, AsyncSnapshot<List<ChartData>> snapshot) {
        if (snapshot.hasData) {
          return SfCartesianChart(
            primaryXAxis: DateTimeAxis(),
            series: <LineSeries<ChartData, DateTime>>[
              LineSeries<ChartData, DateTime>(
                dataSource: snapshot.data!,
                xValueMapper: (ChartData data, _) => data.dateTime,
                yValueMapper: (ChartData data, _) => data.consumptionInKWh,
              )
            ]
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      }
    )
  );
}
}


