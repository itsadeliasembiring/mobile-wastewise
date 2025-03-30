import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Beranda/beranda.dart';
import '../SetorSampah/setor_sampah.dart';
import '../Edukasi/edukasi.dart';
import '../TukarPoint/tukar_point.dart';
import '../Profil/profil.dart';


class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  int index = 0;

  final screens = [
    Beranda(),
    SetorSampah(),
    Edukasi(),
    TukarPoint(),
    Profil(),
  ];

  @override
  Widget build(BuildContext context) {

    final items = List.generate(5, (i) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          [Icons.home_rounded, Icons.recycling_rounded, Icons.search_rounded, Icons.stars_rounded, Icons.account_circle_rounded][i],
          size: 30,
          color: index == i ? Colors.white : Color(0xFF3D8D7A), // Change color when selected
        ),
        if (index != i) // Hide label when selected
          Text(
            ["Beranda", "Setor Sampah", "Edukasi", "Poin", "Profil"][i],
            style: TextStyle(fontSize: 12, color: Color(0xFF3D8D7A)),
          ),
      ],
    ));


    return SafeArea(
      top: false,
      child: 
        Scaffold(
          backgroundColor: Color(0xFFF5F6FA),
          body: screens[index],
          bottomNavigationBar: 
          CurvedNavigationBar(
            key: navigationKey,
            index: index,
            items: items,
            height: 65,
            onTap: (index) => setState(() => this.index = index),
            backgroundColor: Colors.transparent,
            buttonBackgroundColor: Color(0xFF3D8D7A),
          ),
        )
    );
  }
}