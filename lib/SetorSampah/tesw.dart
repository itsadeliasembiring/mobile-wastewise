import 'package:flutter/material.dart';
import 'riwayat_setor_sampah.dart';
import './pilih_bank_sampah.dart';

class SetorSampah extends StatefulWidget {
  @override
  _SetorSampahState createState() => _SetorSampahState();
}

class _SetorSampahState extends State<SetorSampah> {
  int _selectedTabIndex = 0; // Inisialisasi tab pertama yang aktif
  int _currentIndex = 0; // Inisialisasi halaman pertama yang tampil
  String searchQuery = "";

  List<Widget> _screens = [
    PilihBankSampah(),
    RiwayatSetorSampah(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header dengan jumlah poin
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Setor Sampah",
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w500, color: Color(0xFF3D8D7A)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFA3D1C6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Colors.amber,
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                'assets/poin.png',
                                width: 16,
                                height: 16,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text("308 Poin", style: TextStyle(color: Color(0xFF3D8D7A), fontWeight: FontWeight.w500, fontSize: 16)),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Tab buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedTabIndex = 0;
                              _currentIndex = 0; // Pilih tab pertama
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedTabIndex == 0 ? const Color(0xFF3D8D7A) : Colors.grey[200],
                            foregroundColor: _selectedTabIndex == 0 ? Colors.white : Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                            ),
                          ),
                          child: const Text("Setor Sekarang"),
                        ),
                      ),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedTabIndex = 1;
                              _currentIndex = 1; // Pilih tab kedua
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _selectedTabIndex == 1 ? const Color(0xFF3D8D7A) : Colors.grey[200],
                            foregroundColor: _selectedTabIndex == 1 ? Colors.white : Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                            ),
                          ),
                          child: const Text("Riwayat Setor"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Konten berdasarkan tab yang dipilih
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: _screens,
              ),
            ),
          ],
        ),
      ),
    );
  }
}