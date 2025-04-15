import 'package:flutter/material.dart';
import './tukar_poin.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailDonasi extends StatefulWidget {
  final Donation donation;
  final Function(Transaction) addTransaction;
  final int totalPoints; 

  const DetailDonasi({
    super.key,
    required this.donation,
    required this.addTransaction,
    required this.totalPoints, 
  });

  @override
  State<DetailDonasi> createState() => _DetailDonasiState();
}

class _DetailDonasiState extends State<DetailDonasi> {
  final TextEditingController _pointsController = TextEditingController();
  int donationPoints = 0;
  int donationTotal = 0;

  @override
  void initState() {
    super.initState();
    donationTotal = widget.donation.totalDonation;
  }

  @override
  void dispose() {
    _pointsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Donasi',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF3D8D7A),
            )),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                widget.donation.imageAsset,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 180,
                  color: const Color(0xFFA3D1C6),
                  child: const Center(
                    child: Icon(Icons.home, size: 80, color: Color(0xFF3D8D7A)),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.donation.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF3D8D7A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.donation.address,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Total Donasi',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$donationTotal Poin',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _showDonationInputDialog();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3D8D7A),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Donasi Sekarang',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Deskripsi',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.donation.description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDonationInputDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Jumlah Donasi',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3D8D7A),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _pointsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Masukkan jumlah poin',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/poin.png', width: 20, height: 20),
                      const SizedBox(width: 4),
                      const Text('Poin', style: TextStyle(color: Colors.grey)),
                      const SizedBox(width: 16),
                    ],
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    donationPoints = int.tryParse(value) ?? 0;
                  });
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_pointsController.text.isEmpty || donationPoints <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Masukkan jumlah poin yang valid'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    Navigator.pop(context);
                    _showConfirmationDialog(donationPoints);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3D8D7A),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Donasi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  void _showConfirmationDialog(int points) {
    if (points > widget.totalPoints) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Center(
            child: Text('Poin Tidak Cukup', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.red)),
          ),
          backgroundColor: Colors.white,
          content: 
              Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Center(
                  child: Icon(Icons.close, color: Colors.red, size: 70),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'Poin Anda tidak mencukupi untuk melakukan donasi ini.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),         
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:  const Text('Tutup', style: TextStyle(color: Color(0xFF3D8D7A))),
            ),
          ],
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Center(
          child: Text('Konfirmasi Donasi', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF3D8D7A))),
        ),
        content: Text('Apakah Anda yakin ingin mendonasikan $points poin untuk ${widget.donation.title}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _processDonation(points);
            },
            child: const Text('Donasi', style: TextStyle(color: Color(0xFF3D8D7A))),
          ),
        ],
      ),
    );
  }

  void _processDonation(int points) {
    setState(() {
      donationTotal += points;
    });

    final Transaction transaction = Transaction(
      type: 'Donasi',
      title: widget.donation.title,
      points: -points,
      dateTime: DateTime.now(),
    );

    widget.addTransaction(transaction);
    _showSuccessDialog(points);
  }

  void _showSuccessDialog(int points) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Center(
          child: Text('Donasi Berhasil', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF3D8D7A))),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Center(
              child: Icon(Icons.check_circle, color: Color(0xFF3D8D7A), size: 70),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Terima kasih telah mendonasikan $points poin untuk ${widget.donation.title}',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Kembali', style: TextStyle(color: Color(0xFF3D8D7A))),
          ),
        ],
      ),
    );
  }
}
