import 'package:flutter/material.dart';
import './pilih_sampah.dart';

class SetorSampah extends StatelessWidget {
  const SetorSampah({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF3D8D7A),
        fontFamily: 'Poppins',
      ),
      home: const WasteBankPage(),
    );
  }
}

class WasteBankPage extends StatefulWidget {
  const WasteBankPage({Key? key}) : super(key: key);

  @override
  State<WasteBankPage> createState() => _WasteBankPageState();
}

class _WasteBankPageState extends State<WasteBankPage> {
  int? _selectedIndex;
  int _selectedTabIndex = 0; 
  String searchQuery = "";

 List<Map<String, dynamic>> wasteBanks = [
    {
      "name": "Bank Sampah Wiyung",
      "address": "Jl. Wiyung No 64",
      "distance": 7.0,
      "imagePath": 'assets/default-bank-sampah.png',
    },
    {
      "name": "Bank Sampah Kalijudan",
      "address": "Jl. Kalijudan V No. 33D",
      "distance": 2.8,
      "imagePath": 'assets/default-bank-sampah.png',
    },
    {
      "name": "Bank Sampah Jojoran 1",
      "address": "Jl. Jojoran 1 Blok Z No. 101",
      "distance": 3.9,
      "imagePath": 'assets/default-bank-sampah.png',
    },
    {
      "name": "Bank Sampah Mulyorejo Tengah",
      "address": "Jl. Mulyorejo Tengah No. 67",
      "distance": 3.9,
      "imagePath": 'assets/default-bank-sampah.png',
    },
  ];

  void _onSelectBank(int index) {
    setState(() {
      if (_selectedIndex == index) {
        _selectedIndex = null; // Unselect if the same card is tapped again
      } else {
        _selectedIndex = index; // Select new card
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filter bank sampah berdasarkan teks pencarian
    List<Map<String, dynamic>> filteredBanks = wasteBanks
        .where((bank) => bank["name"].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      body: SafeArea(
        child: Padding(
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
              
              const Text(
                "Pilih Bank Sampah",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Color(0xFF3D8D7A)),
              ),
              const SizedBox(height: 16),

              // Kolom pencarian
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey.shade600),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Cari Bank Sampah...",
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Daftar bank sampah dengan pencarian
              Expanded(
                child: filteredBanks.isNotEmpty
                    ? ListView.builder(
                        itemCount: filteredBanks.length,
                        itemBuilder: (context, index) {
                          int actualIndex = wasteBanks.indexOf(filteredBanks[index]);
                          return GestureDetector(
                            onTap: () => _onSelectBank(actualIndex),
                            child: _buildWasteBankItem(
                              name: filteredBanks[index]["name"],
                              address: filteredBanks[index]["address"],
                              distance: filteredBanks[index]["distance"],
                              imagePath: filteredBanks[index]["imagePath"],
                              isSelected: actualIndex == _selectedIndex,
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Text(
                          "Bank Sampah tidak ditemukan.",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      ),
              ),
              // Bank Sampah Terpilih di Bagian Bawah
              if (_selectedIndex != null) // Only show selected bank if there is one
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3D8D7A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    wasteBanks[_selectedIndex!]["name"],
                                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "${wasteBanks[_selectedIndex!]["distance"]} Km",
                                    style: const TextStyle(fontSize: 16, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (_selectedIndex != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const PilihSampah()),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Silakan pilih bank sampah terlebih dahulu.')),
                                  );
                                }
                              },
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

 Widget _buildWasteBankItem({
    required String name,
    required String address,
    required double distance,
    required bool isSelected,
    required String imagePath,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isSelected ? Colors.teal.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? const Color(0xFF3D8D7A) : Colors.grey.shade200,
          width: isSelected ? 2 : 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Color(0xFFF5F6FA),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: ClipOval(
                child: Image.asset(
                  imagePath,
                  width: 32,
                  height: 32,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        ),
                const SizedBox(height: 4),
                Text(address,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14), 
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        color: Color(0xFF3D8D7A), size: 14),
                    const SizedBox(width: 4),
                    Text("$distance Km",
                        style: const TextStyle(
                            color: Color(0xFF3D8D7A),
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.check_circle,
              color: isSelected ? const Color(0xFF3D8D7A) : Colors.transparent),
        ],
      ),
    );
  }
}