import 'package:flutter/material.dart';
import '../models/product.dart';

abstract class ProductServiceInterface {
  Stream<List<Product>> getProductsStream();
  Future<List<Product>> getProducts();
  Future<void> addProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<void> deleteProduct(String productId);
  Future<Product?> getProductById(String id);
  Future<void> seedInitialProducts();
}