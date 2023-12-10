import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailPage extends StatelessWidget {
  final String docId;

  DetailPage(this.docId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Anime'),
        backgroundColor: Colors.red,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(docId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data?.data() == null) {
            return Center(
              child: Text('Data not found'),
            );
          }

          var animeData = snapshot.data?.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.network(
                    animeData['Gambar'] ?? '',
                    width: 200,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "${animeData['Judul Anime'] ?? 'Judul tidak tersedia'}",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Studio: ${animeData['Studio'] ?? 'Studio not available'}",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "${animeData['desk'] ?? 'Deskripsi tidak tersedia'}",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

