import 'package:flutter/material.dart';
import 'form_lastPeriod.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
import 'database_helper.dart';

class FormBmiPage extends StatefulWidget {
  @override
  _FormBmiPageState createState() => _FormBmiPageState();
}

class _FormBmiPageState extends State<FormBmiPage> {
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  String weight = ""; // Default text
  String height = "";
  double bmi = 0.0;

  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadData();
    weightController.addListener(() {
      setState(() {
        weight = weightController.text;
      });
    });

    heightController.addListener(() {
      setState(() {
        weight = weightController.text;
      });
    });
  }

  void _loadData() async {
    final data = await _dbHelper.getLastSessionData();
    if (data != null) {
      setState(() {
        weightController.text =
            data['bmi'] != null ? data['bmi'].toString() : '';
        heightController.text =
            data['height'] != null ? data['height'].toString() : '';
      });
    }
  }

  @override
  void dispose() {
    weightController.dispose();
    heightController.dispose();
    super.dispose();
  }

  void _calculateBmi() {
    double weight = double.parse(weightController.text);
    double height = double.parse(heightController.text) / 100;
    bmi = weight / (height * height);

    _saveData();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FormLastPeriodPage()),
    );
  }

  void _saveData() async {
    await _dbHelper.insertUserData({'bmi': bmi});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFE5E5),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60), // Tinggikan agar tidak overflow
        child: AppBar(
          backgroundColor: Color(0xFFFFE5E5),
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Color(0xFF65000B)),
            onPressed: () => Navigator.pop(context),
          ),
          title: Row(
            children: [
              SizedBox(width: 20), // Jarak dari panah
              SizedBox(
                width:
                    250, // Batasi lebar progress bar (sesuaikan sesuai kebutuhan)
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10), // Buat rounded
                  child: LinearProgressIndicator(
                    value: 0.4, // Progress sepertiga (1/3)
                    backgroundColor: Colors.grey.shade400,
                    color: Color(0xFF65000B),
                    minHeight: 3, // Ketebalan progress bar
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            SizedBox(
              width: 300,
              child: Text(
                "Yuk Bantu Floofy Kenal kamu lebih jauh",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFE57373),
                  height: 1.3,
                ),
              ),
            ),

            SizedBox(height: 15),
            SizedBox(
              child: Image.asset('assets/images/formbmi.png', height: 130),
            ),

            SizedBox(height: 20),
            Text(
              "Berapa Berat Badan Anda?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE57373),
              ),
            ),
            SizedBox(height: 10),

            SizedBox(
              width: 300,
              child: TextField(
                controller: weightController,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Masukkan berat badan (kg)",
                  hintStyle: TextStyle(
                    // Tambahkan ini untuk membuat hintText bold
                    fontSize: 17,
                    fontWeight: FontWeight.normal,
                  ),
                  filled: true,
                  fillColor: Color(0xFFE57373).withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),
            Text(
              "Berapa Tinggi Badan Anda?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE57373),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: 300,
              child: TextField(
                controller: heightController,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Masukkan tinggi badan (cm)",
                  hintStyle: TextStyle(
                    // Tambahkan ini untuk membuat hintText bold
                    fontSize: 17,
                    fontWeight: FontWeight.normal,
                  ),
                  filled: true,
                  fillColor: Color(0xFFE57373).withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  ),
                ),
              ),
            ),

            SizedBox(height: 70),
            ElevatedButton(
              onPressed: _calculateBmi,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 12),
              ),
              child: Text(
                "Berikutnya",
                style: TextStyle(color: Color(0xFFE57373)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
