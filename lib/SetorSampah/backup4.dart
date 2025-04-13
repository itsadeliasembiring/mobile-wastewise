// import 'package:flutter/material.dart';
// import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:permission_handler/permission_handler.dart';

// void main() {
//   runApp(const ScanBarcode());
// }

// class ScanBarcode extends StatelessWidget {
//   const ScanBarcode({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Waste Collection App',
//       theme: ThemeData(
//         primaryColor: Color(0xFF3D8D7A),
//         fontFamily: 'Poppins',
//       ),
//       home: const WasteCollectionPage(),
//     );
//   }
// }

// class WasteCollectionPage extends StatefulWidget {
//   const WasteCollectionPage({Key? key}) : super(key: key);

//   @override
//   State<WasteCollectionPage> createState() => _WasteCollectionPageState();
// }

// class _WasteCollectionPageState extends State<WasteCollectionPage> {
//   String scannedBarcode = '';
//   final TextEditingController _codeController = TextEditingController();
//   bool _isScanning = false;

//   // Daftar kode yang valid (contoh)
//   final List<String> _validCodes = ['123456', 'ABC123', 'WASTE01', 'ECO2025'];

//   @override
//   void initState() {
//     super.initState();
//     // Gunakan Future.delayed untuk memberikan waktu widget selesai dirender
//     Future.delayed(Duration(milliseconds: 500), () {
//       scanBarcode();
//     });
//   }

//   @override
//   void dispose() {
//     _codeController.dispose();
//     super.dispose();
//   }

//   Future<void> scanBarcode() async {
//     // Request camera permission
//     var status = await Permission.camera.request();
//     if (status.isGranted) {
//       setState(() {
//         _isScanning = true;
//       });
      
//       try {
//         String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
//           '#3D8D7A', // Line color
//           'Batal', // Cancel button text
//           true, // Show flash icon
//           ScanMode.QR, // Scan mode (QR code in this case)
//         );

//         if (barcodeScanRes != '-1') {
//           setState(() {
//             scannedBarcode = barcodeScanRes;
//           });
//           // Process the scanned barcode
//           processCode(barcodeScanRes);
//         } else {
//           // User canceled the scan
//           showErrorDialog('Pemindaian dibatalkan');
//         }
//       } catch (e) {
//         print('Error scanning barcode: $e');
//         showErrorDialog('Terjadi kesalahan saat memindai kode');
//       } finally {
//         setState(() {
//           _isScanning = false;
//         });
//       }
//     } else {
//       // Handle when permission is denied
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Izin kamera diperlukan untuk scan barcode')),
//       );
//     }
//   }

//   void processCode(String code) {
//     if (code.isEmpty) {
//       showErrorDialog('Kode tidak boleh kosong!');
//       return;
//     }
    
//     // Validasi kode
//     if (_validCodes.contains(code)) {
//       // Kode valid
//       print('Processing code: $code');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Kode berhasil diproses: $code'),
//           backgroundColor: Color(0xFF3D8D7A),
//         ),
//       );
//       // Tambahkan logika lanjutan di sini (navigasi ke halaman berikutnya, dll)
//     } else {
//       // Kode tidak valid
//       showErrorDialog('Kode "$code" tidak terdaftar dalam sistem');
//       setState(() {
//         scannedBarcode = '';
//       });
//     }
//   }

//   void showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           title: Row(
//             children: [
//               Icon(Icons.error_outline, color: Colors.red),
//               SizedBox(width: 10),
//               Text(
//                 'Peringatan',
//                 style: TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.red,
//                 ),
//               ),
//             ],
//           ),
//           content: Text(
//             message,
//             style: TextStyle(fontSize: 16),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               style: TextButton.styleFrom(
//                 foregroundColor: Color(0xFF3D8D7A),
//               ),
//               child: Text(
//                 'Tutup',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void showManualInputDialog() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (BuildContext context) {
//         return Padding(
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//             left: 20,
//             right: 20,
//             top: 20,
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const Text(
//                 'Masukkan Kode Setor Sampah',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                   color: Color(0xFF3D8D7A),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade200,
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: TextField(
//                   controller: _codeController,
//                   decoration: const InputDecoration(
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                     hintText: 'Masukkan kode di sini',
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   if (_codeController.text.isEmpty) {
//                     showErrorDialog('Kode tidak boleh kosong!');
//                   } else {
//                     processCode(_codeController.text);
//                   }
//                   _codeController.clear();
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF3D8D7A),
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   minimumSize: const Size(double.infinity, 0),
//                 ),
//                 child: const Text(
//                   'Oke',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F6FA),
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
            
//             const SizedBox(height: 20),

//             // Barcode scan area
//             Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Center(
//                     child: Text(
//                       "Scan Barcode",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 22,
//                         fontWeight: FontWeight.w500,
//                         color: Color(0xFF3D8D7A),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   GestureDetector(
//                     onTap: _isScanning ? null : scanBarcode,
//                     child: Center(
//                       child: Container(
//                         width: 260,
//                         height: 260,
//                         decoration: BoxDecoration(
//                           color: Colors.transparent,
//                           border: Border.all(color: Colors.transparent),
//                         ),
//                         child: Stack(
//                           children: [
//                             // Corners for scan area
//                             Positioned(
//                               left: 0,
//                               top: 0,
//                               child: Container(
//                                 width: 30,
//                                 height: 30,
//                                 decoration: const BoxDecoration(
//                                   border: Border(
//                                     top: BorderSide(color: Color(0xFF3D8D7A), width: 3),
//                                     left: BorderSide(color: Color(0xFF3D8D7A), width: 3),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Positioned(
//                               right: 0,
//                               top: 0,
//                               child: Container(
//                                 width: 30,
//                                 height: 30,
//                                 decoration: const BoxDecoration(
//                                   border: Border(
//                                     top: BorderSide(color: Color(0xFF3D8D7A), width: 3),
//                                     right: BorderSide(color: Color(0xFF3D8D7A), width: 3),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Positioned(
//                               left: 0,
//                               bottom: 0,
//                               child: Container(
//                                 width: 30,
//                                 height: 30,
//                                 decoration: const BoxDecoration(
//                                   border: Border(
//                                     bottom: BorderSide(color: Color(0xFF3D8D7A), width: 3),
//                                     left: BorderSide(color: Color(0xFF3D8D7A), width: 3),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             Positioned(
//                               right: 0,
//                               bottom: 0,
//                               child: Container(
//                                 width: 30,
//                                 height: 30,
//                                 decoration: const BoxDecoration(
//                                   border: Border(
//                                     bottom: BorderSide(color: Color(0xFF3D8D7A), width: 3),
//                                     right: BorderSide(color: Color(0xFF3D8D7A), width: 3),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             // Show QR code if one exists
//                             if (scannedBarcode.isNotEmpty && !_isScanning)
//                               Center(
//                                 child: Text(
//                                   'Kode: $scannedBarcode',
//                                   style: const TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                   textAlign: TextAlign.center,
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Manual code input button
//             Padding(
//               padding: const EdgeInsets.all(20),
//               child: ElevatedButton(
//                 onPressed: showManualInputDialog,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF3D8D7A),
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   minimumSize: const Size(double.infinity, 0),
//                 ),
//                 child: const Text(
//                   'Masukkan Kode',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }