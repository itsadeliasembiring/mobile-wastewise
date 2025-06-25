import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Import halaman-halaman tujuan navigasi Anda
import '../Menu/menu.dart'; // Pastikan path ini benar
import '../Artikel/detail_artikel.dart'; // Pastikan path ini benar

//======================================================================
// 1. MODEL DATA (Tetap sama, sudah baik)
//======================================================================

class PenggunaModel {
  final String namaLengkap;
  final int totalPoin;
  final String? fotoUrl;

  PenggunaModel(
      {required this.namaLengkap, required this.totalPoin, this.fotoUrl});

  factory PenggunaModel.fromMap(Map<String, dynamic> map) {
    return PenggunaModel(
      namaLengkap: map['nama_lengkap'] as String? ?? 'Pengguna',
      totalPoin: map['total_poin'] as int? ?? 0,
      fotoUrl: map['foto'] as String?,
    );
  }
}

class BankSampahModel {
  final String nama;
  final String alamat;
  final String? fotoUrl;
  //final double? jarak;

  BankSampahModel(
      {required this.nama, required this.alamat, this.fotoUrl});

  factory BankSampahModel.fromMap(Map<String, dynamic> map) {
    return BankSampahModel(
      nama: map['nama_bank_sampah'] as String? ?? 'Nama Tidak Tersedia',
      alamat: map['detail_alamat'] as String? ?? 'Alamat Tidak Tersedia',
      fotoUrl: map['foto'] as String?,
      //jarak: (map['jarak'] as num?)?.toDouble(),
    );
  }
}

//======================================================================
// 2. HALAMAN UTAMA (Beranda)
//======================================================================

class Beranda extends StatefulWidget {
  const Beranda({super.key});

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  final SupabaseClient supabase = Supabase.instance.client;

