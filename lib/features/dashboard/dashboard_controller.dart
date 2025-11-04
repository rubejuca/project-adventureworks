import 'dart:async';
import 'package:adventure_works/services/product_service_firebase.dart';

class DashboardData {
  final int totalProducts;
  final int totalCategories;
  final int totalStatuses;
  final List<CategoryPriceData> categoryPriceData;
  final List<StatusCountData> statusCountData;
  final List<CategoryCountData> categoryCountData;

  DashboardData({
    required this.totalProducts,
    required this.totalCategories,
    required this.totalStatuses,
    required this.categoryPriceData,
    required this.statusCountData,
    required this.categoryCountData,
  });
}

class CategoryPriceData {
  final String? category;
  final double averagePrice;

  CategoryPriceData({
    required this.category,
    required this.averagePrice,
  });
}

class StatusCountData {
  final String? status;
  final int count;

  StatusCountData({
    required this.status,
    required this.count,
  });
}

class CategoryCountData {
  final String? category;
  final int count;

  CategoryCountData({
    required this.category,
    required this.count,
  });
}

class DashboardController {
  final ProductServiceFirebase _productService = ProductServiceFirebase();
  final StreamController<DashboardData?> _controller =
      StreamController<DashboardData?>.broadcast();

  Stream<DashboardData?> get dashboardDataStream => _controller.stream;

  void dispose() {
    _controller.close();
  }

  Future<void> loadDashboardData() async {
    try {
      final products = await _productService.getProducts();
      
      // Filter out null categories
      final categories = products
          .where((product) => product.category != null)
          .map((product) => product.category!)
          .toSet();

      final categoryPriceData = categories.map((category) {
        final filtered = products
            .where((product) => product.category == category)
            .toList();
        
        final total = filtered.fold<double>(0, (sum, product) => sum + product.listPrice);
        final avg = filtered.isEmpty ? 0.0 : total / filtered.length;
        
        return CategoryPriceData(category: category, averagePrice: avg);
      }).toList();

      // Filter out null statuses
      final statuses = products
          .where((product) => product.status != null)
          .map((product) => product.status!)
          .toSet();
          
      // Count products by status
      final statusCountMap = <String, int>{};
      for (var product in products) {
        if (product.status != null) {
          statusCountMap[product.status!] = 
              (statusCountMap[product.status!] ?? 0) + 1;
        }
      }
      
      final statusCountData = statusCountMap.entries.map((entry) {
        return StatusCountData(status: entry.key, count: entry.value);
      }).toList();
      
      // Count products by category
      final categoryCountMap = <String, int>{};
      for (var product in products) {
        if (product.category != null) {
          categoryCountMap[product.category!] = 
              (categoryCountMap[product.category!] ?? 0) + 1;
        }
      }
      
      final categoryCountData = categoryCountMap.entries.map((entry) {
        return CategoryCountData(category: entry.key, count: entry.value);
      }).toList();

      _controller.add(DashboardData(
        totalProducts: products.length,
        totalCategories: categories.length,
        totalStatuses: statuses.length,
        categoryPriceData: categoryPriceData,
        statusCountData: statusCountData,
        categoryCountData: categoryCountData,
      ));
    } catch (e) {
      // Emit null on error
      _controller.add(null);
    }
  }
}
