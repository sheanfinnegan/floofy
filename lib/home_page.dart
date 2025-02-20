import 'package:flutter/material.dart';
import 'form_umur.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFE5E5),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/images/FloofyImg-1.png', height: 250),
            Text(
              'Ketahui lebih banyak dengan floofy',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            Container(
              margin: EdgeInsets.only(left: 40), // Menambahkan margin di kiri
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset('assets/images/img2.png', height: 30),
                  SizedBox(width: 10),
                  Text(
                    'Bersiap menghadapi haid',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),

            SizedBox(height: 15),
            Container(
              margin: EdgeInsets.only(left: 40), // Menambahkan margin di kiri
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset('assets/images/img2.png', height: 30),
                  SizedBox(width: 10),
                  Text(
                    'Paham dengan kondisi Anda',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),

            SizedBox(height: 15),
            Container(
              margin: EdgeInsets.only(left: 40), // Menambahkan margin di kiri
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset('assets/images/img2.png', height: 30),
                  SizedBox(width: 10),
                  Text(
                    'Tips mengatur emosi Anda',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(padding: EdgeInsets.all(10)),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 200, // Membuat tombol selebar parent
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FormUmurPage()),
                    );
                  },
                  child: Text(
                    'Berikutnya',
                    style: TextStyle(color: Color(0xFFE57373)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
