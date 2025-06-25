import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import '../SetorSampah/waste_type.dart';
import '../SetorSampah/bank_sampah.dart';
import '../Providers/points.provider.dart';

class HalamanKodeVerifikasi extends StatefulWidget {
  final Map<String, double> wasteQuantities;
  final List<WasteType> wasteTypes;
  final double totalWastePoints;

  const HalamanKodeVerifikasi({
    Key? key,
    required this.wasteQuantities,
    required this.wasteTypes,
    required this.totalWastePoints,
  }) : super(key: key);

  @override
  State<HalamanKodeVerifikasi> createState() => _HalamanKodeVerifikasiState();
}

class _HalamanKodeVerifikasiState extends State<HalamanKodeVerifikasi> {
  final _supabase = Supabase.instance.client;

  // --- State Variables ---
  String? _verificationCode;
  String? _createdIdSetor;
  String? _errorMessage;
  String? _errorDetails;
  bool _isLoading = true; // Loading awal untuk daftar bank sampah
  bool _isCreatingCode = false; // Loading saat membuat kode

  List<BankSampah> _bankSampahList = [];
  String? _selectedBankSampahId;

  @override
  void initState() {
    super.initState();
    _fetchBankSampahList();
  }

  /// Mengambil daftar bank sampah dari database
  Future<void> _fetchBankSampahList() async {
    try {
      final response = await _supabase.from('bank_sampah').select('id_bank_sampah, nama_bank_sampah');
      if (mounted) {
        setState(() {
          _bankSampahList = response.map((item) => BankSampah.fromJson(item)).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = "Gagal memuat daftar bank sampah: $e";
          _isLoading = false;
        });
      }
    }
  }

  /// Membuat transaksi dan mendapatkan kode verifikasi dari RPC
  Future<void> _createDepositAndGetCode() async {
    if (_selectedBankSampahId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Silakan pilih bank sampah tujuan terlebih dahulu.'), backgroundColor: Colors.orange));
      return;
    }

    setState(() {
      _isCreatingCode = true;
      _errorMessage = null;
      _errorDetails = null;
    });

    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Sesi tidak valid. Silakan login ulang.';
          _isCreatingCode = false;
        });
      }
      return;
    }

    final List<Map<String, dynamic>> wasteItemsJson = widget.wasteTypes
        .where((waste) => (widget.wasteQuantities[waste.name] ?? 0) > 0)
        .map((waste) => {'id_sampah': waste.id, 'berat_kg': widget.wasteQuantities[waste.name]})
        .toList();

    if (wasteItemsJson.isEmpty) {
        setState(() {
            _errorMessage = "Tidak ada data sampah yang dipilih untuk dikirim.";
            _isCreatingCode = false;
        });
        return;
    }

    try {
      final String currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
      final result = await _supabase.rpc('handle_waste_deposit', params: {
        'user_id_in': userId,
        'bank_sampah_id_in': _selectedBankSampahId,
        'jenis_layanan_id_in': 'L2',
        'lokasi_pengumpulan_in': 'Setor di Lokasi Bank Sampah',
        'waktu_pengumpulan_in': currentTime,
        'waste_items': wasteItemsJson,
      });

      if (mounted) {
        setState(() {
          _verificationCode = result['kode_verifikasi'];
          _createdIdSetor = result['id_setor'];
        });
        context.read<PointsProvider>().fetchPoints(forceRefresh: true);
      }
    } on PostgrestException catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.message;
          _errorDetails = "Code: ${e.code}\nDetails: ${e.details}";
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Terjadi kesalahan: $e';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCreatingCode = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Setor Langsung")),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _buildMainContent(),
      ),
    );
  }

  Widget _buildMainContent() {
    if (_errorMessage != null) {
      return _buildErrorUI();
    }
    if (_verificationCode == null) {
      return _buildBankSelectionUI();
    }
    return _buildVerificationCodeUI();
  }
  
  Widget _buildErrorUI() {
    return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 60),
            const SizedBox(height: 16),
            const Text("Gagal Membuat Kode", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Text(_errorMessage ?? "Terjadi error tidak diketahui", style: const TextStyle(color: Colors.red, fontSize: 15), textAlign: TextAlign.center),
            if (_errorDetails != null) ...[
                const SizedBox(height: 8),
                Text(_errorDetails!, style: TextStyle(color: Colors.red.shade300, fontSize: 12), textAlign: TextAlign.center),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => setState(() {
                _errorMessage = null;
                _errorDetails = null;
              }),
              child: const Text('Coba Lagi'),
            )
          ],
        ));
  }

  Widget _buildBankSelectionUI() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text("Pilih Bank Sampah Tujuan", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedBankSampahId,
            hint: const Text('Pilih bank sampah'),
            isExpanded: true,
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
            items: _bankSampahList
                .map((bank) => DropdownMenuItem(value: bank.id, child: Text(bank.name, overflow: TextOverflow.ellipsis)))
                .toList(),
            onChanged: (value) => setState(() => _selectedBankSampahId = value),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              disabledBackgroundColor: Colors.grey.shade400,
            ),
            onPressed: _isCreatingCode ? null : _createDepositAndGetCode,
            child: _isCreatingCode
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                : const Text('Buat Kode Verifikasi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, backgroundColor: Color(0xFF3D8D7A))),
          ),
        ],
      ),
    );
  }

  Widget _buildVerificationCodeUI() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Tunjukkan kode ini kepada petugas Bank Sampah",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.shade600, width: 2),
            ),
            child: Text(
              _verificationCode ?? 'N/A',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                letterSpacing: 8,
              ),
            ),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () {
              if (_createdIdSetor != null) {
                Navigator.of(context).pushNamedAndRemoveUntil('/detail-setor', (route) => false, arguments: _createdIdSetor);
              } else {
                Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
              }
            },
            child: const Text(
              "Selesai",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                backgroundColor: Color(0xFF3D8D7A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}