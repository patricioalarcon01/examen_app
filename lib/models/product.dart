class Product {
  final int id;
  final String name;
  final double price;
  final String imageUrl;
  final String state;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.state,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['product_id'] ?? 0,
        name: json['product_name'] ?? '',
        price: (json['product_price'] is num)
            ? (json['product_price'] as num).toDouble()
            : double.tryParse('${json['product_price']}') ?? 0.0,
        imageUrl: json['product_image'] ?? '',
        state: json['product_state'] ?? '',
      );

  Map<String, dynamic> toJson() {
    final num normalizedPrice =
        price % 1 == 0 ? price.toInt() : double.parse(price.toStringAsFixed(2));

    return {
      'product_id': id,
      'product_name': name,
      'product_price': normalizedPrice,
      'product_image': imageUrl,
      'product_state': state,
    };
  }
}
