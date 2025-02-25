import 'package:floofy_ml/home_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'database_helper.dart';
import 'main_page.dart';

class FormLastPeriod3Page extends StatefulWidget {
  @override
  _FormLastPeriod3PageState createState() => _FormLastPeriod3PageState();
}

class _FormLastPeriod3PageState extends State<FormLastPeriod3Page> {
  int? _lengthOfCycleValue;
  DateTime? _lastPeriodDateValue;
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final TextEditingController _lCycle = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData(); // Muat data setelah halaman selesai dibangun
    });
  }

  @override
  void dispose() {
    _lCycle.dispose(); // Clean up the controller
    super.dispose();
  }

  void _loadData() async {
    final data = await _dbHelper.getSessionData(currSessionId);
    if (data != null) {
      setState(() {
        _lengthOfCycleValue = data['lengthOfCycle'];
        _lastPeriodDateValue =
            data['lastPeriodDate'] != null
                ? DateTime.parse(
                  data['lastPeriodDate'],
                ) // Convert string to DateTime
                : null;

        if (_lengthOfCycleValue != 0) {
          _lCycle.text = _lengthOfCycleValue.toString();
        }
      });
    }
  }

  Future<void> _pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _lastPeriodDateValue ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _lastPeriodDateValue = pickedDate;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData(); // Muat data setiap kali halaman dibuka
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Color(0xFFFFE5E5),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
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
              SizedBox(width: 20),
              SizedBox(
                width: 250,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: 1,
                    backgroundColor: Colors.grey.shade400,
                    color: Color(0xFF65000B),
                    minHeight: 3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Center(
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
                child: Image.asset(
                  'assets/images/formPeriod3.png',
                  height: 160,
                ),
              ),

              SizedBox(height: 30),

              SizedBox(
                width: 350,
                child: Text(
                  "Berapa Lama Siklus Menstruasi Terakhir Anda",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE57373),
                  ),
                ),
              ),

              SizedBox(height: 15),

              SizedBox(
                width: 150,
                child: TextField(
                  controller: _lCycle,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      _lengthOfCycleValue = int.tryParse(value);
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "... hari",
                    hintStyle: TextStyle(
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

              SizedBox(height: 20),
              SizedBox(
                width: 350,
                child: Text(
                  "Kapan tanggal haid pertama Anda terakhir kali",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFE57373),
                  ),
                ),
              ),
              SizedBox(height: 5),

              // 📌 Date Picker Form
              GestureDetector(
                onTap: () => _pickDate(context),
                child: Container(
                  margin: EdgeInsets.only(top: 10, bottom: 20),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 45),
                  decoration: BoxDecoration(
                    color: Color(0xFFE57373).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(
                    _lastPeriodDateValue == null
                        ? "... pilih tanggal"
                        : DateFormat('dd MMM yy').format(_lastPeriodDateValue!),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _dbHelper.updateUserData(currSessionId, {
                    'lengthOfCycle': _lengthOfCycleValue,
                    'lastPeriodDate':
                        _lastPeriodDateValue
                            ?.toIso8601String(), // Save as string
                  });

                  _dbHelper.getSessionData(currSessionId).then((res) {
                    print(res);
                  });

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MainScreen()),
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
                  "Prediksi",
                  style: TextStyle(color: Color(0xFFE57373)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
