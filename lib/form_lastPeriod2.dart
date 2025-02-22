import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
import 'form_lastPeriod3.dart';
import 'database_helper.dart';

class FormLastPeriod2Page extends StatefulWidget {
  @override
  _FormLastPeriod2PageState createState() => _FormLastPeriod2PageState();
}

class _FormLastPeriod2PageState extends State<FormLastPeriod2Page> {
  int? _menyusuiValue; // 1 untuk Iya, 0 untuk Tidak
  int? _kehamilanValue;

  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final data = await _dbHelper.getLastSessionData();
    if (data != null) {
      setState(() {
        _menyusuiValue = data['breastFeeding'];
        _kehamilanValue = data['pregnancyNum'];
      });
    }
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
                    value: 0.8, // Progress sepertiga (1/3)
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
              width: 400,
              child: Text(
                "Kondisi Mentruasi Terakhir kamu",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFE57373),
                  height: 1.3,
                ),
              ),
            ),
            SizedBox(height: 8),
            SizedBox(
              width: 270,
              child: Text(
                "Prediksi Floofy akan lebih akurat jika tahu kondisi mentruasi terakhir kamu",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.black),
              ),
            ),

            SizedBox(height: 25),
            SizedBox(
              child: Image.asset('assets/images/formPeriod2.png', height: 120),
            ),

            SizedBox(height: 30),
            SizedBox(
              width: 360,
              child: Text(
                "Apakah Anda sedang menyusui?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE57373),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150, // Set the desired width for the "Iya" button
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _menyusuiValue = 1;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _menyusuiValue == 1
                              ? Color(0xFFE57373)
                              : Color.fromARGB(255, 194, 194, 194),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 12,
                      ),
                    ),
                    child: Text('Iya', style: TextStyle(color: Colors.black)),
                  ),
                ),
                SizedBox(width: 10), // Space between the buttons
                SizedBox(
                  width: 150, // Set the desired width for the "Tidak" button
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _menyusuiValue = 0;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _menyusuiValue == 0
                              ? Color(0xFFE57373)
                              : Color.fromARGB(255, 194, 194, 194),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 12,
                      ),
                    ),
                    child: Text('Tidak', style: TextStyle(color: Colors.black)),
                  ),
                ),
              ],
            ),

            SizedBox(height: 30),
            SizedBox(
              width: 360,
              child: Text(
                "Berapa kali anda melakukan hubungan seksual pada menstruasi sebelumnya",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE57373),
                ),
              ),
            ),

            SizedBox(height: 10),

            SizedBox(
              width: 200,
              child: TextField(
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    _kehamilanValue = int.tryParse(value);
                  });
                },
                decoration: InputDecoration(
                  hintText: "... kali",
                  hintStyle: TextStyle(
                    // Tambahkan ini untuk membuat hintText bold
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                  ),
                  filled: true,
                  fillColor: Color(0xFFE57373).withOpacity(0.3),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 5,
                  ),
                ),
              ),
            ),

            SizedBox(height: 60),
            ElevatedButton(
              onPressed: () {
                _dbHelper.insertUserData({
                  'breastFeeding': _menyusuiValue,
                  'pregnancyNum': _kehamilanValue,
                });
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FormLastPeriod3Page(),
                  ),
                );
              },
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
