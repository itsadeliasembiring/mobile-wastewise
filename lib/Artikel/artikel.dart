import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_wastewise/DetailArtikel/detail_artikel.dart';

class Artikel extends StatelessWidget {
  final List<Map<String, String>> artikelList = [
    {
      "title": "WasteWise: Inovasi Aplikasi Bank Sampah untuk Lingkungan Lebih Bersih",
      "content":
          "Surabaya - Inovasi teknologi terus berkembang untuk mendukung keberlanjutan lingkungan. Salah satu solusi terbaru adalah WasteWise, aplikasi bank sampah digital yang membantu masyarakat mengelola sampah dengan lebih efektif."
          "\nDengan fitur-fitur canggih seperti pencatatan transaksi sampah, edukasi mengenai sampah, serta program insentif berbasis poin, WasteWise diharapkan mampu meningkatkan kesadaran masyarakat dalam mendaur ulang sampah. CEO WasteWise, Adelia Trisna, menyatakan bahwa aplikasi ini hadir sebagai jawaban atas permasalahan sampah yang kian meningkat di Indonesia."
          "\n“Kami ingin mengubah cara pandang masyarakat tentang sampah. Dengan WasteWise, sampah bukan lagi limbah yang harus dibuang, tetapi bisa memiliki nilai ekonomi,” ujar Adelia."
          "\nAplikasi ini sudah tersedia di Android maupun iOS.",
      "date": "17/02/2025, 09:30 WIB",
      "image": "assets/waste-wise-artikel.png",
      "author": "Nama Bank Sampah"
    },
    {
      "title": "Sampah Plastik di Laut Ancam Ekosistem dan Biota Laut",
      "content":
          "Surabaya - Sampah plastik di laut semakin mengancam ekosistem perairan Indonesia. Berdasarkan laporan terbaru dari organisasi lingkungan hidup, Indonesia masih menjadi salah satu penyumbang sampah plastik terbesar di dunia.",
      "date": "20/02/2025, 13:30 WIB",
      "image": "assets/kura-kura.jpg",
      "author": "Nama Bank Sampah"
    },
    {
      "title": "Aksi Bersih Pantai di Surabaya: Warga dan Relawan Bersatu Demi Laut yang Lebih Bersih",
      "content":
          "Surabaya - Ratusan warga dan relawan lingkungan hidup berkumpul di Pantai Kenjeran, Surabaya, untuk melakukan aksi bersih-bersih pantai. Kegiatan ini merupakan bagian dari gerakan peduli lingkungan yang bertujuan mengurangi pencemaran sampah di pesisir laut.",
      "date": "16/03/2025, 07:30 WIB",
      "image": "assets/bersih-pantai.jpg",
      "author": "Nama Bank Sampah"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Artikel", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: artikelList.length,
        itemBuilder: (context, index) {
          final artikel = artikelList[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailArtikel(
                    title: artikel['title']!,
                    content: artikel['content']!,
                    date: artikel['date']!,
                    image: artikel['image']!,
                    author: artikel['author']!,
                  ),
                ),
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: EdgeInsets.only(bottom: 16),
              elevation: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
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
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 6),
                        Text(
                          artikel["content"]!,
                          style: GoogleFonts.inter(fontSize: 14, color: Colors.black87),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 10),
                        Text(
                          artikel["date"]!,
                          style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
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