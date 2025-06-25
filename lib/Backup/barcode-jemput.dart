// lib/screens/barcode-jemput.dart

import 'package:flutter/material.dart';
import 'package:mobile_wastewise/SetorSampah/waste_type.dart';
import 'package:mobile_wastewise/Providers/points.provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Diubah menjadi StatefulWidget tunggal untuk menyederhanakan dan menerima parameter.
class ScanBarcode extends StatefulWidget {
  final Map<String, double> wasteQuantities;
  final List<WasteType> wasteTypes;
  final double totalWastePoints;

  const ScanBarcode({
    Key? key,
    required this.wasteQuantities,
    required this.wasteTypes,
    required this.totalWastePoints,
  }) : super(key: key);

  @override
  State<ScanBarcode> createState() => _ScanBarcodeState();
}

class _ScanBarcodeState extends State<ScanBarcode> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool _isSubmitting = false; // State untuk loading setelah scan

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Barcode'),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
          if (_isSubmitting)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }
  
  // Fungsi-fungsi QR Scanner (dispose, reassemble) tetap sama
  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      controller!.pauseCamera();
      controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> _requestCameraPermission() async {
    await Permission.camera.request();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      // Hanya proses jika belum dalam proses submit dan kode ada
      if (!_isSubmitting && scanData.code != null && scanData.code!.isNotEmpty) {
        controller.pauseCamera();
        processCode(scanData.code!);
      }
    });
  }

  /// Memproses kode yang di-scan dengan memanggil RPC Supabase.
  Future<void> processCode(String scannedCode) async {
    setState(() { _isSubmitting = true; });

    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sesi tidak valid, silakan login ulang.'), backgroundColor: Colors.red));
      setState(() { _isSubmitting = false; });
      controller?.resumeCamera();
      return;
    }

    // Format data sampah menjadi JSON
    final List<Map<String, dynamic>> wasteItemsJson = widget.wasteTypes
        .where((waste) => (widget.wasteQuantities[waste.name] ?? 0) > 0)
                .map((waste) => {'id_sampah': waste.id, 'berat_kg': widget.wasteQuantities[waste.name]})
                .toList();
          }
        }