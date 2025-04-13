import 'package:flutter/material.dart';
import 'package:mobile_wastewise/SetorSampah/pilih_bank_sampah.dart';
import 'detail_setor_sampah.dart';
import './pilih_bank_sampah.dart';

void main() {
  runApp(const RiwayatSetorSampah());
}

class RiwayatSetorSampah extends StatelessWidget {
  const RiwayatSetorSampah({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bank Sampah App',
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Poppins',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const RiwayatSetorPage(),
        '/detail': (context) => const DetailSetorSampahPage(),
      },
    );
  }
}

class RiwayatSetorPage extends StatefulWidget {
  const RiwayatSetorPage({Key? key}) : super(key: key);

  @override
  State<RiwayatSetorPage> createState() => _RiwayatSetorPageState();
}

class _RiwayatSetorPageState extends State<RiwayatSetorPage> {
  final List<WasteCollection> collections = [
    WasteCollection(
      bankName: 'Bank Sampah Wiyung',
      date: '2 Februari 2025',
      time: '7:30 WIB',
      weight: 5,
      service: 'Jemput',
      status: 'Selesai',
      points: 100,
    ),
    WasteCollection(
      bankName: 'Bank Sampah Wiyung',
      date: '2 Februari 2025',
      time: '7:30 WIB',
      weight: 5,
      service: 'Jemput',
      status: 'Selesai',
      points: 100,
    ),
    WasteCollection(
      bankName: 'Bank Sampah Wiyung',
      date: '2 Februari 2025',
      time: '7:30 WIB',
      weight: 5,
      service: 'Jemput',
      status: 'Selesai',
      points: 100,
    ),
    WasteCollection(
      bankName: 'Bank Sampah Wiyung',
      date: '2 Februari 2025',
      time: '7:30 WIB',
      weight: 5,
      service: 'Jemput',
      status: 'Selesai',
      points: 100,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6FA),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Riwayat Setor',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3D8D7A),
                    ),
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
                          // child: const Icon(Icons.star, color: Colors.white, size: 16),
                          child:  Image.asset(
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
            ),

            // Tab buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => const PilihBankSampah(),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Setor Sekarang'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3D8D7A),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Riwayat Setor'),
                    ),
                  ),
                ],
              ),
            ),

            // Summary Card
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFAFD7C3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.recycling,
                      color: const Color(0xFF3D8D7A),
                      size: 48,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sampah Terkumpul',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            '308 Kg',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF3D8D7A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Collection History List
            Expanded(
              child: ListView.builder(
                itemCount: collections.length,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  final collection = collections[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with bank name and points
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                collection.bankName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.monetization_on,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${collection.points} Poin',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Date and time
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                collection.date,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                Icons.access_time,
                                size: 14,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                collection.time,
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Details
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Total Berat',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    Text(
                                      '${collection.weight}Kg',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Layanan',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    Text(
                                      collection.service,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF3D8D7A),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Status',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    Text(
                                      collection.status,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF3D8D7A),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 30, // Atur tinggi sesuai kebutuhan
                                child: OutlinedButton(
                                  onPressed: () {
                                    // Navigate to detail page when detail button is clicked
                                    Navigator.pushNamed(context, '/detail');
                                  },
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFF3D8D7A),
                                    side: BorderSide(color: const Color(0xFF3D8D7A)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    backgroundColor: const Color(0xFFD6EFD8),
                                  ),
                                  child: const Text('Detail'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WasteCollection {
  final String bankName;
  final String date;
  final String time;
  final int weight;
  final String service;
  final String status;
  final int points;

  WasteCollection({
    required this.bankName,
    required this.date,
    required this.time,
    required this.weight,
    required this.service,
    required this.status,
    required this.points,
  });
}