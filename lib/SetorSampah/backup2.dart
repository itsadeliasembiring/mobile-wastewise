import 'package:flutter/material.dart';

class DetailPilihSampah extends StatefulWidget {
  const DetailPilihSampah({Key? key}) : super(key: key);

  @override
  State<DetailPilihSampah> createState() => _DetailPilihSampahState();
}

class _DetailPilihSampahState extends State<DetailPilihSampah> {
  // List of waste types with their details
  final List<Map<String, dynamic>> wasteTypes = [
    {
      "name": "Kertas",
      "points": 110,
      "unit": "Kg",
      "imagePath": 'assets/kertas.png',
      "quantity": 2,
    },
    {
      "name": "Plastik",
      "points": 80,
      "unit": "Kg",
      "imagePath": 'assets/plastik.png',
      "quantity": 0,
    },
    {
      "name": "Logam",
      "points": 150,
      "unit": "Kg",
      "imagePath": 'assets/logam.png',
      "quantity": 0,
    },
    {
      "name": "Kaca",
      "points": 100,
      "unit": "Kg",
      "imagePath": 'assets/kaca.png',
      "quantity": 0,
    },
    {
      "name": "Elektronik",
      "points": 200,
      "unit": "Unit",
      "imagePath": 'assets/elektronik.png',
      "quantity": 0,
    },
  ];

  // Calculate total weight and number of types
  int get totalWeight {
    int total = 0;
    for (var item in wasteTypes) {
      total += item["quantity"] as int;
    }
    return total;
  }

  int get typesCount {
    int count = 0;
    for (var item in wasteTypes) {
      if ((item["quantity"] as int) > 0) {
        count++;
      }
    }
    return count;
  }

  // Calculate total points earned
  int get totalPoints {
    int total = 0;
    for (var item in wasteTypes) {
      total += (item["points"] as int) * (item["quantity"] as int);
    }
    return total;
  }

  // Increase or decrease quantity of a waste type
  void updateQuantity(int index, bool increase) {
    setState(() {
      if (increase) {
        wasteTypes[index]["quantity"] = (wasteTypes[index]["quantity"] as int) + 1;
      } else {
        if ((wasteTypes[index]["quantity"] as int) > 0) {
          wasteTypes[index]["quantity"] = (wasteTypes[index]["quantity"] as int) - 1;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with point display
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
                        const Text("308 Poin", 
                          style: TextStyle(
                            color: Color(0xFF3D8D7A), 
                            fontWeight: FontWeight.w500, 
                            fontSize: 16
                          )
                        ),
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
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3D8D7A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20), 
                            bottomLeft: Radius.circular(20)
                          ),
                        ),
                      ),
                      child: const Text("Setor Sekarang"),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[200],
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20), 
                            bottomRight: Radius.circular(20)
                          ),
                        ),
                      ),
                      child: const Text("Riwayat Setor"),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),
              
              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Sampah Yang Di Setor",
                    style: TextStyle(
                      fontSize: 22, 
                      fontWeight: FontWeight.w500, 
                      color: Color(0xFF3D8D7A)
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5F2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Ubah",
                      style: TextStyle(
                        color: Color(0xFF3D8D7A),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),

              // List of waste items
              Expanded(
                child: ListView.builder(
                  itemCount: wasteTypes.length,
                  itemBuilder: (context, index) {
                    return _buildWasteItem(index);
                  },
                ),
              ),

              // Estimated earnings
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(12),
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
                          "Berat Total: $totalWeight kg",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "Jenis Sampah: $typesCount",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
               
                    // Row(
                    //   children: List.generate(150~/10, (index) => Expanded(
                    //   child: Container(
                    //     color: index%2==0?Colors.transparent
                    //     :Colors.grey,
                    //     height: 2,
                    //   ),
                    //   )),
                    // ),
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
                          "$totalPoints Poin",
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

              const SizedBox(height: 16),

              // Service options
              const Text(
                "Pilih Layanan",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF3D8D7A),
                ),
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
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
                      onPressed: () {},
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
              
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWasteItem(int index) {
    final waste = wasteTypes[index];
    final bool hasQuantity = (waste["quantity"] as int) > 0;
    
    // Only show items that have a quantity greater than 0
    if (!hasQuantity) return const SizedBox.shrink();
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F6FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Image.asset(
                waste["imagePath"],
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  waste["name"],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.monetization_on,
                      color: Colors.amber,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "${waste["points"]} Poin/${waste["unit"]}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              InkWell(
                onTap: () => updateQuantity(index, false),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5F2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.remove,
                    color: Color(0xFF3D8D7A),
                    size: 18,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "${waste["quantity"]}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              InkWell(
                onTap: () => updateQuantity(index, true),
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3D8D7A),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
