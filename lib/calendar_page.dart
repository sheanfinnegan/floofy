import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'predict_page.dart';
import 'package:intl/date_symbol_data_local.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late DateTime _firstDay;
  late DateTime _lastDay;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized(); // Tambahkan ini
    initializeDateFormatting('id_ID', null); // Inisialisasi locale
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    _firstDay = DateTime(_focusedDay.year - 10, 1, 1);
    _lastDay = DateTime(_focusedDay.year + 10, 12, 31);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white, // Background color
        elevation: 0, // Remove shadow
        centerTitle: true, // Center the logo
        title: Image.asset(
          'assets/images/FloofyLogo.png', // Path to your Floofy logo
          height: 200, // Adjust height
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),

          // ** Header Custom dengan Panah Navigasi **
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(
                  Icons.chevron_left,
                  color: Color(0xFFFF800020),
                  size: 30,
                ),
                onPressed: () {
                  setState(() {
                    _focusedDay = DateTime(
                      _focusedDay.year,
                      _focusedDay.month - 1,
                      1,
                    );
                  });
                },
              ),
              Text(
                DateFormat('MMMM yyyy', 'id_ID').format(_focusedDay),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.chevron_right,
                  color: Color(0xFFFF800020),
                  size: 30,
                ),
                onPressed: () {
                  setState(() {
                    _focusedDay = DateTime(
                      _focusedDay.year,
                      _focusedDay.month + 1,
                      1,
                    );
                  });
                },
              ),
            ],
          ),

          SizedBox(height: 30),

          // ** Kalender **
          TableCalendar(
            firstDay: _firstDay,
            lastDay: _lastDay,
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            headerVisible:
                false, // Header default dimatikan karena kita pakai custom header
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: Colors.grey[700], fontSize: 15),
              weekendStyle: TextStyle(color: Colors.red, fontSize: 15),
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Color(0xFFFF800020),
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
              defaultTextStyle: TextStyle(color: Colors.black, fontSize: 15),
              weekendTextStyle: TextStyle(color: Colors.red, fontSize: 15),
              outsideDaysVisible: false,
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                if (isSameDay(_selectedDay, selectedDay)) {
                  _selectedDay = DateTime.now();
                } else {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                }
              });
            },
            eventLoader: _getEventsForDay,
          ),
          SizedBox(height: 30),
          Column(
            children:
                _getEventsForDay(_selectedDay).isEmpty
                    ? [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          "No events",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF800020),
                          ),
                        ),
                      ),
                    ]
                    : _getEventsForDay(_selectedDay)
                        .map(
                          (event) => Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              "$event on ${DateFormat('dd MMMM yyyy', 'id_ID').format(_selectedDay)}",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF800020),
                              ),
                            ),
                          ),
                        )
                        .toList(),
          ),
        ],
      ),
    );
  }

  /// **Highlight Rentang Tanggal**
  List<DateTime> highlightedDates = [
    for (int i = 0; i < 5; i++)
      DateTime(
        lastPeriodDate!.year,
        lastPeriodDate!.month,
        lastPeriodDate!.day + i,
      ),

    for (int i = 0; i < 5; i++)
      DateTime(
        nextPeriodDate!.year,
        nextPeriodDate!.month,
        nextPeriodDate!.day + i,
      ),
  ];

  /// **Mengecek apakah hari memiliki event (untuk styling)**
  List<String> _getEventsForDay(DateTime day) {
    if (highlightedDates.any((date) => isSameDay(date, day))) {
      return ["Haid"];
    }
    return [];
  }
}
