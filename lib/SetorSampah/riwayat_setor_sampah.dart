import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../Providers/points.provider.dart';
import '../Menu/menu.dart';

class WasteCollection {
  final String idSetor;
  final String bankName;
  final DateTime dateTime;
  final String service;
  final String status;
  final int points;
  final double weight;

  WasteCollection({
    required this.idSetor,
    required this.bankName,
    required this.dateTime,
    required this.service,
    required this.status,
    required this.points,
    required this.weight,
  });

  String get formattedDate => DateFormat('d MMMM yyyy', 'id_ID').format(dateTime);
  String get formattedTime => DateFormat('HH:mm').format(dateTime);

  factory WasteCollection.fromJson(Map<String, dynamic> json) {
    return WasteCollection(
      idSetor: json['id_setor'],
      bankName: json['bank_sampah']?['nama_bank_sampah'] ?? 'Bank Sampah',
      dateTime: DateTime.parse(json['waktu_setor']),
      service: json['jenis_layanan']?['nama_layanan'] ?? 'N/A',
      status: json['status'] ?? 'N/A',
      points: json['total_poin'] ?? 0,
      weight: (json['total_berat'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class RiwayatSetorSampah extends StatefulWidget {
  const RiwayatSetorSampah({Key? key}) : super(key: key);

  @override
  State<RiwayatSetorSampah> createState() => _RiwayatSetorSampahState();
}

class _RiwayatSetorSampahState extends State<RiwayatSetorSampah> {
  late Future<List<WasteCollection>> _historyFuture;
  final _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _historyFuture = _fetchHistory();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PointsProvider>().fetchPoints(forceRefresh: true);
    });
  }

  Future<List<WasteCollection>> _fetchHistory() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return [];
    try {
      final response = await _supabase
          .from('setor_sampah')
          .select('*, bank_sampah(nama_bank_sampah), jenis_layanan(nama_layanan)')
          .eq('id_pengguna', userId)
          .order('waktu_setor', ascending: false);
      return response.map((item) => WasteCollection.fromJson(item)).toList();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Gagal memuat riwayat: $e'),
          backgroundColor: Colors.red,
        ));
      }
      return [];
    }
  }

  Future<void> _refreshData() async {
    await context.read<PointsProvider>().fetchPoints(forceRefresh: true);
    setState(() {
      _historyFuture = _fetchHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final pointsProvider = context.watch<PointsProvider>();
    const primaryColor = Color(0xFF3D8D7A);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: Column(
            children: [
              _buildHeader(pointsProvider, primaryColor),
              _buildTabButtons(context, 1, primaryColor), // 1 menandakan tab 'Riwayat Setor' aktif
              Expanded(
                child: FutureBuilder<List<WasteCollection>>(
                  future: _historyFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text("Terjadi Error: ${snapshot.error}"));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("Belum ada riwayat setoran."));
                    }

                    final historyList = snapshot.data!;
                    final double totalKg = historyList.fold(0.0, (sum, item) => sum + item.weight);

                    return ListView(
                      padding: const EdgeInsets.all(0),
                      children: [
                        _buildSummaryCard(totalKg, primaryColor),
                        ...historyList.map((item) => _buildHistoryCard(item, primaryColor)).toList(),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
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
          Text('Riwayat Setor', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor)),
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
              onPressed: () {
                MenuStateProvider.of(context)?.changeSetorSampahTab(0);
              },
              style: activeIndex == 0 ? activeTabStyle() : inactiveTabStyle(),
              child: const Text('Setor Sampah'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                if (activeIndex == 1) {
                  _refreshData();
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
  
  Widget _buildSummaryCard(double totalKg, Color primaryColor) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: const Color(0xFFAFD7C3), borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Icon(Icons.recycling, color: primaryColor, size: 48),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Sampah Terkumpul', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                  Text('${totalKg.toStringAsFixed(1)} Kg', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: primaryColor)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(WasteCollection item, Color primaryColor) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item.bankName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.amber.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      Image.asset('assets/poin.png', width: 14, height: 14),
                      const SizedBox(width: 4),
                      Text('${item.points} Poin', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(children: [
              Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade700),
              const SizedBox(width: 4),
              Text(item.formattedDate, style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
              const SizedBox(width: 12),
              Icon(Icons.access_time, size: 14, color: Colors.grey.shade700),
              const SizedBox(width: 4),
              Text(item.formattedTime, style: TextStyle(color: Colors.grey.shade700, fontSize: 12)),
            ]),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoColumn('Total Berat', '${item.weight}Kg'),
                _buildInfoColumn('Layanan', item.service, color: primaryColor),
                _buildInfoColumn('Status', item.status, color: primaryColor),
                SizedBox(
                  height: 32,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pushNamed(context, '/detail-setor', arguments: item.idSetor),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primaryColor,
                      side: BorderSide(color: primaryColor),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text('Detail'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildInfoColumn(String title, String value, {Color color = Colors.black}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}