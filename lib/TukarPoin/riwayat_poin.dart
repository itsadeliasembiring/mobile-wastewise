import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Model tidak berubah
class TransactionHistory {
  final String id;
  final String type; // Misal: 'Tukar Barang', 'Donasi', 'Dapat Poin'
  final String title;
  final int points;
  final DateTime dateTime;
  final String? redemptionCode;

  TransactionHistory({
    required this.id,
    required this.type,
    required this.title,
    required this.points,
    required this.dateTime,
    this.redemptionCode,
  });
}

class RiwayatPoin extends StatefulWidget {
  const RiwayatPoin({super.key});

  @override
  State<RiwayatPoin> createState() => _RiwayatPoinState();
}

class _RiwayatPoinState extends State<RiwayatPoin> {
  final SupabaseClient _supabase = Supabase.instance.client;
  List<TransactionHistory> _transactionHistory = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);
    _loadTransactionHistory();
  }

  Future<void> _loadTransactionHistory() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('User belum login');

      final userId = user.id;

      // Mengambil data dari tabel riwayat_poin yang sudah terpusat
      // Ini lebih efisien daripada menggabungkan dari banyak tabel di client
      final response = await _supabase
          .from('riwayat_poin_detail') // Menggunakan VIEW yang akan kita buat
          .select()
          .eq('id_pengguna', userId)
          .order('waktu', ascending: false);

      if (mounted) {
        setState(() {
          _transactionHistory = response.map<TransactionHistory>((item) {
            return TransactionHistory(
              id: item['id_riwayat'],
              // Mengubah 'tukar_barang' menjadi 'Tukar Barang' untuk tampilan
              type: (item['jenis_perubahan'] as String).replaceAll('_', ' ').split(' ').map((str) => '${str[0].toUpperCase()}${str.substring(1)}').join(' '),
              title: item['deskripsi'] ?? 'Aktivitas Poin',
              points: item['jumlah_poin'], // Poin sudah positif/negatif dari DB
              dateTime: DateTime.parse(item['waktu']),
              redemptionCode: item['kode_redeem'],
            );
          }).toList();
        });
      }

    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Gagal memuat riwayat: ${e.toString()}';
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Kode UI tidak ada perubahan signifikan
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: RefreshIndicator(
        onRefresh: _loadTransactionHistory,
        color: const Color(0xFF3D8D7A),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF3D8D7A)))
            : _errorMessage != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                          const SizedBox(height: 16),
                          Text(_errorMessage!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadTransactionHistory,
                            child: const Text('Coba Lagi'),
                          ),
                        ],
                      ),
                    ),
                  )
                : _transactionHistory.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.history, size: 48, color: Colors.grey),
                            SizedBox(height: 16),
                            Text('Belum ada riwayat transaksi.', style: TextStyle(fontSize: 16, color: Colors.grey)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        itemCount: _transactionHistory.length,
                        itemBuilder: (context, index) {
                          final transaction = _transactionHistory[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12, left: 16, right: 16),
                            child: _buildHistoryItem(transaction),
                          );
                        },
                      ),
      ),
    );
  }

  // Sisa kode UI (buildHistoryItem, dll) tidak perlu diubah.
  // Pastikan Anda menempelkan method-method UI tersebut di sini.
  Widget _buildHistoryItem(TransactionHistory transaction) {
    final dateFormatter = DateFormat('d MMMM yyyy', 'id_ID');
    final timeFormatter = DateFormat('HH:mm', 'id_ID');
    final date = dateFormatter.format(transaction.dateTime);
    final time = timeFormatter.format(transaction.dateTime) + ' WIB';
    final pointsText = transaction.points > 0 ? '+${transaction.points}' : '${transaction.points}';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.type,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      transaction.title,
                      style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$date - $time',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '$pointsText Poin',
                style: TextStyle(
                  color: transaction.points < 0 ? Colors.red : Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          if (transaction.redemptionCode != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: _buildRedemptionCodeChip(transaction.redemptionCode!),
            ),
        ],
      ),
    );
  }

  Widget _buildRedemptionCodeChip(String code) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFA3D1C6).withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.confirmation_number_outlined, size: 16, color: Color(0xFF3D8D7A)),
          const SizedBox(width: 6),
          const Text(
            'Kode Redeem: ',
            style: TextStyle(color: Color(0xFF3D8D7A), fontSize: 12),
          ),
          Text(
            code,
            style: const TextStyle(color: Color(0xFF3D8D7A), fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: code));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Kode redeem disalin'),
                  backgroundColor: Color(0xFF3D8D7A),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Icon(Icons.copy, size: 16, color: Color(0xFF3D8D7A)),
          ),
        ],
      ),
    );
  }
}
