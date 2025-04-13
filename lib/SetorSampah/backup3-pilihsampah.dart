import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import this package for input formatters

// Import the DetailPilihSampah class
import './detail_pilih_sampah.dart';
// Import the shared WasteType class
import './waste_type.dart';

void main() {
  runApp(const PilihSampah());
}

class PilihSampah extends StatelessWidget {
  const PilihSampah({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: 'Roboto',
      ),
      home: const WasteCollectionPage(),
    );
  }
}

class WasteCollectionPage extends StatefulWidget {
  const WasteCollectionPage({Key? key}) : super(key: key);

  @override
  State<WasteCollectionPage> createState() => _WasteCollectionPageState();
}

class _WasteCollectionPageState extends State<WasteCollectionPage> {
  int totalPoints = 308;
  int _selectedTabIndex = 0; // Define the selected tab index
  Map<String, double> wasteQuantities = {
    'Kertas': 0,
    'Plastik': 0,
    'Sampah Makanan': 0,
    'Minyak Jelantah': 0,
    'Kaleng': 0,
  };

  List<WasteType> wasteTypes = [
    WasteType(
      name: 'Plastik',
      image: 'assets/gambar-sampah/plastik.png',
      pointsPerKg: 10,
    ),
    WasteType(
      name: 'Kertas',
      image: 'assets/gambar-sampah/kertas.png',
      pointsPerKg: 110,
    ),
    WasteType(
      name: 'Sampah Makanan',
      image: 'assets/gambar-sampah/sampah-makanan.png',
      pointsPerKg: 110,
    ),
    WasteType(
      name: 'Minyak Jelantah',
      image: 'assets/gambar-sampah/minyak-jelantah.png',
      pointsPerKg: 110,
    ),
    WasteType(
      name: 'Kaleng',
      image: 'assets/gambar-sampah/kaleng.png',
      pointsPerKg: 110,
    ),
  ];

  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    for (var wasteType in wasteTypes) {
      _controllers[wasteType.name] = TextEditingController(
        text: (wasteQuantities[wasteType.name] ?? 0).toInt().toString(),
      );
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  int get totalWasteTypes {
    return wasteQuantities.values.where((qty) => qty > 0).length;
  }

  double get totalQuantity {
    return wasteQuantities.values.reduce((a, b) => a + b);
  }

  double get totalWastePoints {
    double totalPoints = 0.0;
    for (var wasteType in wasteTypes) {
      totalPoints += (wasteQuantities[wasteType.name] ?? 0) * wasteType.pointsPerKg;
    }
    return totalPoints;
  }

  void updateQuantity(String wasteName, String value) {
    setState(() {
      double? newValue = double.tryParse(value);
      wasteQuantities[wasteName] = (newValue != null && newValue >= 0) ? newValue : 0.0;
    });
  }

  // Method to navigate to the detail page
  void navigateToDetailPage() {
    // Check if any waste is selected
    if (totalWasteTypes == 0) {
      // Show a message if no waste is selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih minimal satu jenis sampah'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Navigate to the detail page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPilihSampah(
          wasteQuantities: Map.from(wasteQuantities), // Pass a copy of the waste quantities
          wasteTypes: wasteTypes,
          totalWastePoints: totalWastePoints,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with total points
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
                        Text("100 Poin", style: const TextStyle(color: Color(0xFF3D8D7A), fontWeight: FontWeight.w500, fontSize: 16)),
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

              const SizedBox(height: 16),

              // Title
              const Text(
                'Jenis Sampah',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3D8D7A),
                ),
              ),
              const SizedBox(height: 12),

              // Waste type list
              Expanded(
                child: ListView.builder(
                  itemCount: wasteTypes.length,
                  itemBuilder: (context, index) {
                    final wasteType = wasteTypes[index];
                    final quantity = wasteQuantities[wasteType.name] ?? 0;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            // Waste Image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                wasteType.image, // Use the main image path here
                                width: 64,
                                height: 64,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: 64,
                                  height: 64,
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: Text(
                                      'Image not found',
                                      style: TextStyle(color: Color.fromARGB(255, 145, 145, 145)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Waste Information
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    wasteType.name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/poin.png',
                                        width: 16,
                                        height: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${wasteType.pointsPerKg} Poin/Kg',
                                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Input Quantity with TextField
                            SizedBox(
                              width: 60, // Input width
                              child: TextField(
                                keyboardType: TextInputType.numberWithOptions(decimal: true), // Allow decimal input
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                controller: _controllers[wasteType.name],
                                onChanged: (value) {
                                  updateQuantity(wasteType.name, value);
                                },
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')), // Allow digits and decimal point
                                ],
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(
                                      color: Color(0xFF3D8D7A), 
                                      width: 2.0
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 4),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Bottom bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF3D8D7A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/poin.png',
                              width: 20,
                              height: 20,
                            ),
                            const SizedBox(width: 8), // Jarak antara gambar dan teks
                            Text(
                              '${totalWastePoints.toStringAsFixed(0)} Poin',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4), // Jarak antara poin dan detail lainnya
                        Text(
                          '$totalWasteTypes Jenis | ${totalQuantity % 1 == 0 ? totalQuantity.toInt() : totalQuantity.toStringAsFixed(2)} kg',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: navigateToDetailPage, // Call the navigation method here
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF3D8D7A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 7),
                      ),
                      child: const Text('Lanjut'),
                    ),
                  ],
                ),
              ),  
            ],
          ),
        ),
      ),
    );
  }
}