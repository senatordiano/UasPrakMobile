import 'package:flutter/material.dart';

class ProfilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tentang Pembuat'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'folder/images/aki.jpg', 
              width: 160,
              height: 160,
            ),
            SizedBox(height: 20),
            Text(
              'Senator Marcielio Cheviray Diano',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),SizedBox(height: 10),
            Text(
              'Nim : 210605110053',
              style: TextStyle(fontSize: 18),
            ),SizedBox(height: 10),
            Text(
              'Telp : 082141434816',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Email: 210605110053@student.uin-malang.ac.id',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
