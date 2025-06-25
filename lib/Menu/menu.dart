import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import '../Beranda/beranda.dart';
import '../SetorSampah/pilih_sampah.dart';
import '../SetorSampah/riwayat_setor_sampah.dart';
import '../Artikel/artikel.dart';
import '../TukarPoin/tukar_poin.dart';
import '../Profil/profil.dart';

// InheritedWidget untuk menyediakan akses ke MenuState
class MenuStateProvider extends InheritedWidget {
  final _MenuState menuState;

  const MenuStateProvider({
    Key? key,
    required this.menuState,
    required Widget child,
  }) : super(key: key, child: child);

  static _MenuState? of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<MenuStateProvider>();
    return provider?.menuState;
  }

  @override
  bool updateShouldNotify(MenuStateProvider oldWidget) {
      return menuState._currentIndex != oldWidget.menuState._currentIndex ||
         menuState._setorSampahSubIndex != oldWidget.menuState._setorSampahSubIndex;
    //return menuState != oldWidget.menuState;
  }
}

class Menu extends StatefulWidget {
  final int initialIndex;
  
  const Menu({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  int _currentIndex = 0;
  int _setorSampahSubIndex = 0; // 0 = PilihSampah, 1 = RiwayatSetor

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void changeTab(int index) {
    setState(() {
      _currentIndex = index;
      if (index != 1) {
        _setorSampahSubIndex = 0; // Reset sub-tab jika bukan setor sampah
      }
    });
  }

  void changeSetorSampahTab(int subIndex) {
    setState(() {
      _setorSampahSubIndex = subIndex;
    });
  }

  Widget _getSetorSampahScreen() {
    if (_setorSampahSubIndex == 0) {
      return PilihSampah();
    } else {
      return RiwayatSetorSampah();
    }
  }

  List<Widget> _getScreens() {
    return [
      Beranda(),
      IndexedStack(
        index: _setorSampahSubIndex,
        children: [
          PilihSampah(),
          RiwayatSetorSampah(),
        ],
      ),
      Artikel(),
      TukarPoin(),
      Profil(),
    ];
  }

  final List<IconData> _icons = [
    Icons.home_rounded,
    Icons.recycling_rounded,
    Icons.search_rounded,
    Icons.stars_rounded,
    Icons.account_circle_rounded,
  ];

  final List<String> _labels = [
    "Beranda",
    "Setor Sampah",
    "Edukasi",
    "Tukar Poin",
    "Profil",
  ];

  @override
  Widget build(BuildContext context) {
    return MenuStateProvider(
      menuState: this,
      child: Scaffold(
        backgroundColor: Color(0xFFF5F6FA),
        body: IndexedStack(
          index: _currentIndex,
          children: _getScreens(),
        ),
        bottomNavigationBar: CurvedNavigationBar(
          key: navigationKey,
          index: _currentIndex,
          items: List.generate(_icons.length, (i) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _icons[i],
                size: 30,
                color: _currentIndex == i ? Colors.white : Color(0xFF3D8D7A),
              ),
              if (_currentIndex != i)
                Text(
                  _labels[i],
                  style: TextStyle(fontSize: 12, color: Color(0xFF3D8D7A)),
                ),
            ],
          )),
          height: 65,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.transparent,
          buttonBackgroundColor: Color(0xFF3D8D7A),
        ),
      ),
    );
  }
}