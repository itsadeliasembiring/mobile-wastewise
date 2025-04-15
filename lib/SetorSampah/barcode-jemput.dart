import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'detail_setor_sampah.dart';
void main() {
  runApp(const ScanBarcode());
}

class ScanBarcode extends StatelessWidget {
  const ScanBarcode({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Waste Collection App',
      theme: ThemeData(
        primaryColor: Color(0xFF3D8D7A),
        fontFamily: 'Poppins',
      ),
      home: const WasteCollectionPage(),
    );
  }
}

class WasteCollectionPage extends StatefulWidget {
  const WasteCollectionPage({Key? key}) : super(key: key);

  @override
  State<WasteCollectionPage> createState() => _WasteCollectionPageState();
}

class _WasteCollectionPageState extends State<WasteCollectionPage> {
  String scannedBarcode = '';
  final TextEditingController _codeController = TextEditingController();
  bool _isScanning = false;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  final List<String> _validCodes = ['123456', 'ABC123', 'WASTE01', 'ECO2025'];

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

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
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _requestCameraPermission() async {
    var status = await Permission.camera.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Izin kamera diperlukan untuk scan barcode')),
      );
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (scanData.code != null && scanData.code!.isNotEmpty) {
        controller.pauseCamera();
        setState(() {
          _isScanning = false;
          scannedBarcode = scanData.code!;
        });
        processCode(scanData.code!);
      }
    });
  }

  void resumeScanning() {
    setState(() {
      scannedBarcode = '';
      _isScanning = true;
    });
    controller?.resumeCamera();
  }

  void processCode(String code) {
    if (code.isEmpty) {
      showErrorDialog('Kode tidak boleh kosong!');
      return;
    }
    
    // Validasi kode
    if (_validCodes.contains(code)) {
      // Kode valid
      print('Processing code: $code');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Kode berhasil diproses: $code'),
          backgroundColor: Color(0xFF3D8D7A),
        ),
      );
      
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context) => DetailSetorSampah(),
        ),
      );
    } else {
      // Kode tidak valid
      showErrorDialog('Kode "$code" tidak terdaftar dalam sistem');
      setState(() {
        scannedBarcode = '';
      });
      Future.delayed(Duration(seconds: 2), () {
        resumeScanning();
      });
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red),
              SizedBox(width: 10),
              Text(
                'Peringatan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          content: Text(
            message,
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: Color(0xFF3D8D7A),
              ),
              child: Text(
                'Tutup',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void showManualInputDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Masukkan Kode Setor Sampah',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF3D8D7A),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  controller: _codeController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    hintText: 'Masukkan kode di sini',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (_codeController.text.isEmpty) {
                    showErrorDialog('Kode tidak boleh kosong!');
                  } else {
                    processCode(_codeController.text);
                  }
                  _codeController.clear();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3D8D7A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  minimumSize: const Size(double.infinity, 0),
                ),
                child: const Text(
                  'Oke',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void openWhatsAppChat() async {
    String phone = '+6281234567890';
    String message = Uri.encodeComponent('Halo, saya ingin menyetor sampah.');
    final url = 'https://wa.me/$phone?text=$message';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Tidak bisa membuka WhatsApp';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6FA),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Scan Barcode",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF3D8D7A),
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // QR code scanner area
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(
                    child: Text(
                      "Scan Barcode",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF3D8D7A),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 260,
                    height: 260,
                    child: Stack(
                      children: [
                        // QR Scanner View
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: QRView(
                            key: qrKey,
                            onQRViewCreated: _onQRViewCreated,
                            overlay: QrScannerOverlayShape(
                              borderColor: Color(0xFF3D8D7A),
                              borderRadius: 10,
                              borderLength: 30,
                              borderWidth: 10,
                              cutOutSize: 250,
                            ),
                          ),
                        ),
                        
                        if (scannedBarcode.isNotEmpty && !_isScanning)
                          Container(
                            width: 260,
                            height: 260,
                            color: Colors.black.withOpacity(0.6),
                            child: Center(
                              child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Kode: $scannedBarcode',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 12),
                                    ElevatedButton(
                                      onPressed: resumeScanning,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF3D8D7A),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: Text('Scan Lagi'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: showManualInputDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3D8D7A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      minimumSize: const Size(double.infinity, 0),
                    ),
                    child: const Text(
                      'Masukkan Kode',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12), 
                  ElevatedButton(
                    onPressed: openWhatsAppChat,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3D8D7A),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      minimumSize: const Size(double.infinity, 0),
                    ),
                    child: const Text(
                      'Kontak Whatsapp Bank Sampah',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20), 
          ],
        ),
      ),
    );
  }
}
