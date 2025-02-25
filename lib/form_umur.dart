import 'package:floofy_ml/home_page.dart';
import 'package:flutter/material.dart';
import 'form_bmi.dart';
import 'database_helper.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

int? tahunAwal;

class FormUmurPage extends StatefulWidget {
  @override
  _FormUmurPageState createState() => _FormUmurPageState();
}

class _FormUmurPageState extends State<FormUmurPage> {
  // int? selectedYear;
  final List<int> years = List.generate(
    2025 - 1945 + 1,
    (index) => 1945 + index,
  );
  int selectedYear = 2005; // Default tahun yang ditampilkan

  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData(); // Muat data setelah halaman selesai dibangun
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData(); // Muat data setiap kali halaman dibuka
  }

  void _loadData() async {
    final data = await _dbHelper.getSessionData(currSessionId);
    if (data != null && data['yob'] != null && data['yob'] != 0) {
      setState(() {
        selectedYear = data['yob'];
        tahunAwal = selectedYear;
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
                    value: 0.2, // Progress sepertiga (1/3)
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

      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40),
          Text(
            "Tahun berapa Anda lahir?",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: Color(0xFFE57373),
            ),
          ),
          SizedBox(height: 8),
          SizedBox(
            width: 270,
            child: Text(
              "Prediksi siklus akan lebih akurat bila aplikasi Floofy tahu usia Anda",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.black),
            ),
          ),

          SizedBox(height: 100),
          SizedBox(
            height: 200, // Ukuran wheel
            child: ListWheelScrollView.useDelegate(
              itemExtent: 50, // Jarak antar item
              physics: FixedExtentScrollPhysics(),
              perspective: 0.003, // Efek 3D
              diameterRatio: 1.5, // Mengontrol lengkungan
              controller: FixedExtentScrollController(
                initialItem: (tahunAwal ?? 2005) - 1945,
              ), // Mulai dari tahun 2005
              onSelectedItemChanged: (index) {
                setState(() {
                  selectedYear = years[index];
                  tahunAwal = selectedYear;
                });
              },
              childDelegate: ListWheelChildBuilderDelegate(
                builder: (context, index) {
                  var isSelected = years[index] == tahunAwal;
                  if (tahunAwal == null) {
                    isSelected = years[index] == 2005;
                  } else {
                    isSelected = years[index] == tahunAwal;
                  }

                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      if (isSelected)
                        Container(
                          width: 200,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.red.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      Text(
                        years[index].toString(),
                        style: TextStyle(
                          fontSize: isSelected ? 24 : 18,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color:
                              isSelected ? Colors.black : Colors.grey.shade400,
                        ),
                      ),
                    ],
                  );
                },
                childCount: years.length,
              ),
            ),
          ),
          SizedBox(height: 70),
          ElevatedButton(
            onPressed: () {
              _dbHelper.updateUserData(currSessionId, {'age': selectedYear});
              _dbHelper.getSessionData(currSessionId).then((res) {
                print(res);
              });
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FormBmiPage()),
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
    );
  }
}
