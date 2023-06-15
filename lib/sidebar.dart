import 'package:flutter/material.dart';
import 'package:mpr_screen/dischargeReport.dart';
import 'package:mpr_screen/home_screen.dart';
import 'package:mpr_screen/login_screen.dart';
import 'package:mpr_screen/morbidityReport.dart';
import 'package:mpr_screen/mortalityReport.dart';
import 'package:mpr_screen/patientReport.dart';
import 'package:mpr_screen/regiReport.dart';
import 'package:mpr_screen/visitReport.dart';

class Sidebar extends StatelessWidget {
  final String selectedItem;
  final Function(String) onItemSelected;

  const Sidebar({
    Key? key,
    required this.selectedItem,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromRGBO(72, 109, 218, 1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(
                  image: AssetImage('images/panga.png'),
                  width: 140,
                  height: 140,
                ),
                SizedBox(height: 50),
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 15),
                      child: Text(
                        'CareTeQ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Dashboard'),
            selected: selectedItem == 'Dashboard',
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
          ),
          ExpansionTile(
            leading: Icon(Icons.description),
            title: Text('Reports'),
            trailing: Icon(Icons.expand_more),
            initiallyExpanded: selectedItem == 'Reports',
            children: [
              ListTile(
                title: Container(
                  margin: EdgeInsets.only(left: 55),
                  child: Text(
                    'Patient Report',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                selected: selectedItem == 'Patient Report',
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => PatientReport()),
                  );
                },
              ),
              ListTile(
                title: Container(
                  margin: EdgeInsets.only(left: 55),
                  child: Text(
                    'Discharge Report',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                selected: selectedItem == 'Discharge Report',
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => DischargeReport()),
                  );
                },
              ),
              ListTile(
                title: Container(
                  margin: EdgeInsets.only(left: 55),
                  child: Text(
                    'Registration Report',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                selected: selectedItem == 'Registration Report',
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => RegiReport()),
                  );
                },
              ),
              ListTile(
                title: Container(
                  margin: EdgeInsets.only(left: 55),
                  child: Text(
                    'Visit Report',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                selected: selectedItem == 'Visit Report',
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => VisitReport()),
                  );
                },
              ),
              ListTile(
                title: Container(
                  margin: EdgeInsets.only(left: 55),
                  child: Text(
                    'Morbidity Report',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                selected: selectedItem == 'Morbidity Report',
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MorbidityReport()),
                  );
                },
              ),
              ListTile(
                title: Container(
                  margin: EdgeInsets.only(left: 55),
                  child: Text(
                    'Mortality Report',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
                selected: selectedItem == 'Mortality Report',
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MortalityReport()),
                  );
                },
              ),
            ],
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
