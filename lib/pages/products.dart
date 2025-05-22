import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:benefeat/pages/product_class.dart';
import 'package:benefeat/constants/databases.dart';
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
  late Future<List<Product>> _productsFuture;
  
  String _query = "";

  void _updateQuery(String newValue) {
    setState(() {
      _query = newValue;
    });
  }

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

  Future<void> _removeFromCart(Product product) async {
    setState(() {
      _cart.remove(product);
    });
    saveCart();
  }

  @override
  void initState() {
    super.initState();
    _searchBarFocusNode.addListener(() {
      setState(() {
        _isSearchBarFocused = _searchBarFocusNode.hasFocus;
      });
    });
    _productsFuture = fetchProducts();
    loadCart();
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
      body: body(context, _query, _updateQuery, _isSearchBarFocused, _searchBarFocusNode, _productsFuture, _addToCart),
      floatingActionButton: floatingActionButton(context, _cart, _removeFromCart),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

Widget body(BuildContext context, String query, Function updateQuery, bool isSearchBarFocused, FocusNode searchBarFocusNode, Future<List<Product>> productsFuture, Function addToCart) {
  return Column(
    children: [
      SizedBox(height: constants.APPBAR_HEIGHT + 40),
      
      // Search bar
      Center(
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
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
                padding: EdgeInsets.only(left: 20, right: 10),
                child: Image.asset(
                  "assets/other_icons/search_grey.png",
                  width: 15,
                ),
              ),
              prefixIconConstraints: BoxConstraints(
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
              contentPadding: EdgeInsets.symmetric(horizontal: 15),
            ),
            style: TextStyle(
              color: colors.black,
              fontSize: 14,
            ),
            onChanged: (value) {
              updateQuery(value);
            },
            onTapOutside: (event) => FocusScope.of(context).unfocus(),
          ),
        ),
      ),
      
      SizedBox(height: 15),

      // Products grid
      Expanded(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
          child: FutureBuilder<List<Product>>(
            future: productsFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
              final products = snapshot.data!;
              // Filter products by query
              final filteredProducts = query.isEmpty
                  ? products
                  : products.where((p) =>
                      p.name.toLowerCase().contains(query.toLowerCase()) ||
                      p.brand.toLowerCase().contains(query.toLowerCase())
                    ).toList();
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: .7,
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) => productWidget(context, filteredProducts[index], addToCart),
              );
            },
          ),
        ),
      ),
    ],
  );
}



void openCartPage(BuildContext context, List<Product> cart, Future<void> Function(Product) removeFromCart) {
  showModalBottomSheet(
    context: context,
    backgroundColor: colors.white,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => FractionallySizedBox(
      heightFactor: 0.85,
      child: Padding(
        padding: EdgeInsets.all(24),
        child: StatefulBuilder(
          builder: (context, setModalState) => Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Drag handle
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

              SizedBox(height: 10,),
              
              // Title
              Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                  "Votre panier",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),
              ),
              
              // Cart items list (scrollable)
              Expanded(
                child: cart.isEmpty
                  ? Center(
                    child: Text(
                      "Votre panier est vide",
                      style: TextStyle(fontSize: 18, color: colors.grey),
                    ),
                  )
                  : ListView.separated(
                      itemCount: cart.length,
                      separatorBuilder: (_, __) => Divider(height: 1),
                      itemBuilder: (context, index) {
                        final product = cart[index];
                        return ListTile(
                          leading: Image.asset(
                            "assets/account/user_defaultpfp.png",
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                          title: Text(
                            product.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                product.brand,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                product.quantity,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Image.asset("assets/other_icons/trash.png", width: 20,),
                            onPressed: () async {
                              await removeFromCart(product);
                              setModalState(() {});
                            },
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                        );
                      },
                    ),
              ),
              
              // Fixed button at the bottom
              SizedBox(height: 16),

              if (cart.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Text(
                    "Total : ${cart.fold<double>(0, (sum, p) => sum + (p.price)).toStringAsFixed(2)} €",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                ),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (cart.isNotEmpty) {
                      // TODO voir suggestions
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cart.isEmpty ? colors.grey : colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: Text(
                    "Voir les suggestions",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    ),
  );
}

Widget floatingActionButton(BuildContext context, List<Product> cart, Future<void> Function(Product) removeFromCart) {
  return Stack(
    alignment: Alignment.center,
    children: [
      FloatingActionButton(
        onPressed: () {
          openCartPage(context, cart, removeFromCart);
        },
        backgroundColor: cart.isEmpty ? colors.grey : colors.red,
        shape: CircleBorder(),
        elevation: 6,
        child:  Icon(Icons.shopping_cart, size: 28, color: Colors.white),
      ),
      if (cart.isNotEmpty)
        Positioned(
          right: 0,
          top: 0,
          child: CircleAvatar(
            radius: 12,
            backgroundColor: Colors.red,
            child: Text(
              '${cart.length}',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
    ],
  );
}



Widget productWidget(BuildContext context, Product product, Function addToCart) {
  return GestureDetector(
    child: Container(
      decoration: BoxDecoration(
        color: colors.lightgrey,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          spacing: 3,
          children: [
            Spacer(),
            Text(
              product.name,
              style: TextStyle(fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(product.brand, maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(product.quantity, maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(
              '${product.price} €',
              style: TextStyle(fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ),
    onTap: () {
      openUpProductInfo(context, product, addToCart);
    },
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
          spacing: 10,
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
              child: Text(
                "Ajouter au panier",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
            SizedBox(),
          ],
        ),
      ),
    )
  );
}


double parseDouble(dynamic value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value.replaceAll(',', '.')) ?? 0.0;
  return 0.0;
}

Future<List<Product>> fetchProducts() async {
  final db = await DatabaseHelper.database;
  final List<Map<String, dynamic>> maps = await db.query('auchan');
  //print(maps);
  //print(maps.length);
  final productsList = <Product>[];
  for (int i = 0; i < maps.length; i++) {
    try {
      final map = maps[i];
      productsList.add(Product(
        name: map['Item'],
        brand: map['Brand'],
        price: parseDouble(map['Price']),
        pricePerQuantity: parseDouble(map['Price/Qt']),
        quantity: map['Quantity'],
        quantityType: map['Quantity_Type'],
      ));
    } catch (e, stack) {
      print('Error at iteration $i: $e');
      print(stack);
      break; // Stop the loop if there's an error
    }
  }
  //print("/// coucoucoucoucou ///");
  //print(productsList);
  return productsList;
}