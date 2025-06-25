import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import '../SetorSampah/waste_type.dart';
import '../SetorSampah/bank_sampah.dart'; // Pastikan Anda sudah membuat file model ini
import '../Providers/points.provider.dart';

class PilihAlamat extends StatelessWidget {
  final Map<String, double> wasteQuantities;
  final List<WasteType> wasteTypes;
  final double totalWastePoints;

  const PilihAlamat({
    Key? key,
    required this.wasteQuantities,
    required this.wasteTypes,
    required this.totalWastePoints,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Atur Penjemputan"),
      ),
      body: PilihAlamatPage(
        wasteQuantities: wasteQuantities,
        wasteTypes: wasteTypes,
        totalWastePoints: totalWastePoints,
      ),
    );
  }
}

class PilihAlamatPage extends StatefulWidget {
  final Map<String, double> wasteQuantities;
  final List<WasteType> wasteTypes;
  final double totalWastePoints;

  const PilihAlamatPage({
    Key? key,
    required this.wasteQuantities,
    required this.wasteTypes,
    required this.totalWastePoints,
  }) : super(key: key);

  @override
  State<PilihAlamatPage> createState() => _PilihAlamatPageState();
}

class _PilihAlamatPageState extends State<PilihAlamatPage> {
  final _supabase = Supabase.instance.client;
  bool _isLoading = true;
  bool _isSubmitting = false;

  String _address = 'Memuat alamat...';
  TimeOfDay _selectedTime = const TimeOfDay(hour: 14, minute: 0);
  late TextEditingController _addressController;

  List<BankSampah> _bankSampahList = [];
  String? _selectedBankSampahId;

  @override
  void initState() {
    super.initState();
    _addressController = TextEditingController();
    _loadInitialData();
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    await Future.wait([
      _fetchUserAddress(),
      _fetchBankSampahList(),
    ]);
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchUserAddress() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      if (mounted) setState(() => _address = 'Gagal: Pengguna tidak login.');
      return;
    }
    try {
      final response = await _supabase.from('pengguna').select('detail_alamat').eq('id_pengguna', userId).single();
      if (mounted) setState(() => _address = response['detail_alamat'] ?? 'Alamat belum diatur.');
    } catch (e) {
      if (mounted) setState(() => _address = 'Gagal memuat alamat.');
    }
  }

  Future<void> _fetchBankSampahList() async {
    try {
      final response = await _supabase.from('bank_sampah').select('id_bank_sampah, nama_bank_sampah');
      if (mounted) {
        setState(() {
          _bankSampahList = response.map((item) => BankSampah.fromJson(item)).toList();
        });
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal memuat daftar bank sampah: $e'), backgroundColor: Colors.red));
    }
  }

  Future<void> _ajukanPenjemputan() async {
    if (_selectedBankSampahId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Silakan pilih bank sampah tujuan.'), backgroundColor: Colors.orange));
      return;
    }

    setState(() { _isSubmitting = true; });

    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sesi tidak valid, silakan login ulang.'), backgroundColor: Colors.red));
      setState(() { _isSubmitting = false; });
      return;
    }

    final List<Map<String, dynamic>> wasteItemsJson = widget.wasteTypes
        .where((waste) => (widget.wasteQuantities[waste.name] ?? 0) > 0)
        .map((waste) => {'id_sampah': waste.id, 'berat_kg': widget.wasteQuantities[waste.name]})
        .toList();

    try {
      final result = await _supabase.rpc('handle_waste_deposit', params: {
        'user_id_in': userId,
        'bank_sampah_id_in': _selectedBankSampahId,
        'jenis_layanan_id_in': 'L1',
        'lokasi_pengumpulan_in': _address,
        'waktu_pengumpulan_in': '${_selectedTime.hour}:${_selectedTime.minute}:00',
        'waste_items': wasteItemsJson,
      });

      final newIdSetor = result['id_setor'];
      if (mounted) {
        context.read<PointsProvider>().fetchPoints(forceRefresh: true);
        Navigator.of(context).pushNamed('/detail-setor', arguments: newIdSetor);
      }

    } on PostgrestException catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: ${e.message}'), backgroundColor: Colors.red));
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() { _isSubmitting = false; });
    }
  }

  Future<void> _showAddressForm(BuildContext context) async {
    _addressController.text = _address;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            top: 20, left: 20, right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Ubah Alamat Penjemputan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Detail Alamat Lengkap', border: OutlineInputBorder()),
                maxLines: 3,
                autofocus: true,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _address = _addressController.text;
                    });
                    Navigator.pop(ctx);
                  },
                  child: const Text('Simpan Alamat'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    const Text('1. Pilih Bank Sampah Tujuan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _selectedBankSampahId,
                      hint: const Text('Pilih bank sampah'),
                      isExpanded: true,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)),
                      items: _bankSampahList.map((bank) {
                        return DropdownMenuItem(
                          value: bank.id,
                          child: Text(bank.name, overflow: TextOverflow.ellipsis),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedBankSampahId = value;
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    const Text('2. Atur Alamat & Waktu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),

                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        leading: const Icon(Icons.location_on_outlined, color: Color(0xFF3D8D7A)), // Warna diubah
                        title: const Text("Lokasi Penjemputan"),
                        subtitle: Text(_address, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black, fontSize: 15)),
                        trailing: TextButton(
                          onPressed: () => _showAddressForm(context),
                          child: const Text(
                            "Ubah",
                            style: TextStyle(color: Color(0xFF3D8D7A)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        leading: const Icon(Icons.access_time_outlined, color: Color(0xFF3D8D7A)), // Warna diubah
                        title: const Text("Waktu Penjemputan"),
                        subtitle: Text(_selectedTime.format(context), style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black, fontSize: 15)),
                        trailing: TextButton(onPressed: () async {
                          final TimeOfDay? picked = await showTimePicker(context: context, initialTime: _selectedTime);
                          if (picked != null && picked != _selectedTime) {
                            setState(() { _selectedTime = picked; });
                          }
                        }, child: const Text("Ubah")),
                      ),
                    ),
                  ],
                ),
        ),
        
        Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isSubmitting ? null : _ajukanPenjemputan,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3D8D7A), // Warna diubah
              foregroundColor: Colors.white, // Warna teks agar kontras
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: _isSubmitting
                ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                : const Text('Ajukan Penjemputan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}