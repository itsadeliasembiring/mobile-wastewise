import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_wastewise/Providers/points.provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import './riwayat_poin.dart';
import './detail_donasi.dart';

// Model EcoItem tidak berubah
class EcoItem {
  final String id;
  final String title;
  final int points;
  final String imageAsset;
  int stock;
  final String? description;

  EcoItem({
    required this.id,
    required this.title,
    required this.points,
    required this.imageAsset,
    required this.stock,
    this.description,
  });

  factory EcoItem.fromJson(Map<String, dynamic> json) {
    return EcoItem(
      id: json['id_barang'],
      title: json['nama_barang'],
      points: json['bobot_poin'],
      imageAsset: json['foto'] ?? 'assets/fallback.png',
      stock: json['stok'],
      description: json['deskripsi_barang'],
    );
  }
}

class TukarPoin extends StatefulWidget {
  const TukarPoin({super.key});

  @override
  State<TukarPoin> createState() => _TukarPoinState();
}

class _TukarPoinState extends State<TukarPoin> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Donation> _donations = [];
  List<EcoItem> _ecoItems = [];
  bool _isLoading = true;
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData();
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    
    try {
      await Provider.of<PointsProvider>(context, listen: false).fetchPoints(forceRefresh: true);
      
      final results = await Future.wait([
        _supabase.from('donasi').select().order('nama_donasi'),
        _supabase.from('barang').select().gt('stok', 0).order('nama_barang'),
      ]);

      if (mounted) {
        final donationData = results[0] as List;
        final ecoItemsData = results[1] as List;

        setState(() {
          _donations = donationData.map((item) => Donation.fromJson(item)).toList();
          _ecoItems = ecoItemsData.map((item) => EcoItem.fromJson(item)).toList();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat data: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _processExchange(EcoItem item, PointsProvider pointsProvider) async {
    if (!mounted) return;
    // Tampilkan loading indicator di atas bottom sheet jika perlu
    // Untuk saat ini, loading di handle di halaman utama
    setState(() { _isLoading = true; });

    try {
      final redemptionCode = await pointsProvider.exchangeItem(
        itemId: item.id,
        points: item.points,
      );

      if (mounted) {
        await _refreshData(); 
        _showRedemptionCodeBottomSheet(item.title, item.points, redemptionCode);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() { _isLoading = false; });
      }
    }
  }

  // --- PERUBAHAN UTAMA DI SINI ---
  // Mengganti showDialog dengan showModalBottomSheet yang berisi widget custom
  void _showTukarDialog(EcoItem item, PointsProvider pointsProvider) {
    if (pointsProvider.totalPoints < item.points) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Poin Anda tidak cukup.'), backgroundColor: Colors.orange));
      return;
    }
    if (item.stock <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Stok barang sudah habis.'), backgroundColor: Colors.red));
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // Latar belakang transparan agar border radius terlihat
      builder: (context) {
        return KonfirmasiPenukaranSheet(
          item: item,
          pointsProvider: pointsProvider,
          onTukar: () {
            Navigator.of(context).pop(); // Tutup bottom sheet
            _processExchange(item, pointsProvider); // Lanjutkan proses
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PointsProvider>(
      builder: (context, pointsProvider, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF5F6FA),
          body: SafeArea(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _buildHeader(pointsProvider),
                      const SizedBox(height: 16),
                      _buildTabBar(),
                      const SizedBox(height: 16),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            RefreshIndicator(
                                onRefresh: _refreshData,
                                color: const Color(0xFF3D8D7A),
                                child: _buildTukarPoinTab(pointsProvider)),
                            const RiwayatPoin(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (_isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.1),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF3D8D7A),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Sisa widget (buildHeader, buildTabBar, dll.) tidak ada perubahan
  // Pastikan Anda menempelkan method-method UI tersebut di sini.
  Widget _buildHeader(PointsProvider pointsProvider) {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Tukar Poin',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF3D8D7A)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFA3D1C6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Image.asset('assets/poin.png', width: 20, height: 20),
                const SizedBox(width: 8),
                Text(
                  "${pointsProvider.totalPoints} Poin",
                  style: const TextStyle(color: Color(0xFF3D8D7A), fontWeight: FontWeight.w500, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 5)],
      ),
      child: TabBar(
        controller: _tabController,
        tabs: const [Tab(text: 'Tukar Poin'), Tab(text: 'Riwayat Tukar')],
        labelColor: Colors.white,
        unselectedLabelColor: Colors.black,
        indicator: BoxDecoration(
          color: const Color(0xFF3D8D7A),
          borderRadius: BorderRadius.circular(20),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
      ),
    );
  }

  Widget _buildTukarPoinTab(PointsProvider pointsProvider) {
    if (_isLoading && _ecoItems.isEmpty && _donations.isEmpty) {
      return const SizedBox.shrink(); // Jangan tampilkan apa-apa selagi loading utama
    }
    
    return ListView(
      padding: const EdgeInsets.only(top: 16),
      children: [
        if (_donations.isNotEmpty) ...[
          const Text('Donasi', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF3D8D7A))),
          const SizedBox(height: 16),
          ..._donations.map((donation) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildDonationItem(donation),
              )),
          const SizedBox(height: 24),
        ],
        const Text('Barang Ramah Lingkungan', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF3D8D7A))),
        const SizedBox(height: 16),
        if (_ecoItems.isEmpty && !_isLoading)
          const Center(child: Padding(padding: EdgeInsets.all(20), child: Text('Tidak ada barang tersedia saat ini', style: TextStyle(color: Colors.grey)))),
        ..._ecoItems.map((item) => _buildEcoItem(item, pointsProvider)),
      ],
    );
  }

  Widget _buildDonationItem(Donation donation) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: SizedBox(
              width: double.infinity,
              height: 120,
              child: Image.network(
                donation.imageAsset,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.asset('assets/donation-default.png', fit: BoxFit.cover),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(donation.title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 16)),
                      if (donation.description != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          donation.description!,
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 4),
                      Text(
                        'Total donasi: ${donation.totalDonation} poin',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailDonasi(donation: donation),
                      ),
                    ).then((_) => _refreshData());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF609966),
                    side: const BorderSide(color: Color(0xFF609966)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    minimumSize: const Size(0, 35),
                  ),
                  child: const Text('Donasi'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEcoItem(EcoItem item, PointsProvider pointsProvider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 5)],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 60,
              height: 60,
              child: Image.network(
                item.imageAsset,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.asset('assets/fallback.png', fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Image.asset('assets/poin.png', width: 18, height: 18),
                    const SizedBox(width: 4),
                    Text('${item.points} poin', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Stok: ${item.stock}',
                  style: TextStyle(
                    color: item.stock > 5 ? Colors.green : (item.stock > 0 ? Colors.orange : Colors.red),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: item.stock > 0 ? () => _showTukarDialog(item, pointsProvider) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF609966),
              side: const BorderSide(color: Color(0xFF609966)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              minimumSize: const Size(0, 35),
            ),
            child: Text(item.stock > 0 ? 'Tukar' : 'Habis'),
          ),
        ],
      ),
    );
  }

  void _showRedemptionCodeBottomSheet(String itemTitle, int points, String code) {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 60),
              const SizedBox(height: 16),
              const Text('Penukaran Berhasil!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('Anda berhasil menukar $points poin untuk "$itemTitle"', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
              const SizedBox(height: 24),
              const Text('Kode Redeem Anda:', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(code, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2)),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: code));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Kode redeem berhasil disalin')),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Selesai'),
              ),
            ],
          ),
        );
      },
    );
  }
}

