import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:benefeat/constants/colors.dart' as colors;
import 'package:benefeat/constants/constants.dart' as constants;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final String address = "10 Place de la Bourse, Bordeaux, France";

  Future<void> _openGoogleMaps() async {
    final query = Uri.encodeComponent(address);
    final googleMapsUrl = "https://www.google.com/maps/search/?api=1&query=$query";

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      throw "Impossible d'ouvrir Google Maps";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.white,
      body: body(_openGoogleMaps),
    );
  }
}

Container body(Function openMaps) {
  return Container(
    child: Column(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("BenefEat"),
              SizedBox(height: 20), // Ajoute un espace avant le bouton
              ElevatedButton(
                onPressed: () => openMaps(),
                child: Text("Ouvrir Google Maps"),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
