import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_wastewise/Artikel/detail_artikel.dart';
import 'package:mobile_wastewise/KenaliSampah/kenali_sampah.dart'; // Import for KenaliSampah

class Artikel extends StatelessWidget {
  final List<Map<String, String>> artikelList = [
    {
      "title": "WasteWise: Inovasi Aplikasi Bank Sampah untuk Lingkungan Lebih Bersih",
      "content": '''
      Surabaya - Inovasi teknologi terus berkembang untuk mendukung keberlanjutan lingkungan. Salah satu solusi terbaru adalah WasteWise, aplikasi bank sampah digital yang membantu masyarakat mengelola sampah dengan lebih efektif.
      Dengan fitur-fitur canggih seperti pencatatan transaksi sampah, edukasi mengenai sampah, serta program insentif berbasis poin, WasteWise diharapkan mampu meningkatkan kesadaran masyarakat dalam mendaur ulang sampah. CEO WasteWise, Adelia Trisna, menyatakan bahwa aplikasi ini hadir sebagai jawaban atas permasalahan sampah yang kian meningkat di Indonesia.
      "Kami ingin mengubah cara pandang masyarakat tentang sampah. Dengan WasteWise, sampah bukan lagi limbah yang harus dibuang, tetapi bisa memiliki nilai ekonomi," ujar Adelia.
      Aplikasi ini sudah tersedia di Android maupun iOS.
      ''',
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
      backgroundColor: Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text("Artikel",  
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          color: Color(0xFF3D8D7A), 
        )),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        children: [
          // Redesigned Kenali Sampah Card
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => KenaliSampah(),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFF3D8D7A).withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF3D8D7A),
                    Color(0xFF2A6358),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Decorative circles
                  Positioned(
                    top: -15,
                    right: -15,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -20,
                    left: -20,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.08),
                      ),
                    ),
                  ),
                  
                  // Main Content
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        // Left section with icon
                        Container(
                          width: 80,
                          height: 80,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF3D8D7A),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.document_scanner_rounded,
                              color: Colors.white,
                              size: 36,
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        
                        // Right section with text
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Kenali Sampah",
                                style: GoogleFonts.poppins(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Scan atau input manual untuk mengetahui jenis sampah dan cara pengelolaannya",
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => KenaliSampah(),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Color(0xFF3D8D7A),
                                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.search_rounded, size: 16),
                                        SizedBox(width: 4),
                                        Text(
                                          "Mulai",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Section Divider
          Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Expanded(
                  child: Divider(
                    color: Colors.grey.withOpacity(0.3),
                    thickness: 1.5,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "ARTIKEL TERBARU",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                Expanded(
                  child: Divider(
                    color: Colors.grey.withOpacity(0.3),
                    thickness: 1.5,
                  ),
                ),
              ],
            ),
          ),
          
          // Existing Article Cards
          ...List.generate(
            artikelList.length,
            (index) {
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
                  color: Colors.white,
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
        ],
      ),
    );
  }
}