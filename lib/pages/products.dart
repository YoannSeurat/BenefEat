import 'package:flutter/material.dart';

import 'package:benefeat/constants/colors.dart' as colors;
import 'package:benefeat/constants/constants.dart' as constants;

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final FocusNode _searchBarFocusNode = FocusNode();
  bool _isSearchBarFocused = false;

  @override
  void initState() {
    super.initState();
    _searchBarFocusNode.addListener(() {
      setState(() {
        _isSearchBarFocused = _searchBarFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _searchBarFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.white,
      body: body(context, _isSearchBarFocused, _searchBarFocusNode),
    );
  }
}

Container body(BuildContext context, bool isSearchBarFocused, FocusNode searchBarFocusNode) {
  return Container(
    child: SingleChildScrollView(
      child: Column(
        spacing: 30,
        children: [
          SizedBox(height: constants.APPBAR_HEIGHT + 50,),

          // searchbar
          Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.bounceIn,
              height: 45,
              width: isSearchBarFocused
                  ? MediaQuery.of(context).size.width * 0.9
                  : MediaQuery.of(context).size.width * 0.85,
              decoration: BoxDecoration(
                color: colors.kindalightgrey,
                borderRadius: BorderRadius.circular(45),
                boxShadow: isSearchBarFocused
                    ? [
                        BoxShadow(
                          color: Colors.black.withAlpha(20),
                          blurRadius: 10,
                        ),
                      ]
                    : [],
              ),
              child: TextField(
                focusNode: searchBarFocusNode,
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 10),
                    child: Image.asset(
                      "assets/searchbar/search_grey.png",
                      width: 15,
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 25,
                    minHeight: 25,
                  ),
                  hintText: "Store, product, brand, ...",
                  hintStyle: TextStyle(
                    color: colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                ),
                style: TextStyle(
                  color: colors.black,
                  fontSize: 14,
                ),
                onChanged: (value) {
                  // TODO: Implement search logic here
                  print("query: $value");
                },
                onTapOutside: (event) => FocusScope.of(context).unfocus(),
              ),
            ),
          ),

          // products
          Column(
            children: List.generate(7, (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.0),
              // TODO child : product()
            ),),
          )
        ],
      ),
    ),
  );
}