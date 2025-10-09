import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class ProductServiceFirebase {
  final CollectionReference _productsCollection;

  ProductServiceFirebase()
    : _productsCollection = FirebaseFirestore.instance.collection('products');

  /// Get all products as a stream (real-time updates)
  Stream<List<Product>> getProductsStream() {
    try {
      return _productsCollection.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>?;
          if (data == null)
            return Product.fromJson({}); // Return empty product if data is null
          return Product.fromJson(data);
        }).toList();
      });
    } catch (e) {
      // Return an empty stream if there's an error
      return Stream.value(<Product>[]);
    }
  }

  /// Get all products as a future (one-time fetch)
  Future<List<Product>> getProducts() async {
    try {
      final snapshot = await _productsCollection.get();
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data == null)
          return Product.fromJson({}); // Return empty product if data is null
        return Product.fromJson(data);
      }).toList();
    } catch (e) {
      // Return an empty list if there's an error
      return <Product>[];
    }
  }

  /// Add a new product to Firestore
  Future<void> addProduct(Product product) async {
    try {
      await _productsCollection.doc(product.id).set(product.toJson());
    } catch (e) {
      // Rethrow the error to be handled by the calling code
      rethrow;
    }
  }

  /// Update an existing product in Firestore
  Future<void> updateProduct(Product product) async {
    try {
      await _productsCollection.doc(product.id).update(product.toJson());
    } catch (e) {
      // Rethrow the error to be handled by the calling code
      rethrow;
    }
  }

  /// Delete a product from Firestore
  Future<void> deleteProduct(String productId) async {
    try {
      await _productsCollection.doc(productId).delete();
    } catch (e) {
      // Rethrow the error to be handled by the calling code
      rethrow;
    }
  }

  /// Get a single product by ID
  Future<Product?> getProductById(String id) async {
    try {
      final doc = await _productsCollection.doc(id).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data == null) return null;
        return Product.fromJson(data);
      }
      return null;
    } catch (e) {
      // Return null if there's an error
      return null;
    }
  }

  /// Seed Firestore with initial products if collection is empty
  Future<void> seedInitialProducts() async {
    try {
      final snapshot = await _productsCollection.limit(1).get();

      // If collection is empty, seed with initial products
      if (snapshot.docs.isEmpty) {
        final initialProducts = _getInitialProducts();

        // Add all products to Firestore
        for (final product in initialProducts) {
          await addProduct(product);
        }
      }
    } catch (e) {
      // Silently ignore errors during seeding
      // This is not critical for the app to function
    }
  }

  /// Get initial products list (converted from static data)
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
        productNumber: 'CL-9009',
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
