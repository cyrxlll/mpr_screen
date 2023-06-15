import 'package:flutter/material.dart';
import 'package:mpr_screen/Visits.dart';
import 'package:mpr_screen/pricePoints.dart';
import 'package:mpr_screen/patientRegi.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'lineChart.dart';
import 'sidebar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int totalVisits = 0;
  int totalRegistrations = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('http://sofia.onedoc.ph:8000/api/dashboard'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      totalRegistrations = data['totalRegistrations'];
      totalVisits = data['totalVisits'];

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
        title: const Text('ame || Dashboard'),
        backgroundColor: Color.fromRGBO(72, 109, 218, 1),
      ),
      drawer: Sidebar(
        selectedItem: 'Dashboard',
        onItemSelected: (item) {
          // Update the selected item
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Center(
                  child: Text(
                    "MPR MANAGEMENT SCREEN",
                    style: TextStyle(
                      color: Color.fromRGBO(72, 109, 218, 1),
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: Wrap(
                    spacing: 20.0,
                    runSpacing: 20.0,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.width * 0.4,
                        child: Card(
                          color: Color.fromRGBO(72, 109, 218, 1),
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Choose View'),
                                    content: Column.(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ListTile(
                                          leading: Icon(Icons.insert_chart),
                                          title: Text('Chart View'),
                                          onTap: () {
                                            Navigator.pop(context);
                                            // TODO: Navigate to the Chart view
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.table_chart),
                                          title: Text('Table View'),
                                          onTap: () {
                                            Navigator.pop(context);
                                            // TODO: Navigate to the Table view
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                            splashColor: Colors.blueGrey,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    SizedBox(height: 30.0),
                                    Image.asset(
                                      "images/medical.png",
                                      width: MediaQuery.of(context).size.width *
                                          0.12,
                                    ),
                                    SizedBox(height: 10.0),
                                    Text(
                                      "Registration",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    SizedBox(height: 5.0),
                                    Text(
                                      "$totalRegistrations Total Visits",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.width * 0.4,
                        child: Card(
                          elevation: 2.0,
                          color: Color.fromRGBO(1, 161, 131, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyApp1()),
                              );
                            },
                            splashColor: Colors.blueGrey,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    SizedBox(height: 30.0),
                                    Image.asset(
                                      "images/hand.png",
                                      width: MediaQuery.of(context).size.width *
                                          0.12,
                                    ),
                                    SizedBox(height: 10.0),
                                    Text(
                                      "Visits",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                      ),
                                    ),
                                    SizedBox(height: 5.0),
                                    Text(
                                      "$totalVisits Total Visits",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: 480.0,
                        child: InkWell(
                          onTap: () {},
                          splashColor: Colors.blueGrey,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  LineChartWidget(pricePoints),
                                  SizedBox(height: 10.0),
                                  Text(
                                    "Registration-Visits Utilization (YTD)",
                                    style: TextStyle(
                                      color: Color.fromRGBO(72, 109, 218, 1),
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
