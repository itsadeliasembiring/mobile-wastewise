import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailArtikel extends StatelessWidget {
  final String title;
  final String content;
  final String date;
  final String image;
  final String author;

  const DetailArtikel({
    required this.title,
    required this.content,
    required this.date,
    required this.image,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text("Detail Artikel", 
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          color: Color(0xFF3D8D7A), 
        )),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 230,
              margin: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25)
              ),
              child: Center(
                child: ClipRRect(
                  child: Image.asset(
                    image,
                    width: double.infinity, 
                    height: 230, 
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        child: Icon(Icons.person, color: Colors.black54),
                      ),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            author,
                            style: GoogleFonts.poppins(
                              color: Colors.green[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(date, style: TextStyle(fontSize: 12, color: Colors.black54)),
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    content,
                    style: GoogleFonts.inter(fontSize: 16, height: 1.5),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}