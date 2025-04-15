import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import './detail_pilih_sampah.dart';
import './waste_type.dart';

void main() {
  runApp(const PilihSampah());
}

class PilihSampah extends StatelessWidget {
  const PilihSampah({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6FA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); 
          },
        ),
        title: const Text(
          "Pilih Sampah",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF3D8D7A),
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: const WasteCollectionPage(),
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
  int _selectedTabIndex = 0; 
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
        text: '',
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

  void navigateToDetailPage() {
    if (totalWasteTypes == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Silakan pilih minimal satu jenis sampah'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPilihSampah(
          wasteQuantities: Map.from(wasteQuantities),
          wasteTypes: wasteTypes,
          totalWastePoints: totalWastePoints,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // Title
              const Text(
                "Jenis Sampah Yang Dapat Disetor",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Color(0xFF3D8D7A)),
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
                                wasteType.image,
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
                              width: 60,
                              child: TextField(
                                keyboardType: TextInputType.numberWithOptions(decimal: true),
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                controller: _controllers[wasteType.name],
                                onChanged: (value) {
                                  updateQuantity(wasteType.name, value);
                                },
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')), 
                                ],
                                decoration: InputDecoration(
                                  hintText: '0',
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
                            const SizedBox(width: 8),
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
                        const SizedBox(height: 4), 
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
                      onPressed: navigateToDetailPage, 
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