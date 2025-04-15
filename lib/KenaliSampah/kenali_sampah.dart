import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_wastewise/KenaliSampah/deskripsi_sampah.dart'; 
import 'package:permission_handler/permission_handler.dart';

class KenaliSampah extends StatefulWidget {
  @override
  _KenaliSampahState createState() => _KenaliSampahState();
}

class _KenaliSampahState extends State<KenaliSampah> {
  File? _image;
  bool _scanning = false;
  bool _scanned = false;
  String _wasteType = '';
  String _errorMessage = '';
  
  // List of waste types for manual input
  final List<String> wasteTypes = [
    'Botol Plastik',
    'Kaleng Aluminium',
    'Kertas',
    'Kardus',
    'Sampah Organik',
    'Elektronik',
    'Kaca',
    'Baterai',
    'Tekstil',
    'Styrofoam'
  ];

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      _openCamera();
    } else if (status.isDenied) {
      setState(() {
        _errorMessage = 'Izin kamera ditolak. Silakan berikan izin di pengaturan perangkat Anda.';
      });
    } else if (status.isPermanentlyDenied) {
      setState(() {
        _errorMessage = 'Izin kamera ditolak secara permanen. Silakan aktifkan di pengaturan perangkat Anda.';
      });
      await openAppSettings();
    }
  }

  Future<void> _openCamera() async {
    setState(() {
      _scanning = true;
      _scanned = false;
      _errorMessage = '';
    });

    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        
        // Simulate scanning process (in a real app, you'd use ML here)
        await Future.delayed(Duration(seconds: 2));
        
        // For demo purposes, we'll assume it's always a plastic bottle
        setState(() {
          _scanning = false;
          _scanned = true;
          _wasteType = 'Botol Plastik';
        });
      } else {
        // User canceled the camera
        setState(() {
          _scanning = false;
          _errorMessage = 'Pengambilan gambar dibatalkan';
        });
      }
    } catch (e) {
      setState(() {
        _scanning = false;
        _errorMessage = 'Terjadi kesalahan saat membuka kamera: ${e.toString()}';
      });
    }
  }

  Future<void> _getImage() async {
    // First check camera permission
    await _requestCameraPermission();
  }
  
  // Function to show manual input bottom sheet
  void _showManualInputSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Pilih Jenis Sampah",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF3D8D7A),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.grey),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Silakan pilih jenis sampah yang ingin Anda ketahui:",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: wasteTypes.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            // Navigate directly to the description page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DeskripsiSampah(wasteType: wasteTypes[index]),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            margin: EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  height: 36,
                                  width: 36,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF3D8D7A),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.delete_outline,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Text(
                                  wasteTypes[index],
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.grey,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text(
          "Edukasi Sampah",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Color(0xFF3D8D7A),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_image == null) ...[
                    Container(
                      height: 300,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Color(0xFF3D8D7A),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt_rounded,
                            size: 64,
                            color: Color(0xFF3D8D7A),
                          ),
                          SizedBox(height: 16),
                          Text(
                            "Arahkan sampah ke kamera\nuntuk di scan",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          if (_errorMessage.isNotEmpty) ...[
                            SizedBox(height: 16),
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _errorMessage,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: _getImage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF3D8D7A),
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            "Buka Kamera",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        // New Manual Input button
                        ElevatedButton(
                          onPressed: _showManualInputSheet,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Color(0xFF3D8D7A), width: 1),
                            ),
                          ),
                          child: Text(
                            "Input Manual",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF3D8D7A),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    // Gallery option
                    TextButton.icon(
                      onPressed: () async {
                        setState(() {
                          _scanning = true;
                          _scanned = false;
                          _errorMessage = '';
                        });

                        try {
                          final picker = ImagePicker();
                          final pickedFile = await picker.pickImage(source: ImageSource.gallery);

                          if (pickedFile != null) {
                            setState(() {
                              _image = File(pickedFile.path);
                            });
                            
                            // Simulate scanning process
                            await Future.delayed(Duration(seconds: 2));
                            
                            setState(() {
                              _scanning = false;
                              _scanned = true;
                              _wasteType = 'Botol Plastik';
                            });
                          } else {
                            setState(() {
                              _scanning = false;
                            });
                          }
                        } catch (e) {
                          setState(() {
                            _scanning = false;
                            _errorMessage = 'Terjadi kesalahan: ${e.toString()}';
                          });
                        }
                      },
                      icon: Icon(Icons.photo_library, color: Color(0xFF3D8D7A)),
                      label: Text(
                        "Pilih dari Galeri",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Color(0xFF3D8D7A),
                        ),
                      ),
                    ),
                  ] else ...[
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 350,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Color(0xFF3D8D7A),
                              width: 2,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              _image!,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        if (_scanning)
                          Container(
                            height: 350,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(color: Colors.white),
                                SizedBox(height: 16),
                                Text(
                                  "Mengidentifikasi sampah...",
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 20),
                    if (_scanned) ...[
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: Colors.green,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Teridentifikasi : $_wasteType",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DeskripsiSampah(wasteType: _wasteType),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF3D8D7A),
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "Lihat Penjelasan",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          // Add manual input option here too
                          OutlinedButton(
                            onPressed: _showManualInputSheet,
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Color(0xFF3D8D7A)),
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "Input Manual",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF3D8D7A),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        "Scan berhasil! Sampah telah teridentifikasi.",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.green,
                        ),
                      ),
                    ] else ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: _getImage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF3D8D7A),
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "Scan Ulang",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          // Add manual input option here too
                          OutlinedButton(
                            onPressed: _showManualInputSheet,
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Color(0xFF3D8D7A)),
                              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "Input Manual",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF3D8D7A),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}