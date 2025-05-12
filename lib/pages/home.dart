import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:benefeat/constants/colors.dart' as colors;
import 'package:benefeat/constants/constants.dart' as constants;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.white,
      body: const HomeContent(),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (_isFocused) {
          _focusNode.unfocus(); // Enlève le focus et donc retire le flou
        }
      },
      child: Stack(
        children: [
          // ✅ Contenu principal
          IgnorePointer(
            ignoring: _isFocused,
            child: Opacity(
              opacity: _isFocused ? 0.4 : 1,
              child: Column(
                children: [
                  SizedBox(height: constants.APPBAR_HEIGHT + 100),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ✅ Flou si focus
          if (_isFocused)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),

          // ✅ Barre de recherche
          Positioned(
            top: constants.APPBAR_HEIGHT + 60,
            left: 20,
            right: 20,
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _isFocused
                    ? MediaQuery.of(context).size.width * 0.95
                    : MediaQuery.of(context).size.width * 0.85,
                height: _isFocused ? 60 : 50,
                child: TextField(
                  focusNode: _focusNode,
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Store, product, recipe...',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset(
                        'assets/searchbar/search_grey.png',
                        width: 20,
                        height: 20,
                      ),
                    ),
                    filled: true,
                    fillColor: const Color(0xC1C1C1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
