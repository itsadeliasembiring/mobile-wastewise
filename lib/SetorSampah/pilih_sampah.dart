import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../SetorSampah/waste_type.dart';
import '../Providers/points.provider.dart';
import 'detail_pilih_sampah.dart';

class PilihSampah extends StatefulWidget {
  final Function(int)? onTabChanged; // Callback untuk mengubah tab
  
  const PilihSampah({Key? key, this.onTabChanged}) : super(key: key);

  @override
  State<PilihSampah> createState() => _PilihSampahState();
}

class _PilihSampahState extends State<PilihSampah> {
  List<WasteType> _wasteTypes = [];
  Map<String, double> _wasteQuantities = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWasteTypes();
  }

  Future<void> _fetchWasteTypes() async {
    try {
      final response = await Supabase.instance.client.from('sampah').select().neq('id_jenis_sampah', 'J03');
      final fetchedData = response.map((item) => WasteType.fromJson(item)).toList();
      if (mounted) {
        setState(() {
          _wasteTypes = fetchedData;
          for (var wasteType in _wasteTypes) {
            _wasteQuantities[wasteType.name] = 0;
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal memuat jenis sampah: $e'), backgroundColor: Colors.red));
        setState(() { _isLoading = false; });
      }
    }
  }

  void _updateQuantity(String name, double newQuantity) {
    setState(() {
      _wasteQuantities[name] = newQuantity >= 0 ? newQuantity : 0;
    });
  }

  int get totalWasteTypes => _wasteQuantities.values.where((qty) => qty > 0).length;
  double get totalQuantity => _wasteQuantities.values.fold(0.0, (a, b) => a + b);
  double get totalWastePoints {
    double totalPoints = 0.0;
    for (var wasteType in _wasteTypes) {
      totalPoints += (_wasteQuantities[wasteType.name] ?? 0) * wasteType.pointsPerKg;
    }
    return totalPoints;
  }

  void navigateToDetailPage() {
    if (totalWasteTypes == 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pilih dan isi berat minimal satu jenis sampah.'), backgroundColor: Colors.red));
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPilihSampah(
          wasteQuantities: Map.from(_wasteQuantities),
          wasteTypes: _wasteTypes,
          totalWastePoints: totalWastePoints,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pointsProvider = context.watch<PointsProvider>();
    const primaryColor = Color(0xFF3D8D7A);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(pointsProvider, primaryColor),
            _buildTabButtons(context, 0, primaryColor),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Jenis Sampah', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _wasteTypes.length,
                      itemBuilder: (context, index) {
                        final wasteType = _wasteTypes[index];
                        final quantity = _wasteQuantities[wasteType.name] ?? 0;
                        return _buildWasteItemCard(wasteType, quantity, primaryColor);
                      },
                    ),
            ),
            if (!_isLoading && _wasteTypes.isNotEmpty) _buildBottomBar(primaryColor),
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
                // Gunakan callback untuk mengubah tab jika tersedia
                if (widget.onTabChanged != null) {
                  widget.onTabChanged!(1); // 1 untuk tab riwayat
                } else {
                  // Fallback jika tidak ada callback
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

  Widget _buildWasteItemCard(WasteType wasteType, double quantity, Color primaryColor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(wasteType.image, width: 64, height: 64, fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(width: 64, height: 64, color: Colors.grey[200], child: const Icon(Icons.image_not_supported, color: Colors.grey)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(wasteType.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Row(children: [
                    Image.asset('assets/poin.png', width: 14, height: 14),
                    const SizedBox(width: 4),
                    Text('${wasteType.pointsPerKg} Poin/Kg', style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                  ]),
                ],
              ),
            ),
            quantity == 0
                ? OutlinedButton(
                    onPressed: () => _updateQuantity(wasteType.name, 1),
                    style: OutlinedButton.styleFrom(foregroundColor: primaryColor, side: BorderSide(color: primaryColor), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                    child: const Text("Tambah"),
                  )
                : Container(
                    decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        IconButton(icon: const Icon(Icons.remove), onPressed: () => _updateQuantity(wasteType.name, quantity - 1), padding: EdgeInsets.zero, visualDensity: VisualDensity.compact),
                        Text(quantity.toInt().toString(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        IconButton(icon: const Icon(Icons.add), onPressed: () => _updateQuantity(wasteType.name, quantity + 1), padding: EdgeInsets.zero, visualDensity: VisualDensity.compact),
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }
  
  Widget _buildBottomBar(Color primaryColor) {
    return Container(
      padding: const EdgeInsets.all(16).copyWith(top: 12),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${totalWastePoints.toStringAsFixed(0)} Poin', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 2),
              Text('$totalWasteTypes Jenis | ${totalQuantity.toStringAsFixed(1)} kg', style: const TextStyle(fontSize: 14, color: Colors.white70)),
            ],
          ),
          ElevatedButton(
            onPressed: navigateToDetailPage,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Lanjut', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}