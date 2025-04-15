import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Autentikasi/autentikasi.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0; 
      });
    });
  }

  void _goToAutentikasi() {
    setState(() {
      _opacity = 0.0; 
    });

    Future.delayed(Duration(milliseconds: 500), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Autentikasi()), 
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: _goToAutentikasi,
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: _opacity,
          child: Center(
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
                  child: Text(
                    '“Ubah Sampah Jadi Berkah”',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.black,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
