import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/splash-screen-maskot.gif',
              gaplessPlayback: true,
              width: 276,
              height: 276,
            ),
            Transform.translate(
              offset: const Offset(0, -30),
              child: Text(
                'WasteWise',
                style: GoogleFonts.montserrat(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3D8D7A),
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -35),
              child: 
                Text(
                  '“Ubah Sampah Jadi Berkah”',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    color: Colors.black,
                    fontStyle: FontStyle.italic  
                  ),
                ),
            ),
            
          ],
        ),
      ),
    );
  }
}
