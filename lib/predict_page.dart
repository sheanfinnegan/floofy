import 'package:flutter/material.dart';
import 'dart:math';
import 'home_page.dart';
import 'database_helper.dart';

DateTime? lastPeriodDate;

class PredictPage extends StatefulWidget {
  @override
  _PredictPageState createState() => _PredictPageState();
}

class _PredictPageState extends State<PredictPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final data = await _dbHelper.getSessionData(currSessionId);
    if (data != null) {
      setState(() {
        lastPeriodDate =
            data['lastPeriodDate'] != null
                ? DateTime.parse(data['lastPeriodDate']) // Convert from string
                : null;
      });
    }
    // print(_lastPeriodDate);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadData(); // Muat data setiap kali halaman dibuka
  }

  String formatDate(DateTime date) {
    const List<String> monthNames = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];

    String day = date.day.toString();
    String month = monthNames[date.month];
    String year =
        date.year % 100 < 10
            ? '0${date.year % 100}' // Tambah 0 kalau perlu
            : '${date.year % 100}';

    return '$day $month $year';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              // width: ,
              height: 270,
              child: Image.asset('assets/images/FloofyLogo.png'),
            ),
            SizedBox(
              width: 300,
              // height: 300,
              child: CustomPaint(
                painter: CyclePainter(),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: CircleAvatar(
                          radius: 90,
                          backgroundColor: Color(0xFFE57373),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Start Period:  ${lastPeriodDate != null ? formatDate(lastPeriodDate!) : '-'}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Cycle Length (P): 28 hari',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Next Period (P)',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '18 Februari 2025',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 110),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '*(P) is Floofy\'s prediction',
                  style: TextStyle(fontSize: 11, color: Color(0xFFE57373)),
                ),
                SizedBox(width: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CyclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final radius = size.width / 2;
    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 30
          ..strokeCap = StrokeCap.round;

    // Lingkaran dasar
    paint.color = Color(0xFFFBE1DE)!;
    canvas.drawCircle(center, radius - 10, paint);

    // paint.color = Colors.white!;
    // canvas.drawCircle(center, radius - 10, paint);

    // Haid (bagian atas)
    paint.color = Color(0xFFF65000B)!;
    drawArc(canvas, center, radius - 10, -1.5 * pi / 4, pi / 2.7, paint);
    drawRotatedText(
      canvas,
      "Haid",
      center,
      radius + 30,
      -pi / 6,
      Colors.red[900]!,
    );

    // Masa subur (bagian bawah)
    paint.color = Color(0xFFE57373)!;
    drawArc(canvas, center, radius - 10, pi / 6.5, pi / 1.5, paint);
    drawRotatedText(
      canvas,
      "Masa Subur",
      center,
      radius + 25,
      pi / 2,
      Colors.pink[300]!,
    );
  }

  void drawArc(
    Canvas canvas,
    Offset center,
    double radius,
    double startAngle,
    double sweepAngle,
    Paint paint,
  ) {
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  void drawRotatedText(
    Canvas canvas,
    String text,
    Offset center,
    double radius,
    double angle,
    Color color,
  ) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: 14,
          color: color,
          fontWeight: FontWeight.normal,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    // Hitung posisi teks berdasarkan sudut dan radius
    final x = center.dx + radius * cos(angle) - textPainter.width / 2;
    final y = center.dy + radius * sin(angle) - textPainter.height / 2;

    textPainter.paint(canvas, Offset(x, y));
  }

  @override
  bool shouldRepaint(CyclePainter oldDelegate) => false;
}