  // State untuk data UI
  PenggunaModel? _pengguna;
  double _totalBeratSampah = 0.0;
  BankSampahModel? _bankSampah;
  List<Map<String, dynamic>> _articles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Memanggil _refreshData untuk pertama kali
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData();
    });
  }

  /// Mengambil semua data yang dibutuhkan halaman secara efisien.
  Future<void> _refreshData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      // Menjalankan semua query secara bersamaan untuk efisiensi
      final results = await Future.wait<dynamic>([
        supabase
            .from('pengguna')
            .select('nama_lengkap, total_poin, foto')
            .eq('id_pengguna', user.id)
            .maybeSingle(),
        supabase.rpc('get_total_berat_by_pengguna',
            params: {'p_id_pengguna': user.id}),
        supabase
            .from('bank_sampah')
            .select('nama_bank_sampah, detail_alamat, foto')
            .limit(1)
            .maybeSingle(),
        supabase.from('artikel').select('''
          id_artikel, judul_artikel, waktu_publikasi, detail_artikel, foto,
          bank_sampah:penulis_artikel (nama_bank_sampah, foto)
        ''').order('waktu_publikasi', ascending: false).limit(4),
      ]);

      if (!mounted) return;

      // 1. Proses data pengguna
      final userData = results[0] as Map<String, dynamic>?;
      _pengguna = userData != null
          ? PenggunaModel.fromMap(userData)
          : PenggunaModel(namaLengkap: 'Pengguna', totalPoin: 0);

      // 2. Proses total berat sampah
      final totalBeratData = results[1];
      _totalBeratSampah =
          totalBeratData is num ? totalBeratData.toDouble() : 0.0;

      // 3. Proses data bank sampah
      final bankSampahData = results[2] as Map<String, dynamic>?;
      _bankSampah =
          bankSampahData != null ? BankSampahModel.fromMap(bankSampahData) : null;

      // 4. Proses data artikel
      final articleData = results[3] as List?;
      _articles =
          articleData != null ? List<Map<String, dynamic>>.from(articleData) : [];
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /// Navigasi ke halaman detail artikel
  void _navigateToDetailArtikel(Map<String, dynamic> article) {
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailArtikel(
          title: article['judul_artikel'] ?? 'Judul Tidak Tersedia',
          content: article['detail_artikel'] ?? 'Konten tidak tersedia.',
          date: _formatDate(
              article['waktu_publikasi'] ?? DateTime.now().toIso8601String()),
          image: article['foto'] ?? '',
          author:
              article['bank_sampah']?['nama_bank_sampah'] ?? 'Penulis Anonim',
          authorPhoto: article['bank_sampah']?['foto'],
        ),
      ),
    );
  }

  /// Format tanggal dari ISO string ke format "DD NamaBulan YYYY"
  String _formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      const months = [
        'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
        'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return dateString; // Kembalikan string asli jika format salah
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF3D8D7A)))
          : RefreshIndicator(
              onRefresh: _refreshData,
              color: const Color(0xFF3D8D7A),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    //const SizedBox(height: 24),
                    //_buildGreeting(),
                    const SizedBox(height: 20),
                    _buildPoinCard(),
                    const SizedBox(height: 24),
                    _buildActionButtons(),
                    const SizedBox(height: 30),
                    _buildBankSampahSection(),
                    const SizedBox(height: 30),
                    _buildArtikelSection(),
                  ],
                ),
              ),
            ),
    );
  }

  //======================================================================
  // 3. WIDGET BUILDER HELPERS (Memecah UI)
  //======================================================================

  /// Widget untuk Header (Foto profil dan notifikasi)
  Widget _buildHeader() {
    // --- Logika untuk gambar profil ---
    String? photoUrl = _pengguna?.fotoUrl;
    ImageProvider backgroundImage = const AssetImage('assets/maskot-trashscan.png'); // Gambar default
    if (photoUrl != null && photoUrl.isNotEmpty) {
      backgroundImage = NetworkImage(photoUrl);
    }

    // --- Logika untuk nama panggilan ---
    final firstName = _pengguna?.namaLengkap.split(' ').first ?? 'Pengguna';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // --- Foto Profil ---
        CircleAvatar(
          radius: 28,
          backgroundColor: const Color(0xFFA3D1C6).withOpacity(0.5),
          backgroundImage: backgroundImage,
        ),
        const SizedBox(width: 12),

        // --- Sapaan "Halo, Nama!" ---
        Text.rich(
          TextSpan(
            style: GoogleFonts.montserrat(fontSize: 24, color: Colors.black, height: 1.2),
            children: [
              const TextSpan(text: 'Halo,\n'), // Gunakan \n untuk baris baru jika diperlukan
              TextSpan(
                text: '$firstName!',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),

        const Spacer(), // Mendorong notifikasi ke kanan

        // --- Ikon Notifikasi ---
        Stack(
          children: [
            const Icon(Icons.notifications_none_outlined, size: 32, color: Colors.black54),
            Positioned(
              right: 2,
              top: 2,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                child: const Text(
                  '3',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Widget untuk sapaan "Halo, [Nama]!"
  Widget _buildGreeting() {
    // Mengambil kata pertama dari nama lengkap
    final firstName = _pengguna?.namaLengkap.split(' ').first ?? 'Pengguna';
    return Row(
      children: [
        Text(
          'Halo, ',
          style: GoogleFonts.montserrat(
            fontSize: 28,
            color: Colors.black,
          ),
        ),
        Text(
          '$firstName!',
          style: GoogleFonts.montserrat(
            fontSize: 28,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// Widget untuk kartu informasi poin dan total sampah
// GANTI method _buildPoinCard() Anda dengan kode ini
/// Widget untuk kartu informasi poin dan total sampah dengan desain baru
  Widget _buildPoinCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFA3D1C6),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFA3D1C6).withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none, // Izinkan ikon keluar dari batas Stack
        children: [
          // --- Ikon Recycle di Latar Belakang ---
          Positioned(
            right: 0, // Atur posisi agar ikon sedikit keluar
            top: -10,
            bottom: -10,
            child: Icon(
              Icons.recycling_rounded,
              size: 105,
              color: const Color(0xFF3D8D7A).withOpacity(0.7),
            ),
          ),

          // --- Konten Utama (Teks, Poin, Tombol) ---
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Poin yang terkumpul',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1E5245),
                ),
              ),
              const SizedBox(height: 8),

              // --- Tampilan Poin ---
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.orange,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.star_rounded, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${_pengguna?.totalPoin ?? 0} Poin',
                    style: GoogleFonts.montserrat(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF1E5245),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // --- Baris Bawah (Tukar Poin & Kg Sampah) ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Tombol Tukar Poin
                  GestureDetector(
                    onTap: () => MenuStateProvider.of(context)?.changeTab(3),
                    child: Text(
                      'Tukar Poin!',
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E5245),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  // Info Kg Sampah
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_totalBeratSampah.toStringAsFixed(0)} Kg Sampah Terkumpul',
                      style: GoogleFonts.montserrat(
                        color: const Color(0xFF3D8D7A),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Widget untuk tombol aksi utama
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            icon: Icons.search_outlined,
            label: 'Kenali Sampah',
            onTap: () => MenuStateProvider.of(context)?.changeTab(2), // Navigasi ke tab Kenali Sampah
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _ActionButton(
            icon: Icons.restore_from_trash,
            label: 'Setor Sampah',
            onTap: () => MenuStateProvider.of(context)?.changeTab(1), // Navigasi ke tab Setor Sampah
          ),
        ),
      ],
    );
  }
  
  /// Widget untuk menampilkan bagian Bank Sampah
  Widget _buildBankSampahSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Lokasi Bank Sampah',
            style: GoogleFonts.montserrat(
                fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        if (_bankSampah != null)
          _WasteBankCard(
            bank: _bankSampah!,
            //jarak: '1.4 KM', // Jarak masih statis sesuai kode lama
          )
        else
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Center(
                child: Text('Tidak ada data bank sampah terdekat.',
                    style: TextStyle(color: Colors.grey))),
          ),
      ],
    );
  }

  /// Widget untuk menampilkan daftar artikel
  Widget _buildArtikelSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Artikel Untukmu',
                style: GoogleFonts.montserrat(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            GestureDetector(
              onTap: () => MenuStateProvider.of(context)?.changeTab(2),
              child: Text('Lihat Semua',
                  style: GoogleFonts.montserrat(
                      color: const Color(0xFF3D8D7A),
                      fontWeight: FontWeight.w600)),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text('Edukasi untuk bumi yang lebih baik.',
            style: GoogleFonts.montserrat(color: Colors.black54, fontSize: 14)),
        const SizedBox(height: 16),
        if (_articles.isEmpty)
           Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Center(
                child: Text('Belum ada artikel yang tersedia.',
                    style: TextStyle(color: Colors.grey))),
          )
        else
          ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _articles.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final article = _articles[index];
              return _ArticleCard(
                article: article,
                onTap: () => _navigateToDetailArtikel(article),
              );
            },
          ),
      ],
    );
  }
}

