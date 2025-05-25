class Product {
  String name;
  String brand;
  double price;
  double pricePerQuantity;
  String quantity;
  String quantityType;
  // String link;

  Product({
    required this.name,
    required this.brand,
    required this.price,
    required this.pricePerQuantity,
    required this.quantity,
    required this.quantityType,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'brand': brand,
    'price': price,
    'pricePerQuantity': pricePerQuantity,
    'quantity': quantity,
    'quantityType': quantityType,
  };

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    name: json['name'],
    brand: json['brand'],
    price: (json['price'] as num).toDouble(),
    pricePerQuantity: (json['pricePerQuantity'] as num).toDouble(),
    quantity: json['quantity'],
    quantityType: json['quantityType'],
  );

  @override
  String toString() {
    return 'Product(name: $name, brand: $brand, price: $price, pricePerQuantity: $pricePerQuantity, quantity: $quantity, quantityType: $quantityType)';
  }
}