import 'package:flutter/material.dart';


class DetailPage extends StatelessWidget {
  final  character; 
  DetailPage(this.character);
@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          character.anime,
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              character.gambar,
              width: 200,
            ),
            SizedBox(height: 20),
            Text(
              "${character.anime}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Studio: ${character.studio}",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            Text(
              " ${character.desk}",
              style: TextStyle(
                fontSize: 12,
              ),
            )
            // Tambahkan informasi detail lainnya di sini sesuai kebutuhan.
          ],
        ),
      ),
    );
  }
}