//======================================================================
// 4. WIDGET-WIDGET KUSTOM (Reusable Components)
//======================================================================

/// Kartu untuk menampilkan informasi Bank Sampah.
class _WasteBankCard extends StatelessWidget {
  final BankSampahModel bank;

  const _WasteBankCard({required this.bank});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              bank.fotoUrl ?? '',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 50,
                height: 50,
                color: const Color(0xFFE8F5F0),
                child: const Icon(Icons.business_rounded, color: Color(0xFF3D8D7A)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bank.nama,
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold, fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  bank.alamat,
                  style: GoogleFonts.montserrat(color: Colors.grey[600], fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // BAGIAN Ikon Lokasi dan Jarak SUDAH DIHAPUS DARI SINI
        ],
      ),
    );
  }
}

/// Kartu untuk menampilkan item artikel.
class _ArticleCard extends StatelessWidget {
  final Map<String, dynamic> article;
  final VoidCallback onTap;

  const _ArticleCard({required this.article, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final String imageUrl = article['foto'] ?? '';
    final String title = article['judul_artikel'] ?? 'Judul Tidak Tersedia';

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(12),
           decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
               border: Border.all(color: Colors.grey.shade200, width: 1.5)
            ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  width: 75,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 75,
                    height: 70,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
                  ),
                   loadingBuilder: (context, child, progress) => progress == null
                    ? child
                    : SizedBox(
                        width: 75,
                        height: 70,
                        child: Center(child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF3D8D7A),)),
                      ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w700, fontSize: 13),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Baca Selengkapnya',
                          style: GoogleFonts.montserrat(
                              color: const Color(0xFF3D8D7A),
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_forward_ios,
                            size: 12, color: Color(0xFF3D8D7A)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Tombol aksi dengan ikon dan label.
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: const Color(0xFF1E5245)),
      label: Text(label, style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 14)),
      style: ElevatedButton.styleFrom(
        foregroundColor: const Color(0xFF1E5245),
        backgroundColor: const Color(0xFFA3D1C6).withOpacity(0.7),
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}

/// Chip kecil untuk menampilkan info dengan ikon.
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  const _InfoChip({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Icon(icon, color: foregroundColor, size: 20),
          const SizedBox(width: 6),
          Text(label,
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold,
                  color: foregroundColor,
                  fontSize: 14)),
        ],
      ),
    );
  }
}