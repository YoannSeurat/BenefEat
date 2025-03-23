import 'package:flutter/material.dart';
import 'package:benefeat/design/colors.dart' as colors;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      bottomNavigationBar: navigationBar(),
    );
  }
}

/* "BenefEat" text black+red
Text.rich(
  TextSpan(
    children: [
      TextSpan(
        text: "Benef",
        style: TextStyle(
          color: colors.black,
          fontWeight: FontWeight.w600,
          fontSize: 26,
        ),
      ),
      TextSpan(
        text: "Eat",
        style: TextStyle(
          color: colors.darkred,
          fontWeight: FontWeight.w600,
          fontSize: 26,
        ),
      ),
    ],
  ),
),
*/

AppBar appBar() {
  return AppBar(
    leading: GestureDetector(
      onTap: () {
        // foo()
      },
      child: Container(
        margin: EdgeInsets.only(left: 20, top: 10),
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
    backgroundColor: colors.white,
    actions: [
      GestureDetector(
        onTap: () {
          // foo()
        },
        child: Container(
          margin: EdgeInsets.only(right: 20, top: 10, bottom: 10),
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

ClipRRect navigationBar() {
  return ClipRRect(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(20.0),
      topRight: Radius.circular(20.0),
    ),
    child: NavigationBar(
      onDestinationSelected: (int index) {},
      selectedIndex: 0,
      destinations: [
        NavigationDestination(
          icon: Column(
            mainAxisAlignment: MainAxisAlignment.end, // Center the icon and text
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Image.asset(
                  "assets/navbar/home_active.png",
                  width: 20,
                ),
              ),
              SizedBox(height: 4), // Add spacing between icon and text
              Text(
                'Accueil',
                style: TextStyle(
                  color: colors.white,
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
                  "assets/navbar/recipes_inactive.png",
                  width: 20,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Recettes',
                style: TextStyle(
                  color: colors.lightgreyred,
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
                  "assets/navbar/star_inactive.png",
                  width: 20,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Favoris',
                style: TextStyle(
                  color: colors.lightgreyred,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          label: 'Favoris',
        ),
      ],
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      labelTextStyle: WidgetStateProperty.all(
        TextStyle(color: colors.white),
      ),
      backgroundColor: colors.darkred,
      animationDuration: Duration(milliseconds: 200),
      height: 60,
      indicatorColor: Colors.transparent,
    ),
  );
}