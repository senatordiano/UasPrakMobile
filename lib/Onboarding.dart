import 'package:flutter/material.dart';
import 'package:animewiki/login.dart';

class OnboardingScreen extends StatelessWidget {
  final PageController _pageController = PageController();
  final List<Widget> _onboardingPages = [
    OnboardingPage(
      title: "Selamat Datang di Anime Wiki",
      description: "Temukan dan jelajahi dunia anime bersama kami.",
      image: "https://th.bing.com/th/id/OIP.2r_iJUi1F33JEwTh0ivfWQAAAA?rs=1&pid=ImgDetMain", // Gantilah dengan path gambar yang sesuai
    ),
    OnboardingPage(
      title: "Cari Anime Favorit Anda",
      description: "Gunakan fitur pencarian untuk menemukan anime favorit Anda.",
      image: "https://is3-ssl.mzstatic.com/image/thumb/Purple126/v4/3b/50/c7/3b50c71f-13f1-208b-4333-04e5b609ec12/source/512x512bb.jpg", // Gantilah dengan path gambar yang sesuai
    ),
    OnboardingPage(
      title: "Lihat Detail Anime",
      description: "Lihat informasi lengkap dan deskripsi setiap anime yang menarik.",
      image: "https://th.bing.com/th/id/OIF.5IFNIa8yVeeddSiue5KXbA?rs=1&pid=ImgDetMain", // Gantilah dengan path gambar yang sesuai
    ),
    // Tambahkan halaman onboarding sesuai kebutuhan
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.red,
      body: FutureBuilder(
        // Delay untuk memastikan PageView sudah dibangun
        future: Future.delayed(Duration(milliseconds: 500), () {}),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return _buildPageView();
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      bottomSheet: _buildBottomSheet(context),
    );
  }

  Widget _buildPageView() {
    return PageView.builder(
      controller: _pageController,
      itemCount: _onboardingPages.length,
      itemBuilder: (context, index) {
        return _onboardingPages[index];
      },
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(20),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton(
          onPressed: () {
            final currentPage = _pageController.page ?? 0;
            if (currentPage >= _onboardingPages.length - 1) {
              // Jika di halaman terakhir, maka pindah ke halaman utama (ScrollingScreen)
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Login(),
                ),
              );
            } else {
              // Jika belum di halaman terakhir, pindah ke halaman berikutnya
              _pageController.nextPage(
                duration: Duration(milliseconds: 500),
                curve: Curves.ease,
              );
            }
          },
          child: Text("Selanjutnya"),
        ),
      ],
    ),
  );
}


}

class OnboardingPage extends StatefulWidget {
  final String title;
  final String description;
  final String image;

  const OnboardingPage({
    Key? key,
    required this.title,
    required this.description,
    required this.image,
  }) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        Text(
          widget.description,
          style: TextStyle(
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        Image.network(
          widget.image, // Menggunakan Image.network untuk gambar dari internet
          height: 200,
        ),
      ],
    );
  }
}


