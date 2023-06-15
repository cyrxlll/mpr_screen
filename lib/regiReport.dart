import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_android/path_provider_android.dart';
import 'package:open_file/open_file.dart';
import 'sidebar.dart';

class RegiReport extends StatefulWidget {
  @override
  _PdfScreenState createState() => _PdfScreenState();
}

class _PdfScreenState extends State<RegiReport> {
  DateTime? startDate;
  DateTime? endDate;
  List<dynamic> hospitals = [];
  String? selectedHospital;

  @override
  void initState() {
    super.initState();
    fetchHospitals();
  }

  Future<void> fetchHospitals() async {
    try {
      final response = await http.get(Uri.parse('http://sofia.onedoc.ph:8000/api/hospitals'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          hospitals = data['hospitals'];
        });
      } else {
        print('Failed to fetch hospitals. Error: ${response.reasonPhrase}');
      }
    } catch (error) {
      print('Failed to connect to the API. Error: $error');
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != endDate) {
      setState(() {
        endDate = picked;
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date != null) {
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }
    return '';
  }

  Future<void> _downloadPdf() async {
    if (startDate == null || endDate == null || selectedHospital == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select start date, end date, and hospital.'),
        ),
      );
      return;
    }

    final formattedStartDate = _formatDate(startDate);
    final formattedEndDate = _formatDate(endDate);

    final url =
        'http://sofia.onedoc.ph:8000/api/registration?selectedhos=$selectedHospital&end=$formattedEndDate&start=$formattedStartDate';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final directories = await getExternalStorageDirectories();
      final dir = directories!.first;
      final file = File(
          '${dir.path}/registration_report_$formattedStartDate _to_$formattedEndDate _of_$selectedHospital.pdf');
      await file.writeAsBytes(response.bodyBytes);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF downloaded successfully.'),
        ),
      );

      await OpenFile.open(file.path); // Open the downloaded PDF
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to download PDF.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registration Report'),
        backgroundColor: Color.fromRGBO(72, 109, 218, 1),
      ),
      drawer: Sidebar(
        selectedItem: 'Registration Report',
        onItemSelected: (item) {
          // Update the selected item
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              GestureDetector(
                onTap: () => _selectStartDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Start Date',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    controller: TextEditingController(
                      text: _formatDate(startDate),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: () => _selectEndDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      labelText: 'End Date',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    controller: TextEditingController(
                      text: _formatDate(endDate),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30.0),
              Center(
                child: Container(
                  child: DropdownButton<String>(
                    value: selectedHospital,
                    hint: SizedBox(
                      width: 350,
                      child: Row(
                        children: [ // Add the dropdown icon
                          Text('Select a hospital'),
                        ],
                      ),
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedHospital = newValue;
                      });
                    },
                    items: hospitals.map<DropdownMenuItem<String>>((hospital) {
                      final hospitalName = hospital['hospitalName'];
                      return DropdownMenuItem<String>(
                        value: hospitalName,
                        child: Text(hospitalName),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => _downloadPdf(),
                child: Text('View PDF'),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Color.fromRGBO(72, 109, 218, 1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}