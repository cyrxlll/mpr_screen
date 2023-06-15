import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:mpr_screen/home_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class PatientRegi extends StatefulWidget {
  @override
  _PatientRegiState createState() => _PatientRegiState();
}

class _PatientRegiState extends State<PatientRegi> {
  List<MonthData> monthDataList = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('http://sofia.onedoc.ph:8000/api/dashboard/registration'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      data['patientRegistration']['All Hospitals'].forEach((month, count) {
        monthDataList.add(MonthData(month, int.parse(count)));
      });

      setState(() {}); // Update the UI with the fetched data
    } else {
      // Handle API error
      print('API request failed with status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(72, 109, 218, 1),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
        title: Text('Patient Registration'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 10.0),
            Text(
              'Patient Registration',
              style: TextStyle(
                  color: Color.fromRGBO(72, 109, 218, 1),
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: 500.0,
                      child: monthDataList.isNotEmpty
                          ? BarChart(seriesList: _createSampleData())
                          : Container(), // Empty container when data is not available
                    ),
                    Visibility(
                      visible: monthDataList.isEmpty, // Show loader only when data is not available
                      child: SizedBox(
                        width: 100, // desired width
                        height: 100, // desired height
                        child: CircularProgressIndicator(
                          strokeWidth: 10, // desired stroke width
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue), // desired color
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }

  List<charts.Series<MonthData, String>> _createSampleData() {
    return [
      charts.Series<MonthData, String>(
        id: 'Patients',
        colorFn: (_, __) => charts.Color.fromHex(code: '#4E73DF'),
        domainFn: (MonthData monthData, _) => monthData.month,
        measureFn: (MonthData monthData, _) => monthData.count,
        data: monthDataList,
      ),
    ];
  }
}

class MonthData {
  final String month;
  final int count;

  MonthData(this.month, this.count);
}

class BarChart extends StatelessWidget {
  final List<charts.Series<MonthData, String>> seriesList;

  BarChart({required this.seriesList});

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: true,
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Patient Registration',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PatientRegi(),
    );
  }
}