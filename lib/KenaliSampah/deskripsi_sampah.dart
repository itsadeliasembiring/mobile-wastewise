import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DeskripsiSampah extends StatelessWidget {
  final String wasteType;

  const DeskripsiSampah({
    Key? key,
    required this.wasteType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text(
          "Penjelasan Sampah",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Color(0xFF3D8D7A),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/gambar-sampah/botol-plastik.png',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 24),
              
              // Title
              Text(
                "Botol Plastik",
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              
              // Description
              Text(
                "Botol Plastik adalah wadah yang terbuat dari bahan polimer seperti PET (Polyethylene Terephthalate) yang sering digunakan untuk kemasan air mineral, minuman ringan, dan produk lainnya. Botol plastik banyak digunakan karena ringan, murah, dan tahan lama, namun jika tidak dikelola dengan baik, dapat mencemari lingkungan.",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 24),
              
              // Waste Type
              Text(
                "Jenis Sampah",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Anorganik adalah jenis sampah yang berasal dari non-hayati dan tidak mudah terurai, seperti plastik, kaca, logam, dan kertas.",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              
              // Waste Bin Color
              Text(
                "Warna Tempat Sampah",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Kuning",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 24),
              
              // Characteristics
              Text(
                "Ciri - ciri :",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              _buildBulletPoint("Terbuat dari bahan polimer sintetis (biasanya PET - Polyethylene Terephthalate)"),
              _buildBulletPoint("Ringan tetapi kuat"),
              _buildBulletPoint("Transparan atau semi-transparan (tergantung jenis plastiknya)"),
              _buildBulletPoint("Tahan terhadap air dan kelembapan"),
              _buildBulletPoint("Sulit terurai secara alami (bisa membutuhkan waktu 450-1000 tahun)"),
              _buildBulletPoint("Mudah berubah bentuk jika terkena panas tinggi"),
              SizedBox(height: 24),
              
              // Use cases
              Text(
                "Pemanfaatan :",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              _buildNumberedPoint(1, "Daur Ulang: Dijadikan botol baru, kain poliester, ember, kursi plastik, atau aspal plastik."),
              _buildNumberedPoint(2, "Kerajinan Tangan: Pot tanaman, tempat pensil, lampu hias, atau mainan anak."),
              _buildNumberedPoint(3, "Wadah Penyimpanan: Untuk sabun cair, minyak goreng, atau botol penyiram tanaman."),
              _buildNumberedPoint(4, "Konstruksi: Bata ramah lingkungan (eco-bricks), dinding rumah, atau perahu dari botol plastik."),
              _buildNumberedPoint(5, "Pertanian: Media tanam hidroponik dan sistem irigasi tetes sederhana."),
              SizedBox(height: 32),
              
              // Back button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3D8D7A),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Kembali",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "• ",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberedPoint(int number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$number. ",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}