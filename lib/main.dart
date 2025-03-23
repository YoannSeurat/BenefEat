import 'package:flutter/material.dart';
import 'package:benefeat/pages/home.dart';
import 'package:benefeat/design/colors.dart' as colors;

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      title: 'BenefEat',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: colors.darkred),
        fontFamily: 'Chillax', // Default font, see : pubsec.yaml
      ),
    );
  }
}