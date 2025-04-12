import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MaterialApp(
    home: Artikel(),
    debugShowCheckedModeBanner: false,
  ));
}

class Artikel extends StatelessWidget {
  final List<Map<String, String>> artikelList = [
    {
      "title": "WasteWise: Inovasi Aplikasi Bank Sampah untuk Lingkungan Lebih Bersih",
      "subtitle":
          "Surabaya - Inovasi teknologi terus berkembang untuk mendukung keberlanjutan lingkungan...",
      "date": "17/02/2025, 09:30 WIB",
      "image": "assets/waste-wise-artikel.png"
    },
    {
      "title": "Sampah Plastik di Laut Ancam Ekosistem dan Biota Laut",
      "subtitle":
          "Surabaya - Sampah plastik di laut semakin mengancam ekosistem perairan Indonesia...",
      "date": "20/02/2025, 13:30 WIB",
      "image": "assets/kura-kura.jpg"
    },
    {
      "title": "Aksi Bersih Pantai di Surabaya: Warga dan Relawan Bersatu Demi Laut yang Lebih Bersih",
      "subtitle":
          "Surabaya - Sampah plastik di laut semakin mengancam ekosistem perairan Indonesia...",
      "date": "16/03/2025, 07:30 WIB",
      "image": "assets/bersih-pantai.jpg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Artikel",
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: artikelList.length,
        itemBuilder: (context, index) {
          final artikel = artikelList[index];

          // Semua kartu artikel sama
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailArtikelPage(
                    title: artikel["title"]!,
                    content: artikel["subtitle"]!,
                    date: artikel["date"]!,
                    image: artikel["image"]!,
                  ),
                ),
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: EdgeInsets.only(bottom: 16),
              elevation: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.asset(
                      artikel["image"]!,
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          artikel["title"]!,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 5),
                        Text(
                          artikel["subtitle"]!,
                          style: GoogleFonts.montserrat(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 10),
                        Text(
                          artikel["date"]!,
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
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

class DetailArtikelPage extends StatelessWidget {
  final String title;
  final String content;
  final String date;
  final String image;

  DetailArtikelPage({
    required this.title,
    required this.content,
    required this.date,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detail Artikel",
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              image,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    date,
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    content,
                    style: GoogleFonts.montserrat(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}