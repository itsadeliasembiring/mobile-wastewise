// lib/routes.dart
import 'package:flutter/material.dart';
import 'package:mobile_wastewise/SetorSampah/riwayat_setor_sampah.dart';
import './SplashScreen/splash_screen.dart';
import './Autentikasi/autentikasi.dart';
import 'Masuk/masuk.dart';
import 'Daftar/daftar.dart';
import 'LupaPassword/lupa_password.dart';

import '../Menu/menu.dart';
import '../Beranda/beranda.dart';

import 'SetorSampah/pilih_bank_sampah.dart';
import 'SetorSampah/pilih_sampah.dart';

import '../Edukasi/edukasi.dart';

import '../TukarPoint/tukar_point.dart';

import '../Profil/profil.dart';

// import '../SetorSampah/pilih_sampah.dart';
// import '../SetorSampah/detail_pilih_sampah.dart';
// import '../SetorSampah/barcode-jemput.dart';
// import '../SetorSampah/detail_setor_sampah.dart';
// import '../SetorSampah/riwayat-setor-sampah.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => SplashScreen(),
  '/auth': (context) => Autentikasi(),
  '/form-login': (context) => Masuk(),
  '/form-register': (context) => Daftar(),
  '/form-lupa-password': (context) => LupaPassword(),

  '/menu': (context) => Menu(),
  '/beranda': (context) => Beranda(),

  // '/setor-sampah': (context) => SetorSampah(),
  // '/pilih-sampah': (context) => PilihSampah(),

  '/riwayat-setor-sampah': (context) => RiwayatSetorSampah(),
  '/edukasi': (context) => Edukasi(),
  '/tukar-point': (context) => TukarPoint(),
  '/profil': (context) => Profil(),
};
