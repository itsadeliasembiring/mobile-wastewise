import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Beranda extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6FA), // Background color
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Align content to the left
          children: [
            CircleAvatar(
              radius: 35, 
              backgroundImage: AssetImage('assets/maskot.png'), // Your profile image path
              backgroundColor: Color(0xFFA3D1C6), // Fallback color if no image
            ),

            SizedBox(height: 5),

            Text(
              'Halo, Trisna!',
              textAlign: TextAlign.left,
              style: GoogleFonts.montserrat(
                fontSize: 26,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),

            SizedBox(height: 5), 

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Color(0xFFA3D1C6),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Poin yang terkumpul',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/poin.png',
                                width: 35,
                                height: 35,
                              ),
                              SizedBox(width: 8),
                              Text(
                                '250 Poin', // Number of coins
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF3D8D7A),
                                ),
                              ),
                            ],
                          ),
                          
                              Text(
                                'Tukar Poin!',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Image.asset(
                          'assets/recycle-outline.png', // Your second image path
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 8), // Jarak antara gambar dan tombol
                        // Tombol di bawah gambar
                        ElevatedButton(
                          onPressed: () {
                            print('Button clicked!');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFD6EFD8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                          ),
                          child: Text(
                            '5 Kg Sampah Terkumpul',
                            style: TextStyle(color: Colors.black, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
