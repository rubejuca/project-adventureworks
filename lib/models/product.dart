class Product {
  final String id;
  final String name;
  final String productNumber;
  final String? color;
  final double listPrice;
  final String? category;
  final String? description;
  final String? brand;
  final String? status;
  final String? warranty;
  final String? shipping;
  final bool? stock;

  const Product({
    required this.id,
    required this.name,
    required this.productNumber,
    required this.listPrice,
    this.color,
    this.category,
    this.description,
    this.brand,
    this.status,
    this.warranty,
    this.shipping,
    this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    try {
      return Product(
        id: json['id']?.toString() ?? '', // Handle null ID
        name:
            json['name']?.toString() ?? 'Producto sin nombre', // Handle null name
        productNumber:
            json['productNumber']?.toString() ?? '', // Handle null product number
        color: json['color']?.toString(), // Allow null color
        listPrice:
            (json['listPrice'] as num?)?.toDouble() ?? 0.0, // Handle null price
        category: json['category']?.toString(), // Allow null category
        description: json['description']?.toString(), // Allow null description
        brand: json['brand']?.toString(), // Allow null brand
        status: json['status']?.toString(), // Allow null status
        warranty: json['warranty']?.toString(), // Allow null warranty
        shipping: json['shipping']?.toString(), // Allow null shipping
        stock: json['stock'] as bool?, // Allow null stock
      );
    } catch (e) {
      // Return a default product if JSON parsing fails
      print('Error parsing product JSON: $e');
      return Product(
        id: '',
        name: 'Producto sin nombre',
        productNumber: '',
        listPrice: 0.0,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'productNumber': productNumber,
      'color': color,
      'listPrice': listPrice,
      'category': category,
      'description': description,
      'brand': brand,
      'status': status,
      'warranty': warranty,
      'shipping': shipping,
      'stock': stock,
    };
  }

  // Factory constructor for creating a Product from the old static data format
  factory Product.fromStaticData({
    required int id,
    required String name,
    required String productNumber,
    required double listPrice,
    String? color,
  }) {
    return Product(
      id: id.toString(), // Convert int to String
      name: name,
      productNumber: productNumber,
      listPrice: listPrice,
      color: color,
      category: _deriveCategory(name),
      description: _generateDescription(name),
      brand: 'AdventureWorks',
      status: 'Nuevo',
      warranty: '2 años',
      shipping: 'Disponible',
      stock: true,
    );
  }

  // Helper method to derive category from product name
  static String _deriveCategory(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('frame')) {
      return 'Marcos';
    }
    if (lowerName.contains('helmet')) {
      return 'Cascos';
    }
    if (lowerName.contains('sock') ||
        lowerName.contains('jersey') ||
        lowerName.contains('glove')) {
      return 'Ropa';
    }
    if (lowerName.contains('bottle') ||
        lowerName.contains('wash') ||
        lowerName.contains('fender')) {
      return 'Herramientas';
    }
    if (lowerName.contains('pedal') || lowerName.contains('bracket')) {
      return 'Componentes';
    }
    if (lowerName.contains('road') ||
        (lowerName.contains('mountain') && !lowerName.contains('frame'))) {
      return 'Bicicletas';
    }
    return 'Otros';
  }

  // Helper method to generate a description based on product name
  static String _generateDescription(String name) {
    final category = _deriveCategory(name);
    switch (category) {
      case 'Bicicletas':
        return 'Bicicleta de alta calidad diseñada para aventuras épicas. Construida con materiales duraderos y tecnología avanzada para brindar la mejor experiencia de ciclismo. Perfecta para rutas largas y terrenos desafiantes.';
      case 'Marcos':
        return 'Marco robusto y ligero fabricado con aleaciones de alta resistencia. Diseño aerodinámico que optimiza el rendimiento y la velocidad. Compatible con una amplia gama de componentes para personalización completa.';
      case 'Cascos':
        return 'Casco de seguridad con tecnología de absorción de impactos y ventilación avanzada. Diseño ergonómico que garantiza comodidad durante largos recorridos. Cumple con todos los estándares internacionales de seguridad.';
      case 'Ropa':
        return 'Prenda de alta performance fabricada con materiales técnicos que absorben la humedad y proporcionan máxima transpirabilidad. Diseño aerodinámico y ajuste perfecto para óptimo rendimiento deportivo.';
      case 'Herramientas':
        return 'Herramienta esencial para el mantenimiento y cuidado de tu equipo. Fabricada con materiales de primera calidad que garantizan durabilidad y precisión. Diseño ergonómico para uso cómodo y eficiente.';
      case 'Componentes':
        return 'Componente de precisión diseñado para mejorar el rendimiento y la funcionalidad de tu equipo. Fabricado con estándares de calidad superiores y materiales resistentes al desgaste.';
      default:
        return 'Producto de calidad premium de AdventureWorks. Diseñado y fabricado con los más altos estándares para satisfacer las necesidades de los aventureros más exigentes.';
    }
  }
}