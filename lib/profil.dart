import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animewiki/login.dart';
import 'package:animewiki/lisview.dart';

class ProfilePic extends StatefulWidget {
  const ProfilePic({Key? key}) : super(key: key);

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User? _user;
  String name = "";
  String email = "";
  String telepon = "";

  @override
  void initState() {
    _user = _auth.currentUser;
    _loadUserData();
    super.initState();
  }

  Future<void> _loadUserData() async {
    if (_user != null) {
      try {
        DocumentSnapshot userSnapshot =
            await _firestore.collection("profile").doc(_user!.uid).get();
        if (userSnapshot.exists) {
          setState(() {
            name = userSnapshot.get("nama") ?? "";
            email = userSnapshot.get("email") ?? "";
            telepon = userSnapshot.get("telephone") ?? "";
          });
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red, // Ganti dengan warna merah yang diinginkan
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        iconSize: 25,
        selectedItemColor: Color(0xFFFD725A),
        unselectedItemColor: Colors.grey,
        currentIndex: 1,
        onTap: (index) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ScrollingScreen()),
          );
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 90,
            ),
            MyFP(),
            ProfileMenu(
              text: name,
              ikon: Icons.person,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfileScreen()),
                ).then((value) {
                  _loadUserData();
                });
              },
            ),
            ProfileMenu(
              text: telepon,
              ikon: Icons.call,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditTeleponScreen()),
                ).then((value) {
                  _loadUserData();
                });
              },
            ),
            ProfileMenu(
              text: "Log Out",
              ikon: Icons.logout,
              press: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    Key? key,
    required this.text,
    this.press,
    required this.ikon,
  }) : super(key: key);

  final String text;
  final IconData ikon;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          backgroundColor: Color(0xFFF5F6F9), // Warna latar belakang dalam container
        ),
        onPressed: press,
        child: Row(
          children: [
            Icon(ikon),
            SizedBox(width: 10),
            Expanded(child: Text(text)),
            Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }
}

class MyFP extends StatelessWidget {
  const MyFP({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
                "https://th.bing.com/th/id/OIP.JILWfIdlnzBPNbI6NMvr8QHaF5?rs=1&pid=ImgDetMain"),
          ),
        ],
      ),
    );
  }
}

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _newNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Nama'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _newNameController,
              decoration: const InputDecoration(labelText: 'Nama Baru'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String newName = _newNameController.text;
                if (newName.isNotEmpty) {
                  try {
                    User? user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      await FirebaseFirestore.instance
                          .collection('profile')
                          .doc(user.uid)
                          .update({'nama': newName});
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Nama berhasil diperbarui.'),
                        ),
                      );
                      Navigator.pop(context); // Kembali ke layar profil setelah disimpan
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('User tidak ditemukan.'),
                        ),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Nama tidak boleh kosong.'),
                    ),
                  );
                }
              },
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditTeleponScreen extends StatefulWidget {
  const EditTeleponScreen({Key? key}) : super(key: key);

  @override
  _EditTeleponScreenState createState() => _EditTeleponScreenState();
}

class _EditTeleponScreenState extends State<EditTeleponScreen> {
  final TextEditingController _newTeleponController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Nomor Telepon'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _newTeleponController,
              decoration:
                  const InputDecoration(labelText: 'Nomor Telepon Baru'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String newTelepon = _newTeleponController.text;
                if (newTelepon.isNotEmpty) {
                  try {
                    User? user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      await FirebaseFirestore.instance
                          .collection('profile')
                          .doc(user.uid)
                          .update({'telephone': newTelepon});
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Nomor telepon berhasil diperbarui.'),
                        ),
                      );
                      Navigator.pop(context); // Kembali ke layar profil setelah disimpan
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('User tidak ditemukan.'),
                        ),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: $e'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Nomor telepon tidak boleh kosong.'),
                    ),
                  );
                }
              },
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
