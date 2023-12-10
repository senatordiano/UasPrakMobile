import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  Stream<QuerySnapshot> getUsers() {
    return users.snapshots();
  }

  Future<void> addUsers(String Gambar, String Judul, String Studio) async {
    users.add({'Gambar': Gambar, 'Judul Anime': Judul, 'Studio': Studio});
  }

  Future<void> updateUsers(
      String id, String Gambar, String Judul, String Studio) async {
    users.doc(id).update({
      'Gambar': Gambar,
      'Judul Anime': Judul,
      'Studio': Studio,
    });
  }

  Future<void> deleteUsers(String id) async {
    users.doc(id).delete();
  }

  // Perbarui fungsi searchAnime agar mengembalikan List<Map<String, dynamic>>
  Future<List<Map<String, dynamic>>> searchAnime(String query) async {
  var result = await users
      .orderBy('Judul Anime')
      .startAt([query]).endAt([query + '\uf8ff']).get();

  return result.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
}

}
