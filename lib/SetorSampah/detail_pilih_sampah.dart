import 'package:flutter/material.dart';
import 'package:mobile_wastewise/SetorSampah/barcode-jemput.dart';
import 'waste_type.dart';
import 'pilih_alamat.dart';

class DetailPilihSampah extends StatefulWidget {
  final Map<String, double> wasteQuantities;
  final List<WasteType> wasteTypes;
  final double totalWastePoints;

  const DetailPilihSampah({
    Key? key,
    required this.wasteQuantities,
    required this.wasteTypes,
    required this.totalWastePoints,
  }) : super(key: key);

  @override
  State<DetailPilihSampah> createState() => _DetailPilihSampahState();
}

class _DetailPilihSampahState extends State<DetailPilihSampah> {
  @override
  Widget build(BuildContext context) {
    final selectedWaste = widget.wasteTypes
        .where((waste) => (widget.wasteQuantities[waste.name] ?? 0) > 0)
        .toList();

    final totalQuantity = widget.wasteQuantities.values.fold(
        0.0, (previousValue, element) => previousValue + element);

    return Scaffold(
      backgroundColor: Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text(
          "Detail Setor Sampah",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF3D8D7A),
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView( 
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Sampah Yang Disetor",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF3D8D7A),
                  ),
                ),
                const SizedBox(height: 12),

                ListView.builder(
                  itemCount: selectedWaste.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(), 
                  itemBuilder: (context, index) {
                    final wasteType = selectedWaste[index];
                    final quantity = widget.wasteQuantities[wasteType.name] ?? 0;
                    final points = quantity * wasteType.pointsPerKg;

                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                wasteType.image,
                                width: 64,
                                height: 64,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  width: 64,
                                  height: 64,
                                  color: Colors.grey[300],
                                  child: const Center(
                                    child: Text(
                                      'Image not found',
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 145, 145, 145)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

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
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Berat: ${quantity % 1 == 0 ? quantity.toInt() : quantity.toStringAsFixed(2)} kg",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey[600]),
                                      ),
                                      Row(
                                        children: [
                                          Image.asset(
                                            'assets/poin.png',
                                            width: 16,
                                            height: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            "${points.toInt()} Poin",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF3D8D7A),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Divider(
                  color: const Color.fromARGB(255, 231, 231, 231),
                  thickness: 1,
                ),
                
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/poin.png',
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Perkiraan Pendapatan",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Berat Total: ${totalQuantity % 1 == 0 ? totalQuantity.toInt() : totalQuantity.toStringAsFixed(2)} kg",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "Jenis Sampah: ${selectedWaste.length} Jenis",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Kamu Mendapat",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "${widget.totalWastePoints.toStringAsFixed(0)} Poin",
                            style: const TextStyle(
                              color: Color(0xFF3D8D7A),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                const Text(
                  "Pilih Layanan",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Color(0xFF3D8D7A)),
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PilihAlamat(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3D8D7A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Jemput Sampah",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ScanBarcode()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3D8D7A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Setor Langsung",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}