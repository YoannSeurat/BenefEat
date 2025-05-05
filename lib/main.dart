import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:benefeat/pages/home.dart';
import 'package:benefeat/pages/favorites.dart';
import 'package:benefeat/pages/products.dart';
import 'package:benefeat/pages/user/account.dart';
import 'package:benefeat/constants/colors.dart' as colors;
import 'package:benefeat/constants/constants.dart' as constants;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // pour eviter que certaines images bug quand elles sont load pour la premiere fois
    precacheImage(AssetImage("assets/navbar/home_inactive.png"), context);
    precacheImage(AssetImage("assets/navbar/products_active.png"), context);
    precacheImage(AssetImage("assets/navbar/star_active.png"), context);
    precacheImage(AssetImage("assets/navbar/userprofile_active.png"), context);
    precacheImage(AssetImage("assets/backgrounds/loginpage_background.png"), context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BenefEat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: colors.darkred),
        fontFamily: 'Chillax', // Default font, see : pubspec.yaml
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const ProductsPage(),
    const FavoritesPage(),
    const AccountPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: customNavigationBar(_selectedIndex, _onItemTapped),
      backgroundColor: colors.white,
    );
  }
}

//! Animer la transition entre pages 
/* body: AnimatedSwitcher(
  duration: const Duration(milliseconds: 300),
  switchInCurve: Curves.easeInOut,
  //switchOutCurve: Curves.easeInOut,
  transitionBuilder: (Widget child, Animation<double> animation) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    );
  },
  child: _pages[_selectedIndex],
), */

AppBar appBar() {
  return AppBar(
    backgroundColor: colors.white.withAlpha(50),
    toolbarHeight: constants.APPBAR_HEIGHT,
    flexibleSpace: ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          color: Colors.transparent,
        ),
      ),
    ),
    elevation: 0,

    title: Image.asset(
      'assets/logos/logo_transparent_redblack.png',
      width: 70,
    ),
    centerTitle: true,
  );
}

/* ClipRRect navigationBar(int selectedIndex, Function(int) onItemTapped) {
  return ClipRRect(
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(30.0),
      topRight: Radius.circular(30.0),
    ),
    child: NavigationBar(
      onDestinationSelected: onItemTapped,
      selectedIndex: selectedIndex,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      backgroundColor: colors.darkred,
      animationDuration: const Duration(milliseconds: 200),
      height: constants.NAVBAR_HEIGHT,
      indicatorColor: Colors.transparent,
      destinations: [
        NavigationDestination(
          icon: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Image.asset(
                  selectedIndex == 0
                    ? "assets/navbar/home_active.png"
                    : "assets/navbar/home_inactive.png",
                  width: constants.NAVBAR_ICON_WIDTH,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Accueil',
                style: TextStyle(
                  color: selectedIndex == 0 ? Colors.white : colors.lightgreyred,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          label: 'Accueil',
        ),
        NavigationDestination(
          icon: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Image.asset(
                  selectedIndex == 1
                    ? "assets/navbar/products_active.png"
                    : "assets/navbar/products_inactive.png",
                  width: constants.NAVBAR_ICON_WIDTH,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Produits',
                style: TextStyle(
                  color: selectedIndex == 1 ? Colors.white : colors.lightgreyred,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          label: 'Produits',
        ),
        NavigationDestination(
          icon: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Image.asset(
                  selectedIndex == 2
                    ? "assets/navbar/star_active.png"
                    : "assets/navbar/star_inactive.png",
                  width: constants.NAVBAR_ICON_WIDTH,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Favoris',
                style: TextStyle(
                  color: selectedIndex == 2 ? Colors.white : colors.lightgreyred,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          label: 'Favoris',
        ),
        NavigationDestination(
          icon: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Image.asset(
                  selectedIndex == 3
                    ? "assets/navbar/userprofile_active.png"
                    : "assets/navbar/userprofile_inactive.png",
                  width: constants.NAVBAR_ICON_WIDTH,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Profil',
                style: TextStyle(
                  color: selectedIndex == 3 ? Colors.white : colors.lightgreyred,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          label: 'Profil',
        ),
      ],
    ),
  );
} */


Widget customNavigationBar(int selectedIndex, Function(int) onItemTapped) {
  return ClipRRect(
    borderRadius: const BorderRadius.only(
      topLeft: Radius.circular(30.0),
      topRight: Radius.circular(30.0),
    ),
    child: Container(
      color: colors.darkred,
      height: constants.NAVBAR_HEIGHT,
      //padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          navItem(0, selectedIndex, onItemTapped, "Accueil", "home"),
          navItem(1, selectedIndex, onItemTapped, "Produits", "products"),
          navItem(2, selectedIndex, onItemTapped, "Favoris", "star"),
          navItem(3, selectedIndex, onItemTapped, "Profil", "userprofile"),
        ],
      ),
    ),
  );
}

Widget navItem(int index, int selectedIndex, Function(int) onItemTapped, String label, String assetName) {
  final isSelected = selectedIndex == index;
  return GestureDetector(
    onTap: () => onItemTapped(index),
    child: Container(
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            width: constants.NAVBAR_ICON_WIDTH + (isSelected ? 5 : 0),
            child: Image.asset(
              isSelected
                  ? "assets/navbar/${assetName}_active.png"
                  : "assets/navbar/${assetName}_inactive.png",
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : colors.lightgreyred,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    )
  );
}
