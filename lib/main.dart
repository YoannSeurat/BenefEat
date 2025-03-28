import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:benefeat/pages/home.dart';
import 'package:benefeat/pages/recipes.dart';
import 'package:benefeat/pages/favorites.dart';
import 'package:benefeat/constants/colors.dart' as colors;
import 'package:benefeat/constants/constants.dart' as constants;

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
    const RecipesPage(),
    const FavoritesPage(),
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
      bottomNavigationBar: navigationBar(_selectedIndex, _onItemTapped),
      backgroundColor: colors.white,
    );
  }
}

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
    leading: GestureDetector(
      onTap: () {
        // TODO : Open sidebar
      },
      child: Container(
        margin: const EdgeInsets.only(left: 20, top: 10),
        alignment: Alignment.center,
        child: Image.asset(
          'assets/appbar/hamburger_black.png',
          width: 25,
        ),
      ),
    ),
    title: Image.asset(
      'assets/logos/logo_transparent_redblack.png',
      width: 70,
    ),
    centerTitle: true,
    actions: [
      GestureDetector(
        onTap: () {
          // TODO : Open dropdown user list
        },
        child: Container(
          margin: const EdgeInsets.only(right: 20, top: 10, bottom: 10),
          alignment: Alignment.center,
          child: Image.asset(
            'assets/appbar/userprofile_black.png',
            width: 35,
          ),
        ),
      )
    ],
  );
}

ClipRRect navigationBar(int selectedIndex, Function(int) onItemTapped) {
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
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Image.asset(
                  selectedIndex == 0
                      ? "assets/navbar/home_active.png" // Active icon
                      : "assets/navbar/home_inactive.png", // Inactive icon
                  width: 20,
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
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Image.asset(
                  selectedIndex == 1
                      ? "assets/navbar/recipes_active.png"
                      : "assets/navbar/recipes_inactive.png",
                  width: 20,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Recettes',
                style: TextStyle(
                  color: selectedIndex == 1 ? Colors.white : colors.lightgreyred,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          label: 'Recettes',
        ),
        NavigationDestination(
          icon: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Image.asset(
                  selectedIndex == 2
                      ? "assets/navbar/star_active.png"
                      : "assets/navbar/star_inactive.png",
                  width: 20,
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
      ],
    ),
  );
}