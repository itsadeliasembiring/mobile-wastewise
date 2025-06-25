import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

class PointsProvider with ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  
  int _totalPoints = 0;
  bool _isLoading = false;
  String? _error;

  int get totalPoints => _totalPoints;
  bool get isLoading => _isLoading;
  String? get error => _error;

  PointsProvider() {
    // Listener untuk auto-refresh poin saat login/logout
    _supabase.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      if (session != null) {
        fetchPoints(forceRefresh: true);
      } else {
        _clearData();
      }
    });
  }

  /// Mengambil data poin terbaru dari server.
  Future<void> fetchPoints({bool forceRefresh = false}) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      _clearData();
      return;
    }

    // Hindari fetch berlebihan jika sudah ada data, kecuali dipaksa
    if (!forceRefresh && _totalPoints > 0) return;

    try {
      _isLoading = true;
      notifyListeners();

      final response = await _supabase
          .from('pengguna')
          .select('total_poin')
          .eq('id_pengguna', userId)
          .single();
      
      _totalPoints = response['total_poin'] ?? 0;
      _error = null;
    } catch (e) {
      _error = "Gagal memuat data poin: $e";
      debugPrint(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// [LOGIKA BARU] Memanggil RPC 'handle_exchange' untuk penukaran barang.
  /// Jauh lebih sederhana dan aman.
  Future<String> exchangeItem({
    required String itemId,
    required int points, // Dibutuhkan untuk update UI sementara
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('Sesi berakhir. Silakan login kembali.');

    try {
      // Memanggil fungsi 'handle_exchange' di database
      final redemptionCode = await _supabase.rpc('handle_exchange', params: {
        'item_id_in': itemId,
        'user_id_in': userId,
      });

      // Jika RPC berhasil, update state lokal untuk respon UI yang cepat
      _totalPoints -= points;
      notifyListeners();
      
      return redemptionCode as String;

    } on PostgrestException catch (e) {
      // Menangkap error custom dari fungsi PostgreSQL dan menerjemahkannya
      if (e.message.contains('STOK_HABIS')) {
        throw Exception('Stok barang ini sudah habis atau ditukar pengguna lain.');
      } else if (e.message.contains('POIN_TIDAK_CUKUP')) {
        throw Exception('Poin Anda tidak mencukupi untuk menukar barang ini.');
      }
      debugPrint('Supabase error: ${e.message}');
      throw Exception('Gagal melakukan penukaran. Silakan coba lagi.');
    } catch (e) {
      debugPrint('Generic error: $e');
      throw Exception('Terjadi kesalahan yang tidak diketahui.');
    }
  }

  /// [LOGIKA BARU] Memanggil RPC 'handle_donation' untuk donasi.
  Future<void> donatePoints({
    required String donationId,
    required int points,
  }) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) throw Exception('Sesi berakhir. Silakan login kembali.');
    
    try {
      // Memanggil fungsi 'handle_donation' di database
      await _supabase.rpc('handle_donation', params: {
        'donation_id_in': donationId,
        'user_id_in': userId,
        'points_to_donate': points,
      });

      // Jika RPC berhasil, update state lokal
      _totalPoints -= points;
      notifyListeners();

    } on PostgrestException catch (e) {
      if (e.message.contains('Poin Anda tidak mencukupi')) {
        throw Exception('Poin Anda tidak mencukupi untuk melakukan donasi ini.');
      }
      debugPrint('Supabase error: ${e.message}');
      throw Exception('Gagal melakukan donasi. Silakan coba lagi.');
    } catch (e) {
      debugPrint('Generic error: $e');
      throw Exception('Terjadi kesalahan yang tidak diketahui.');
    }
  }

  /// Membersihkan data saat pengguna logout.
  void _clearData() {
    _totalPoints = 0;
    _error = null;
    notifyListeners();
  }
}
