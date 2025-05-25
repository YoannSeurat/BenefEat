import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:url_launcher/url_launcher.dart';
import 'package:benefeat/constants/colors.dart' as colors;
import 'package:benefeat/constants/constants.dart' as constants;
class HelpAndContactPage extends StatelessWidget {
  const HelpAndContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.white,
      appBar: appBar(),
      body: body(),
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
        child: Container(color: Colors.transparent),
      ),
    ),
    elevation: 0,
    title: Image.asset('assets/logos/logo_transparent_redblack.png', width: 70),
    centerTitle: true,
  );
}

Container body() {
  return Container(
    height: double.infinity,
    width: double.infinity,
    alignment: Alignment.center,
    child: Stack(
      children: [
        Align(
          alignment: const Alignment(0, -0.2), // Move content a bit up
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Besoin d'aide ?\nContactez-nous à tout moment :\n",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              GestureDetector(
                onTap: () async {
                  final Uri emailLaunchUri = Uri(
                    scheme: 'mailto',
                    path: 'benefeatefrei@gmail.com',
                  );
                  await launchUrl(emailLaunchUri);
                },
                child: const Text(
                  'benefeatefrei@gmail.com',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Copyright 
        Positioned(
          left: 0,
          right: 0,
          bottom: 32,
          child: const Text(
            '© 2025 BenefEat. Tous droits réservés.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
  );
}