import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DetailSetorSampah extends StatelessWidget {
  final String? idSetor;

  const DetailSetorSampah({Key? key, this.idSetor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final id = idSetor ?? ModalRoute.of(context)!.settings.arguments as String?;
    if (id == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('ID Transaksi tidak ditemukan.')),
      );
    }
    return DetailSetorSampahPage(idSetor: id);
  }
}

class DetailSetorSampahPage extends StatefulWidget {
  final String idSetor;
  const DetailSetorSampahPage({Key? key, required this.idSetor}) : super(key: key);

  @override
  State<DetailSetorSampahPage> createState() => _DetailSetorSampahPageState();
}

class _DetailSetorSampahPageState extends State<DetailSetorSampahPage> {
  late Future<Map<String, dynamic>?> _detailsFuture;

  @override
  void initState() {
    super.initState();
    _detailsFuture = _fetchTransactionDetails();
  }

  /// Mengambil detail lengkap transaksi dengan error handling yang lebih baik
  Future<Map<String, dynamic>?> _fetchTransactionDetails() async {
    try {
      print('Fetching transaction details for ID: ${widget.idSetor}');
      
      // Periksa status auth user
      final user = Supabase.instance.client.auth.currentUser;
      print('Current user: ${user?.id}');
      
      if (user == null) {
        throw Exception('User tidak terautentikasi. Silakan login terlebih dahulu.');
      }

      // Langkah 1: Ambil data transaksi utama dengan filter user
      final mainResponse = await Supabase.instance.client
          .from('setor_sampah')
          .select('''
            id_setor,
            waktu_setor,
            total_berat,
            total_poin,
            lokasi_pengumpulan,
            waktu_pengumpulan,
            status,
            catatan,
            bank_sampah!inner(nama_bank_sampah, detail_alamat),
            jenis_layanan!inner(nama_layanan)
          ''')
          .eq('id_setor', widget.idSetor)
          .eq('id_pengguna', user.id)  // Filter berdasarkan user yang login
          .maybeSingle();

      if (mainResponse == null) {
        print('Main transaction not found for user ${user.id}');
        return null;
      }

      print('Main response: $mainResponse');

      // Langkah 2: Ambil detail setor secara terpisah
      final detailResponse = await Supabase.instance.client
          .from('detail_setor')
          .select('''
            id_detail,
            berat_kg,
            sampah!inner(nama_sampah, bobot_poin)
          ''')
          .eq('id_setor', widget.idSetor);

      print('Detail response: $detailResponse');

      // Gabungkan data
      final result = Map<String, dynamic>.from(mainResponse);
      result['detail_setor'] = detailResponse;

      return result;

    } on PostgrestException catch (e) {
      print('Supabase error: ${e.message}');
      print('Error details: ${e.details}');
      print('Error hint: ${e.hint}');
      print('Error code: ${e.code}');
      
      if (e.message.contains('unrecognized configuration parameter')) {
        throw Exception('Konfigurasi database bermasalah. Hubungi administrator.');
      } else if (e.message.contains('permission denied') || e.message.contains('RLS')) {
        throw Exception('Tidak memiliki akses untuk melihat data ini.');
      } else if (e.code == 'PGRST116') {
        throw Exception('Data tidak ditemukan atau tidak memiliki akses.');
      }
      
      throw Exception('Database error: ${e.message}');
    } catch (e) {
      print('General error: $e');
      debugPrint('Error fetching transaction details: $e');
      
      if (e.toString().contains('tidak terautentikasi')) {
        rethrow;
      }
      
      throw Exception('Gagal menghubungi server. Periksa koneksi Anda.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F6FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          // DIPERBAIKI: Gunakan pop() untuk navigasi back yang aman
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Detail Setor Sampah', style: TextStyle(color: Color(0xFF3D8D7A), fontWeight: FontWeight.bold)),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _detailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print('FutureBuilder error: ${snapshot.error}');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    "Error: ${snapshot.error}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _detailsFuture = _fetchTransactionDetails();
                      });
                    },
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text('Detail transaksi ID "${widget.idSetor}" tidak ditemukan.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    // DIPERBAIKI: Navigasi yang lebih aman
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Kembali'),
                  ),
                ],
              ),
            );
          }

          final data = snapshot.data!;
          final items = (data['detail_setor'] as List?) ?? [];
          
          // Parse waktu dengan handling error
          DateTime? dateTime;
          try {
            if (data['waktu_setor'] != null) {
              dateTime = DateTime.parse(data['waktu_setor']);
            }
          } catch (e) {
            print('Error parsing date: $e');
            dateTime = DateTime.now();
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        width: 120, height: 120,
                        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green.withOpacity(0.1)),
                        child: Center(child: Container(width: 90, height: 90, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.green.withOpacity(0.2)),
                        child: Center(child: Container(width: 70, height: 70, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.green),
                        child: const Icon(Icons.check, color: Colors.white, size: 40))))),
                      ),
                      const SizedBox(height: 20),
                      const Text('Sampah Berhasil Di Setor!', style: TextStyle(color: Color(0xFF3D8D7A), fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      Text(
                        dateTime != null 
                          ? '${DateFormat('d MMMM yyyy • HH:mm', 'id_ID').format(dateTime)} WIB • No ref ${data['id_setor']}'
                          : 'No ref ${data['id_setor']}',
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(height: 15),
                      if (data['status'] == 'selesai' && data['total_poin'] != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(color: Colors.amber.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset('assets/poin.png', width: 16, height: 16),
                            const SizedBox(width: 8),
                            Text('Kamu mendapat ${data['total_poin']} Poin', style: const TextStyle(fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Info Cards dengan null safety
                      _buildInfoCard(
                        icon: Icons.store_mall_directory_outlined,
                        title: data['bank_sampah']?['nama_bank_sampah'] ?? 'Nama Bank Tidak Tersedia',
                        subtitle: data['bank_sampah']?['detail_alamat'] ?? 'Alamat tidak tersedia',
                      ),
                      _buildInfoCard(
                        icon: Icons.location_on_outlined,
                        title: 'Lokasi Penjemputan',
                        subtitle: data['lokasi_pengumpulan'] ?? '-',
                      ),
                      _buildInfoCard(
                        icon: Icons.access_time,
                        title: 'Waktu Penjemputan',
                        subtitle: _formatWaktuPengumpulan(data['waktu_pengumpulan']),
                      ),

                      // Card rincian sampah dengan handling kosong
                      Card(
                        margin: const EdgeInsets.only(top: 10),
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                Image.asset('assets/poin.png', width: 20, height: 20),
                                const SizedBox(width: 8),
                                const Text('Rincian Sampah', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              ]),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Berat Total: ${data['total_berat'] ?? 0} kg', style: const TextStyle(color: Colors.grey)),
                                  Text('Jenis Sampah: ${items.length}', style: const TextStyle(color: Colors.grey)),
                                ],
                              ),
                              const Divider(height: 20),
                              if (items.isNotEmpty)
                                ...items.map((item) {
                                  // Kalkulasi poin per item dengan null safety
                                  final double berat = (item['berat_kg'] as num?)?.toDouble() ?? 0.0;
                                  final int bobotPoin = (item['sampah']?['bobot_poin'] as num?)?.toInt() ?? 0;
                                  final int poinPerItem = (berat * bobotPoin).toInt();
                                  
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 2.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            '${item['sampah']?['nama_sampah'] ?? 'Item'} (${berat}kg)',
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Text('$poinPerItem poin'),
                                      ],
                                    ),
                                  );
                                }).toList()
                              else
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text('Tidak ada detail sampah', style: TextStyle(color: Colors.grey)),
                                ),
                              const Divider(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Total Poin', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text('${data['total_poin'] ?? 0} Poin', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF3D8D7A))),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    // DIPERBAIKI: Navigasi yang lebih aman - kembali ke halaman sebelumnya
                    onPressed: () {
                    Navigator.of(context).pushNamedAndRemoveUntil('/menu', (route) => false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3D8D7A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    ),
                    child: const Text('Oke', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatWaktuPengumpulan(dynamic waktuPengumpulan) {
    if (waktuPengumpulan == null) return '-';
    
    try {
      // Jika sudah dalam format TimeOfDay atau string waktu
      if (waktuPengumpulan is String) {
        final parts = waktuPengumpulan.split(':');
        if (parts.length >= 2) {
          final hour = int.tryParse(parts[0]) ?? 0;
          final minute = int.tryParse(parts[1]) ?? 0;
          final timeOfDay = TimeOfDay(hour: hour, minute: minute);
          return timeOfDay.format(context);
        }
      }
      return waktuPengumpulan.toString();
    } catch (e) {
      print('Error formatting waktu pengumpulan: $e');
      return '-';
    }
  }

  Widget _buildInfoCard({required IconData icon, required String title, required String subtitle}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: const Color(0xFF3D8D7A), size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16, color: Colors.black)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}