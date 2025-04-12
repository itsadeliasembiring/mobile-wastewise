import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Beranda extends StatefulWidget {
  @override
  _BerandaState createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  int index = 4;

  final screens = [
    
  ];
  
  @override
  Widget build(BuildContext context) {
    final items = <Widget> [
      Icon(Icons.home, size: 30, color: Color(0xFF3D8D7A)),
      Icon(Icons.history, size: 30, color: Color(0xFF3D8D7A)),
      Icon(Icons.account_circle, size: 30, color: Color(0xFF3D8D7A)),
      Icon(Icons.settings, size: 30, color: Color(0xFF3D8D7A)),
      Icon(Icons.notifications, size: 30, color: Color(0xFF3D8D7A)),
    ];

    return Scaffold(
      backgroundColor: Color(0xFFF5F6FA),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/maskot.png'),
                  backgroundColor: Color(0xFFA3D1C6),
                ),
                SizedBox(width: 10), // Jarak antara avatar dan teks
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Halo, ',
                          style: GoogleFonts.montserrat(
                            fontSize: 26,
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: 'Trisna!',
                          style: GoogleFonts.montserrat(
                            fontSize: 26,
                            fontWeight: FontWeight.bold, // Membuat "Trisna" menjadi bold
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
                            'Poin terkumpul',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Image.asset(
                                'assets/poin.png',
                                width: 35,
                                height: 35,
                              ),
                              SizedBox(width: 8),
                              Text(
                                '250 Poin',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF3D8D7A),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
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
                          'assets/recycle-outline.png',
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            print('Button clicked!');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFD6EFD8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
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
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      print('Setor Sampah Clicked!');
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Color(0xFFD6EFD8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/icon-setor-sampah.png',
                              width: 40,
                              height: 40,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Setor Sampah',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF3D8D7A),
                                ),
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      print('Kenali Sampah Clicked!');
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Color(0xFFD6EFD8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/icon-kenali-sampah.png',
                              width: 40,
                              height: 40,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Kenali Sampah',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF3D8D7A),
                                ),
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lokasi Bank Sampah Terdekat',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3D8D7A),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Ubah sampah jadi berkah lewat bank sampah!',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF666666),
                        ),
                      ),
                      SizedBox(height: 16),
                      WasteBankCard(
                        name: 'Bank Sampah Mulyorejo',
                        address: 'Jl. Mulyorejo Tengah No. 67',
                        distance: '1.4 KM',
                        imagePath: 'assets/default-bank-sampah.png',
                      ),
                      SizedBox(height: 12),
                      WasteBankCard(
                        name: 'Bank Sampah Kalijudan',
                        address: 'Jl. Kalijudan V No. 33D',
                        distance: '2.8 KM',
                        imagePath: 'assets/default-bank-sampah.png',
                      ),
                      SizedBox(height: 12),
                      WasteBankCard(
                        name: 'Bank Sampah Jojoran 1',
                        address: 'Jl. Jojoran 1 Blok Z No. 101',
                        distance: '3.9 KM',
                        imagePath: 'assets/default-bank-sampah.png',
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: index,
        items: items,
        height: 70,
        onTap: (index) => setState(() => this.index = index),
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Color(0xFF3D8D7A),
        ),
    );
  }
}

class WasteBankCard extends StatelessWidget {
  final String name;
  final String address;
  final String distance;
  final String imagePath;

  const WasteBankCard({
    Key? key,
    required this.name,
    required this.address,
    required this.distance,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFA3D1C6).withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20, 
            backgroundImage: AssetImage(imagePath), 
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  address,
                  style: const TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Color(0xFF3D8D7A),
                  size: 12,
                ),
                const SizedBox(width: 4),
                Text(
                  distance,
                  style: const TextStyle(
                    color: Color(0xFF3D8D7A),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}