// --- WIDGET BARU UNTUK BOTTOM SHEET ---
class KonfirmasiPenukaranSheet extends StatelessWidget {
  final EcoItem item;
  final PointsProvider pointsProvider;
  final VoidCallback onTukar;

  const KonfirmasiPenukaranSheet({
    super.key,
    required this.item,
    required this.pointsProvider,
    required this.onTukar,
  });

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF3D8D7A);
    final sisaPoin = pointsProvider.totalPoints - item.points;

    return Container(
      // Dekorasi untuk membuat sudut atas membulat
      decoration: const BoxDecoration(
        color: Color(0xFFF5F6FA), // Warna latar belakang sheet
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: primaryColor),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: Text(
                    'Konfirmasi Penukaran',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 48), // Spacer agar judul tetap di tengah
              ],
            ),
            const SizedBox(height: 24),

            // Info Item
            _buildInfoCard(
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item.imageAsset,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (ctx, err, st) => Container(
                        width: 50,
                        height: 50,
                        color: Colors.grey[200],
                        child: const Icon(Icons.image_not_supported),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.title, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Image.asset('assets/poin.png', width: 20, height: 20),
                          const SizedBox(width: 6),
                          Text('${item.points} poin', style: GoogleFonts.inter(fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Rincian Poin
            _buildInfoCard(
              child: Column(
                children: [
                  _buildPoinRow('Poin Anda saat ini:', '${pointsProvider.totalPoints} poin', color: Colors.black),
                  const SizedBox(height: 12),
                  _buildPoinRow('Akan dikurangi:', '${item.points} poin', color: Colors.red),
                  const Divider(height: 24, thickness: 1),
                  _buildPoinRow('Sisa poin:', '$sisaPoin poin', color: primaryColor, isBold: true),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Teks Bantuan
            Text(
              'Setelah penukaran berhasil, Anda akan mendapatkan kode redeem untuk mengambil barang.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),

            // Tombol Aksi
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Batal', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.grey[700])),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onTukar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                    ),
                    child: Text('Tukar Sekarang', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: child,
    );
  }

  Widget _buildPoinRow(String label, String value, {required Color color, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 14, color: Colors.grey[700])),
        Text(value, style: GoogleFonts.inter(fontSize: 14, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: color)),
      ],
    );
  }
}
