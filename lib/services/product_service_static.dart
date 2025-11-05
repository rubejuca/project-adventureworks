import 'dart:async';
import '../models/product.dart';
import 'product_service_interface.dart';

class ProductServiceStatic implements ProductServiceInterface {
  /// Get all products from static data
  @override
  Stream<List<Product>> getProductsStream() {
    // For static data, we'll return a single emission
    return Stream.value(_getInitialProducts());
  }

  /// Get all products as a future (one-time fetch)
  @override
  Future<List<Product>> getProducts() async {
    try {
      return _getInitialProducts();
    } catch (e) {
      // Return an empty list if there's an error
      print('Error getting static products: $e');
      return <Product>[];
    }
  }

  /// Add a new product (not supported in static mode)
  @override
  Future<void> addProduct(Product product) async {
    // Static service doesn't support adding products
    throw UnimplementedError('Static service does not support adding products');
  }

  /// Update an existing product (not supported in static mode)
  @override
  Future<void> updateProduct(Product product) async {
    // Static service doesn't support updating products
    throw UnimplementedError('Static service does not support updating products');
  }

  /// Delete a product (not supported in static mode)
  @override
  Future<void> deleteProduct(String productId) async {
    // Static service doesn't support deleting products
    throw UnimplementedError('Static service does not support deleting products');
  }

  /// Get a single product by ID
  @override
  Future<Product?> getProductById(String id) async {
    try {
      final products = _getInitialProducts();
      return products.firstWhere(
        (product) => product.id == id,
        orElse: () => Product(
          id: '',
          name: 'Producto no encontrado',
          productNumber: '',
          listPrice: 0.0,
        ),
      );
    } catch (e) {
      // Return null if there's an error
      print('Error getting product by ID: $e');
      return null;
    }
  }

  /// Seed initial products (not needed for static service)
  @override
  Future<void> seedInitialProducts() async {
    // Not needed for static service
  }

  /// Get initial products list
  List<Product> _getInitialProducts() {
    return [
      // Bike Frames
      Product.fromStaticData(
        id: 680,
        name: 'HL Road Frame - Black, 58',
        productNumber: 'FR-R92B-58',
        listPrice: 1431.50,
        color: 'Black',
      ),
      Product.fromStaticData(
        id: 706,
        name: 'HL Road Frame - Red, 58',
        productNumber: 'FR-R92R-58',
        listPrice: 1431.50,
        color: 'Red',
      ),
      Product.fromStaticData(
        id: 722,
        name: 'LL Road Frame - Blue, 52',
        productNumber: 'FR-R38B-52',
        listPrice: 337.22,
        color: 'Blue',
      ),
      Product.fromStaticData(
        id: 723,
        name: 'ML Mountain Frame - Silver, 46',
        productNumber: 'FR-M94S-46',
        listPrice: 364.09,
        color: 'Silver',
      ),

      // Helmets & Safety
      Product.fromStaticData(
        id: 707,
        name: 'Sport-100 Helmet, Red',
        productNumber: 'HL-U509-R',
        listPrice: 34.99,
        color: 'Red',
      ),
      Product.fromStaticData(
        id: 708,
        name: 'Sport-100 Helmet, Black',
        productNumber: 'HL-U509-B',
        listPrice: 34.99,
        color: 'Black',
      ),
      Product.fromStaticData(
        id: 724,
        name: 'Sport-100 Helmet, Blue',
        productNumber: 'HL-U509-BL',
        listPrice: 34.99,
        color: 'Blue',
      ),

      // Clothing & Accessories
      Product.fromStaticData(
        id: 709,
        name: 'Mountain Bike Socks, M',
        productNumber: 'SO-B909-M',
        listPrice: 9.50,
        color: 'White',
      ),
      Product.fromStaticData(
        id: 725,
        name: 'Racing Socks, L',
        productNumber: 'SO-R809-L',
        listPrice: 8.99,
        color: 'Yellow',
      ),
      Product.fromStaticData(
        id: 726,
        name: 'Long-Sleeve Logo Jersey, M',
        productNumber: 'LJ-0192-M',
        listPrice: 49.99,
        color: 'Multi',
      ),
      Product.fromStaticData(
        id: 727,
        name: 'Cycling Gloves, L',
        productNumber: 'GL-H102-L',
        listPrice: 24.49,
        color: 'Black',
      ),

      // Tools & Maintenance
      Product.fromStaticData(
        id: 710,
        name: 'Water Bottle - 30 oz.',
        productNumber: 'WB-30',
        listPrice: 4.99,
        color: null,
      ),
      Product.fromStaticData(
        id: 728,
        name: 'Bike Wash - Dissolver',
        productNumber: 'CL-909',
        listPrice: 7.95,
        color: null,
      ),
      Product.fromStaticData(
        id: 729,
        name: 'Fender Set - Mountain',
        productNumber: 'FE-6654',
        listPrice: 21.98,
        color: 'Black',
      ),
      Product.fromStaticData(
        id: 730,
        name: 'ML Bottom Bracket',
        productNumber: 'BB-7421',
        listPrice: 101.24,
        color: null,
      ),

      // Bike Components
      Product.fromStaticData(
        id: 731,
        name: 'HL Mountain Pedal',
        productNumber: 'PD-M282',
        listPrice: 80.99,
        color: 'Silver',
      ),
      Product.fromStaticData(
        id: 732,
        name: 'Road-150 Red, 52',
        productNumber: 'BK-R93R-52',
        listPrice: 3578.27,
        color: 'Red',
      ),
      Product.fromStaticData(
        id: 733,
        name: 'Mountain-400-W Silver, 38',
        productNumber: 'BK-M68S-38',
        listPrice: 769.49,
        color: 'Silver',
      ),
      Product.fromStaticData(
        id: 734,
        name: 'Road-550-W Yellow, 48',
        productNumber: 'BK-R50Y-48',
        listPrice: 1120.49,
        color: 'Yellow',
      ),
    ];
  }
}