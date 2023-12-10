import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeUser extends StatefulWidget {
  const HomeUser({super.key});

  @override
  State<HomeUser> createState() => _HomeUserState();
}

final FirestoreService firestoreService = FirestoreService();
TextEditingController addGambarController = TextEditingController();
TextEditingController addJudulController = TextEditingController();
TextEditingController addStudioController = TextEditingController();

TextEditingController updateGambarController = TextEditingController();
TextEditingController updateJudulController = TextEditingController();
TextEditingController updateStudioController = TextEditingController();

class _HomeUserState extends State<HomeUser> {
  @override
  Widget build(BuildContext context) {
  return Scaffold(
  body: SingleChildScrollView(
  child: Padding(
  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
  child: Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
  const SizedBox(
  height: 40,
  ),
  const Text(
  "List Anime",
  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  ),
  SizedBox(
  height: 10,
  ),
  InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Tambah Anime'),
                        content: Column(
                          children: [
                            TextField(
                              controller: addGambarController,
                              decoration:
                                  InputDecoration(labelText: 'Gambar URL'),
                            ),
                            TextField(
                              controller: addJudulController,
                              decoration:
                                  InputDecoration(labelText: 'Judul Anime'),
                            ),
                            TextField(
                              controller: addStudioController,
                              decoration: InputDecoration(labelText: 'Studio'),
                            ),
                          ],
                        ),
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              // Simpan data baru ke Firestore
                              firestoreService.addUsers(
                                addGambarController.text,
                                addJudulController.text,
                                addStudioController.text,
                              );
                              addGambarController.clear();
                              addJudulController.clear();
                              addStudioController.clear();

                              // Tutup dialog setelah data ditambahkan
                              Navigator.of(context).pop();
                            },
                            child: Text('Simpan'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  width: 150,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Text(
                      "Tambah Data",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirestoreService().getUsers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    } else {
                      List userList = snapshot.data!.docs;
                      return SizedBox(
                        width: double.infinity,
                        child: ListView.builder(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: userList.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot documentSnapshot = userList[index];

                            Map<String, dynamic> data =
                                documentSnapshot.data() as Map<String, dynamic>;

                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              child: Material(
                                color: Colors.purple[50],
                                elevation: 2,
                                borderRadius: BorderRadius.circular(5),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: SizedBox(
                                              width: 120,
                                              child: Image(
                                                  image: NetworkImage(
                                                      data['Gambar'])),
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                data['Judul Anime'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                              ),
                                              Text(data['Studio']),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 140,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return FutureBuilder<
                                                              DocumentSnapshot>(
                                                            future: FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'users')
                                                                .doc(
                                                                    documentSnapshot
                                                                        .id)
                                                                .get(),
                                                            builder: (context,
                                                                snapshot) {
                                                              if (snapshot
                                                                      .connectionState ==
                                                                  ConnectionState
                                                                      .waiting) {
                                                                return CircularProgressIndicator();
                                                              }

                                                              if (snapshot
                                                                  .hasError) {
                                                                return Text(
                                                                    'Error: ${snapshot.error}');
                                                              }

                                                              Map<String,
                                                                      dynamic>
                                                                  data =
                                                                  snapshot.data!
                                                                          .data()
                                                                      as Map<
                                                                          String,
                                                                          dynamic>;

                                                              // Set initial values for the TextFields
                                                              updateGambarController
                                                                      .text =
                                                                  data[
                                                                      'Gambar'];
                                                              updateJudulController
                                                                      .text =
                                                                  data[
                                                                      'Judul Anime'];
                                                              updateStudioController
                                                                      .text =
                                                                  data[
                                                                      'Studio'];

                                                              return AlertDialog(
                                                                title: Text(
                                                                    'Update Anime'),
                                                                content: Column(
                                                                  children: [
                                                                    TextField(
                                                                      controller:
                                                                          updateGambarController,
                                                                      decoration:
                                                                          InputDecoration(
                                                                              labelText: 'Gambar URL'),
                                                                    ),
                                                                    TextField(
                                                                      controller:
                                                                          updateJudulController,
                                                                      decoration:
                                                                          InputDecoration(
                                                                              labelText: 'Judul Anime'),
                                                                    ),
                                                                    TextField(
                                                                      controller:
                                                                          updateStudioController,
                                                                      decoration:
                                                                          InputDecoration(
                                                                              labelText: 'Studio'),
                                                                    ),
                                                                  ],
                                                                ),
                                                                actions: [
                                                                  ElevatedButton(
                                                                    onPressed:
                                                                        () {
                                                                      // Simpan data baru ke Firestore
                                                                      firestoreService
                                                                          .updateUsers(
                                                                        documentSnapshot
                                                                            .id,
                                                                        updateGambarController
                                                                            .text,
                                                                        updateJudulController
                                                                            .text,
                                                                        updateStudioController
                                                                            .text,
                                                                      );

                                                                      // Tutup dialog setelah data ditambahkan
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop();
                                                                    },
                                                                    child: Text(
                                                                        'Simpan'),
                                                                  ),
                                                                ],
                                                              );
                                                            },
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Icon(
                                                      Icons.add_box_rounded,
                                                      color: Colors.green,
                                                      size: 30,
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return AlertDialog(
                                                            title: Text(
                                                                'Hapus Anime'),
                                                            content: Text(
                                                                'Apakah yakin ingin menghapus data?'),
                                                            actions: [
                                                              ElevatedButton(
                                                                onPressed: () {
                                                                  // Hapus data dari Firestore
                                                                  firestoreService
                                                                      .deleteUsers(
                                                                          documentSnapshot
                                                                              .id);

                                                                  // Tutup dialog setelah data dihapus
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                                child: Text(
                                                                    'Hapus'),
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                      size: 30,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FirestoreService {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  Stream<QuerySnapshot> getUsers() {
    final usersStream = users.snapshots();
    return usersStream;
  }

  Future<void> addUsers(String gambar, String judul, String studio) async {
    users.add({'Gambar': gambar, 'Judul Anime': judul, 'Studio': studio});
  }

  Future<void> updateUsers(
      String id, String gambar, String judul, String studio) async {
    users.doc(id).update({
      'Gambar': gambar,
      'Judul Anime': judul,
      'Studio': studio,
    });
  }

  Future<void> deleteUsers(String id) async {
    users.doc(id).delete();
  }
}
