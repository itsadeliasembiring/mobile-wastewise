import 'package:flutter/material.dart';

class Autentikasi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Gambar Maskot
              Image.asset('assets/maskot_with_circle.png', height: 220),
              const SizedBox(height: 20),

              // Judul "Selamat Datang"
              const Text(
                'Selamat Datang',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3D8D7A),
                ),
              ),
              const SizedBox(height: 10),

              // Subjudul
              const Text(
                'Bijak mengelola sampah,\nHidup lebih berkah',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF8CB8A6),
                ),
              ),
              const SizedBox(height: 40),

              // Tombol Masuk
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3D8D7A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text(
                    'Masuk',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Tombol Daftar
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF3D8D7A), width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: const Text(
                    'Daftar',
                    style: TextStyle(fontSize: 18, color: Color(0xFF3D8D7A)),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Persetujuan Kebijakan Privasi
              const Text.rich(
                TextSpan(
                  text: 'Dengan masuk atau mendaftar, Anda menyetujui ',
                  style: TextStyle(fontSize: 12, color: Color(0xFFA1A4B2)),
                  children: [
                    TextSpan(
                      text: 'Persyaratan Layanan',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF3D8D7A)),
                    ),
                    TextSpan(text: ' dan '),
                    TextSpan(
                      text: 'Kebijakan Privasi',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF3D8D7A)),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
