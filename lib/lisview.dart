import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'detail_page.dart';
import 'profil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_auth_service.dart';
import 'login.dart';
import 'firestore_service.dart';

class ScrollingScreen extends StatefulWidget {
  ScrollingScreen({Key? key}) : super(key: key);

  @override
  _ScrollingScreenState createState() => _ScrollingScreenState();
}

class _ScrollingScreenState extends State<ScrollingScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirestoreService _firestoreService = FirestoreService();
  TextEditingController gambarController = TextEditingController();
  TextEditingController judulController = TextEditingController();
  TextEditingController studioController = TextEditingController();
  String _docId = ''; // Ganti nama variabel untuk menghindari konflik

  late TextEditingController _searchController;
  List<Map<String, dynamic>> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  Widget _buildListItem(String docId, Map<String, dynamic> animeData) {
    print("Doc ID: $docId"); // Tambahkan log ini
  print("Anime Data: $animeData"); // Tambahkan log ini
    var gambarAnime = animeData['Gambar'] ?? '';
    var judulAnime = animeData['Judul Anime'] ?? '';
    var studioAnime = animeData['Studio'] ?? '';

    return InkWell(
      onTap: () {
        setState(() {
          _docId = docId; // Perbarui variabel level kelas
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPage(_docId), // Gunakan variabel level kelas
          ),
        );
      },
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: Colors.black),
          borderRadius: BorderRadius.circular(4),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Image.network(gambarAnime, width: 120),
            Container(
              padding: EdgeInsets.only(left: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    judulAnime,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    studioAnime,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _streamBuilder() {
    if (_searchController.text.isEmpty) {
      return StreamBuilder<QuerySnapshot>(
        stream: _firestoreService.getUsers(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          final users = snapshot.data?.docs ?? [];

          return ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: users.length,
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                height: 5,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              var documentSnapshot = users[index];
              var animeData = documentSnapshot.data() as Map<String, dynamic>;
              var docId = documentSnapshot.id;
              return _buildListItem(docId, animeData);
            },
          );
        },
      );
    } else {
      return FutureBuilder<List<Map<String, dynamic>>>(
        future: _firestoreService.searchAnime(_searchController.text),
        builder:
            (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          var users = snapshot.data ?? [];

          return ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: users.length,
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                height: 5,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              var animeData = users[index] as Map<String, dynamic>;
              var docId = 'some_default_id'; // Berikan nilai default atau temukan ID yang sesuai
              return _buildListItem(docId, animeData);
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Anime Wiki',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.red,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Profil'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePic(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text('Log Out'),
              onTap: () {
                _auth.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Login(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Cari Anime...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onChanged: (value) {
                  _performSearch(value);
                },
              ),
            ),
            _streamBuilder(),
          ],
        ),
      ),
    );
  }

 void _performSearch(String query) {
  _firestoreService.searchAnime(query).then((results) {
    print("Search Results: $results"); // Tambahkan log ini
    setState(() {
      _searchResults = results;
    });
  });
}

}
