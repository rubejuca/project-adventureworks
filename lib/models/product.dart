// TODO Implement this library.
class Product {
  final int id;
  final String name;
  final String productNumber;
  final String? color;
  final double listPrice;

  const Product({
    required this.id,
    required this.name,
    required this.productNumber,
    required this.listPrice,
    this.color,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['ProductID'] as int,
      name: json['Name'] as String,
      productNumber: json['ProductNumber'] as String,
      color: json['Color'] as String?,
      listPrice: (json['ListPrice'] as num).toDouble(),
    );
  }
}
