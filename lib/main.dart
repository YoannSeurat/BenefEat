import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:benefeat/pages/home.dart';
import 'package:benefeat/pages/favorites.dart';
import 'package:benefeat/pages/products.dart';
import 'package:benefeat/pages/user/settings.dart';
import 'package:benefeat/pages/user/account.dart';
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

    title: Image.asset(
      'assets/logos/logo_transparent_redblack.png',
      width: 70,
    ),
    centerTitle: true,

    /*
    actions: [ // Profile
      Builder(
        builder: (context) {
          return GestureDetector(
            onTap: () { // Open dropdown user list
              showMenu(
                context: context,
                position: const RelativeRect.fromLTRB(100, 120, 10, 0),
                popUpAnimationStyle: AnimationStyle(
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 300),
                  reverseCurve: Curves.easeInOut,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: colors.whiter,

                items: [
                  PopupMenuItem(
                    value: 'account',
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        Image.asset('assets/appbar/userprofile_black.png', width: 25,),
                        const SizedBox(width: 10),
                        const Text('Compte'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'settings',
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        Icon(Icons.settings, color: colors.black,),
                        const SizedBox(width: 10),
                        const Text('Paramètres'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        const SizedBox(width: 10),
                        Icon(Icons.logout, color: colors.black),
                        const SizedBox(width: 10),
                        const Text('Se Déconnecter'),
                      ],
                    ),
                  ),
                ],
              ).then((value) {
                if (!context.mounted) return;
                if (value == 'account') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const AccountPage()));
                } else if (value == 'settings') {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
                } else if (value == 'logout') {
                  logout(context);
                }
              });
            },
            child: Container(
              margin: const EdgeInsets.only(right: 20, top: 10, bottom: 10),
              alignment: Alignment.center,
              child: Image.asset(
                'assets/appbar/userprofile_black.png',
                width: 35,
              ),
            ),
          );
        }
      )
    ],
    */
  );
}

void logout(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
      title: const Text('Confirmation'),
      content: const Text('Es tu sûr de vouloir te déconnecter ?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Annuler'),
        ),
        TextButton(
        onPressed: () {
          // TODO en backend : logout le pelo
          Navigator.of(context).pop(); 
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Tu as bien été déconnecté',),
                actions: [
                  TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                  ),
                ],
              );
            },
          );
        },
        child: const Text('Se déconnecter'),
        ),
      ],
      );
    },
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Image.asset(
                  selectedIndex == 0
                    ? "assets/navbar/home_active.png"
                    : "assets/navbar/home_inactive.png",
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Image.asset(
                  selectedIndex == 1
                    ? "assets/navbar/products_active.png"
                    : "assets/navbar/products_inactive.png",
                  width: 20,
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
                  width: 20,
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
}