import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../SetorSampah/waste_type.dart';
import '../Providers/points.provider.dart';
import 'pilih_alamat.dart';
import 'kode_verifikasi.dart';

class DetailPilihSampah extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final selectedWaste = wasteTypes.where((waste) => (wasteQuantities[waste.name] ?? 0) > 0).toList();
    final pointsProvider = context.watch<PointsProvider>();
    const primaryColor = Color(0xFF3D8D7A);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(pointsProvider, primaryColor),
            _buildTabButtons(context, 0, primaryColor),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  _buildSelectedWasteSection(context, selectedWaste, wasteQuantities, primaryColor),
                  const SizedBox(height: 16),
                  _buildIncomeCard(context, selectedWaste, wasteQuantities, primaryColor),
                  const SizedBox(height: 24),
                  const Text("Pilih Layanan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87), textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  _buildServiceButtons(context, wasteQuantities, wasteTypes, totalWastePoints, primaryColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildHeader(PointsProvider provider, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Setor Sampah', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor)),
           Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(color: const Color(0xFFA3D1C6), borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  Image.asset('assets/poin.png', width: 16, height: 16),
                  const SizedBox(width: 6),
                  provider.isLoading
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text("${provider.totalPoints} Poin", style: TextStyle(color: primaryColor, fontWeight: FontWeight.w500, fontSize: 16)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTabButtons(BuildContext context, int activeIndex, Color primaryColor) {
    ButtonStyle activeTabStyle() => ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    );

    ButtonStyle inactiveTabStyle() => ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black54,
        elevation: 0,
    );
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(25)),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: activeIndex == 0 ? activeTabStyle() : inactiveTabStyle(),
              child: const Text('Setor Sekarang'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                 if (activeIndex != 1) {
                  Navigator.pushNamed(context, '/riwayat-setor');
                }
              },
              style: activeIndex == 1 ? activeTabStyle() : inactiveTabStyle(),
              child: const Text('Riwayat Setor'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedWasteSection(BuildContext context, List<WasteType> selectedWaste, Map<String, double> quantities, Color primaryColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Sampah Yang Di Setor", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(foregroundColor: primaryColor, side: BorderSide(color: primaryColor), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
              child: const Text("Ubah"),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...selectedWaste.map((wasteType) => Card(
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            leading: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(wasteType.image, width: 50, height: 50, fit: BoxFit.cover)),
            title: Text(wasteType.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Row(children: [
              Image.asset('assets/poin.png', width: 14, height: 14),
              const SizedBox(width: 4),
              Text('${wasteType.pointsPerKg} Poin/Kg'),
            ]),
            trailing: Container(
                    decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          child: Text(
                            (quantities[wasteType.name] ?? 0).toInt().toString(), 
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                          ),
                        ),
                      ],
                    ),
                  )
          )
        )),
      ],
    );
  }

  Widget _buildIncomeCard(BuildContext context, List<WasteType> selectedWaste, Map<String, double> quantities, Color primaryColor) {
    double totalKg = selectedWaste.fold(0.0, (sum, item) => sum + (quantities[item.name] ?? 0));
    double totalPoin = selectedWaste.fold(0.0, (sum, item) => sum + (quantities[item.name] ?? 0) * item.pointsPerKg);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(children: [
              Image.asset('assets/poin.png', width: 20, height: 20),
              const SizedBox(width: 8),
              const Text('Perkiraan Pendapatan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ]),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Berat Total: ${totalKg.toStringAsFixed(1)} kg', style: const TextStyle(color: Colors.grey)),
              Text('Jenis Sampah: ${selectedWaste.length}', style: const TextStyle(color: Colors.grey)),
            ]),
            const Divider(height: 20),
            ...selectedWaste.map((item) {
              final points = (quantities[item.name] ?? 0) * item.pointsPerKg;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item.name),
                    Text(points.toInt().toString()),
                  ],
                ),
              );
            }),
            const Divider(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              const Text('Kamu Mendapat', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('${totalPoin.toInt()} Poin', style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceButtons(BuildContext context, Map<String, double> quantities, List<WasteType> types, double points, Color primaryColor) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(
              builder: (context) => PilihAlamat(wasteQuantities: quantities, wasteTypes: types, totalWastePoints: points),
            )),
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text("Jemput Sampah"),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(
              builder: (context) => HalamanKodeVerifikasi(wasteQuantities: quantities, wasteTypes: types, totalWastePoints: points),
            )),
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text("Setor Langsung"),
          ),
        ),
      ],
    );
  }
}