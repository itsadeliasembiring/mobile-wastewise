import 'package:flutter/material.dart';

// Import semua halaman yang akan digunakan
import './SplashScreen/splash_screen.dart';
import './Autentikasi/autentikasi.dart';
import 'Login/login.dart';
import 'Register/register.dart';
import 'LupaPassword/lupa_password.dart';
import '../Menu/menu.dart';
import '../SetorSampah/detail_setor_sampah.dart';
import '../SetorSampah/riwayat_setor_sampah.dart';
import '../SetorSampah/pilih_sampah.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => SplashScreen(),
  '/auth': (context) => Autentikasi(),
  '/form-login': (context) => Masuk(),
  '/form-register': (context) => Daftar(),
  '/form-lupa-password': (context) => LupaPassword(),
  '/menu': (context) => Menu(),
  '/detail-setor': (context) {
    final String idSetor = ModalRoute.of(context)!.settings.arguments as String;
    return DetailSetorSampah(idSetor: idSetor);
  },
  '/riwayat-setor': (context) => const RiwayatSetorSampah(),
  '/pilih-sampah': (context) => const PilihSampah(),
};
