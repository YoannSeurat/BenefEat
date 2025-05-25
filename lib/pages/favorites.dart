import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

import 'package:benefeat/pages/product_class.dart';
import 'package:benefeat/pages/products.dart';

import 'package:benefeat/constants/colors.dart' as colors;

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

String favoriteKey(Product product) => '${product.name} __ ${product.quantity}';

class _FavoritesPageState extends State<FavoritesPage> {
  List<Product> _cart = [];

  // Save cart to storage
  Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    // Convert cart to a list of maps, then to JSON
    final cartJson = jsonEncode(_cart.map((p) => p.toJson()).toList());
    await prefs.setString('cart', cartJson);
  }

  // Load cart from storage
  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = prefs.getString('cart');
    if (cartJson != null) {
      final List<dynamic> decoded = jsonDecode(cartJson);
      setState(() {
        _cart = decoded.map((item) => Product.fromJson(item)).toList();
      });
    }
  }

  void _addToCart(Product product) {
    setState(() {
      _cart.add(product);
    });
    saveCart();
  }



  List<String> _favorites = [];
  late Future<List<Product>> _productsFuture;

  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', _favorites);
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favorites = prefs.getStringList('favorites') ?? [];
    });
  }

  Future<void> removeFromFavorites(Product product) async {
    setState(() {
      _favorites.remove(favoriteKey(product));
    });
    saveFavorites();
  }

  @override
  void initState() {
    super.initState();
    _productsFuture = fetchProducts();
    loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors.white,
      body: body(context, _favorites, _productsFuture, removeFromFavorites, _addToCart),
    );
  }
}



Widget body(BuildContext context, List<String> favorites, Future<List<Product>> productsFuture, Function(Product) removeFromFavorites, Function addToCart) {
  return Column(
    children: [
      SizedBox(height: 30,),
      Expanded(
        child: FutureBuilder<List<Product>>(
          future: productsFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
            final products = snapshot.data!;
            final favoriteKeys = favorites.toSet();
            final favoriteProducts = products.where((p) => favoriteKeys.contains(favoriteKey(p))).toList();
            if (favoriteProducts.isEmpty) {
              return Center(child: Text("Aucun favori pour l'instant.", style: TextStyle(fontSize: 16),));
            }
            return ListView.separated(
              itemCount: favoriteProducts.length,
              separatorBuilder: (_, __) => Divider(height: 1),
              itemBuilder: (context, index) {
                final product = favoriteProducts[index];
                return ListTile(
                  leading: Image.asset(
                    "assets/account/user_defaultpfp.png",
                    fit: BoxFit.cover,
                  ),
                  title: Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w600),),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.brand, maxLines: 1, overflow: TextOverflow.ellipsis),
                          Text(product.quantity, maxLines: 1, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                      Text("${product.price} €", maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                    ],
                  ),
                  trailing: GestureDetector(
                    onTap: () async {
                      await removeFromFavorites(product);
                    },
                    child: Image.asset("assets/other_icons/star_fav.png", width: 24),
                  ),
                  onTap: () {
                    openUpProductInfo(context, product, addToCart);
                  },
                );
              },
            );
          },
        ),
      ),
    ],
  );
}



void openUpProductInfo(BuildContext context, Product product, Function addToCart) {
  showModalBottomSheet(
    context: context,
    backgroundColor: colors.white,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => FractionallySizedBox(
      heightFactor: 0.75,
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 5,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            Image.asset(
              "assets/account/user_defaultpfp.png",
              fit: BoxFit.cover,
              height: 170,
            ),

            SizedBox(),
            SizedBox(),

            Text(
              product.name,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            Text(
              product.brand,
              style: TextStyle(fontSize: 16, color: colors.grey),
            ),
            Text(
              product.quantity,
              style: TextStyle(fontSize: 16),
            ),

            Spacer(),
                        
            Text(
              '${product.price} €',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            Text(
              '${product.pricePerQuantity} € / ${product.quantityType}',
              style: TextStyle(fontSize: 15),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(),
            SizedBox(),
            
            ElevatedButton(
              onPressed: () {
                addToCart(product);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.red,
                foregroundColor: colors.white,
                minimumSize: Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 20,
                children: [
                  Icon(Icons.add_shopping_cart_rounded, color: colors.white,),
                  Text(
                    "Ajouter au panier",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(),
          ],
        ),
      ),
    )
  );
}