import 'dart:async';
import 'package:adventure_works/services/product_service_interface.dart';
import 'package:adventure_works/services/product_service_firebase.dart';
import 'package:adventure_works/services/product_service_static.dart';

class DashboardData {
  final int totalProducts;
  final int totalCategories;
  final int totalStatuses;
  final double totalInventoryValue;
  final int lowStockProducts;
  final String topCategory;
  final String mostExpensiveProduct;
  final double averagePrice;
  final List<CategoryPriceData> categoryPriceData;
  final List<StatusCountData> statusCountData;
  final List<CategoryCountData> categoryCountData;
  final List<Map<String, dynamic>> topProducts;
  final List<Map<String, dynamic>> priceTrendData;
  final List<Map<String, dynamic>> inventoryData;

  DashboardData({
    required this.totalProducts,
    required this.totalCategories,
    required this.totalStatuses,
    required this.totalInventoryValue,
    required this.lowStockProducts,
    required this.topCategory,
    required this.mostExpensiveProduct,
    required this.averagePrice,
    required this.categoryPriceData,
    required this.statusCountData,
    required this.categoryCountData,
    required this.topProducts,
    required this.priceTrendData,
    required this.inventoryData,
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
  final ProductServiceInterface _productService;
  
  DashboardController({required bool useFirebase}) 
    : _productService = useFirebase 
        ? ProductServiceFirebase() 
        : ProductServiceStatic();

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

      // Generate top products data (simulated)
      final topProducts = _generateTopProductsData(products);

      // Generate price trend data (simulated)
      final priceTrendData = _generatePriceTrendData();

      // Generate inventory data
      final inventoryData = categoryCountData.map((data) {
        return {
          'category': data.category,
          'count': data.count,
        };
      }).toList();

      // Calculate new KPIs
      final totalInventoryValue = products.fold<double>(
        0, 
        (sum, product) => sum + product.listPrice
      );
      
      // For low stock products, we'll assume products with price < 10 are low stock
      final lowStockProducts = products.where((product) => product.listPrice < 10).length;
      
      // Find category with most products
      String topCategory = '';
      int maxCategoryCount = 0;
      categoryCountMap.forEach((category, count) {
        if (count > maxCategoryCount) {
          maxCategoryCount = count;
          topCategory = category;
        }
      });
      
      // Find most expensive product
      String mostExpensiveProduct = '';
      double maxPrice = 0;
      for (var product in products) {
        if (product.listPrice > maxPrice) {
          maxPrice = product.listPrice;
          mostExpensiveProduct = product.name;
        }
      }
      
      // Calculate average price
      final averagePrice = products.isEmpty 
          ? 0.0 
          : products.fold<double>(0, (sum, product) => sum + product.listPrice) / products.length;

      _controller.add(DashboardData(
        totalProducts: products.length,
        totalCategories: categories.length,
        totalStatuses: statuses.length,
        totalInventoryValue: totalInventoryValue,
        lowStockProducts: lowStockProducts,
        topCategory: topCategory,
        mostExpensiveProduct: mostExpensiveProduct,
        averagePrice: averagePrice.toDouble(),
        categoryPriceData: categoryPriceData,
        statusCountData: statusCountData,
        categoryCountData: categoryCountData,
        topProducts: topProducts,
        priceTrendData: priceTrendData,
        inventoryData: inventoryData,
      ));
    } catch (e) {
      // Emit null on error
      _controller.add(null);
    }
  }

  List<Map<String, dynamic>> _generateTopProductsData(List<dynamic> products) {
    // This is simulated data - in a real application, you would get this from your database
    // based on actual sales data
    return [
      {'name': 'HL Road Frame', 'sales': 120},
      {'name': 'Sport-100 Helmet', 'sales': 95},
      {'name': 'Mountain Bike Socks', 'sales': 87},
      {'name': 'Water Bottle', 'sales': 78},
      {'name': 'Road-150 Red', 'sales': 65},
      {'name': 'ML Mountain Frame', 'sales': 54},
      {'name': 'Cycling Gloves', 'sales': 48},
      {'name': 'Bike Wash', 'sales': 42},
      {'name': 'Fender Set', 'sales': 35},
      {'name': 'Bottom Bracket', 'sales': 28},
    ];
  }

  List<Map<String, dynamic>> _generatePriceTrendData() {
    // This is simulated data - in a real application, you would get this from your database
    // based on actual price changes over time
    return [
      {'month': 'Enero', 'averagePrice': 450.0},
      {'month': 'Febrero', 'averagePrice': 475.5},
      {'month': 'Marzo', 'averagePrice': 462.3},
      {'month': 'Abril', 'averagePrice': 480.7},
      {'month': 'Mayo', 'averagePrice': 495.2},
      {'month': 'Junio', 'averagePrice': 510.8},
      {'month': 'Julio', 'averagePrice': 505.4},
      {'month': 'Agosto', 'averagePrice': 520.1},
      {'month': 'Septiembre', 'averagePrice': 535.6},
      {'month': 'Octubre', 'averagePrice': 542.9},
      {'month': 'Noviembre', 'averagePrice': 550.3},
      {'month': 'Diciembre', 'averagePrice': 565.7},
    ];
  }
}