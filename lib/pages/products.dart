import 'package:flutter/material.dart';

import 'package:benefeat/constants/colors.dart' as colors;
import 'package:benefeat/constants/constants.dart' as constants;

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.white,
      body: body(),
    );
  }
}

Container body() {
  return Container(
    decoration: BoxDecoration(
      color: colors.blue
    ),
    child: SingleChildScrollView(
      child: Column(
        children: [

        ],
      ),
    ),
  );
}