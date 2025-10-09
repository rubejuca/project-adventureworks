import 'dart:async';
import '../models/product.dart';

class ProductService {
  Future<List<Product>> fetchProducts() async {
    await Future.delayed(const Duration(milliseconds: 800));
    return const [
      // Bike Frames
      Product(
        id: 680,
        name: 'HL Road Frame - Black, 58',
        productNumber: 'FR-R92B-58',
        listPrice: 1431.50,
        color: 'Black',
      ),
      Product(
        id: 706,
        name: 'HL Road Frame - Red, 58',
        productNumber: 'FR-R92R-58',
        listPrice: 1431.50,
        color: 'Red',
      ),
      Product(
        id: 722,
        name: 'LL Road Frame - Blue, 52',
        productNumber: 'FR-R38B-52',
        listPrice: 337.22,
        color: 'Blue',
      ),
      Product(
        id: 723,
        name: 'ML Mountain Frame - Silver, 46',
        productNumber: 'FR-M94S-46',
        listPrice: 364.09,
        color: 'Silver',
      ),

      // Helmets & Safety
      Product(
        id: 707,
        name: 'Sport-100 Helmet, Red',
        productNumber: 'HL-U509-R',
        listPrice: 34.99,
        color: 'Red',
      ),
      Product(
        id: 708,
        name: 'Sport-100 Helmet, Black',
        productNumber: 'HL-U509-B',
        listPrice: 34.99,
        color: 'Black',
      ),
      Product(
        id: 724,
        name: 'Sport-100 Helmet, Blue',
        productNumber: 'HL-U509-BL',
        listPrice: 34.99,
        color: 'Blue',
      ),

      // Clothing & Accessories
      Product(
        id: 709,
        name: 'Mountain Bike Socks, M',
        productNumber: 'SO-B909-M',
        listPrice: 9.50,
        color: 'White',
      ),
      Product(
        id: 725,
        name: 'Racing Socks, L',
        productNumber: 'SO-R809-L',
        listPrice: 8.99,
        color: 'Yellow',
      ),
      Product(
        id: 726,
        name: 'Long-Sleeve Logo Jersey, M',
        productNumber: 'LJ-0192-M',
        listPrice: 49.99,
        color: 'Multi',
      ),
      Product(
        id: 727,
        name: 'Cycling Gloves, L',
        productNumber: 'GL-H102-L',
        listPrice: 24.49,
        color: 'Black',
      ),

      // Tools & Maintenance
      Product(
        id: 710,
        name: 'Water Bottle - 30 oz.',
        productNumber: 'WB-30',
        listPrice: 4.99,
        color: null,
      ),
      Product(
        id: 728,
        name: 'Bike Wash - Dissolver',
        productNumber: 'CL-9009',
        listPrice: 7.95,
        color: null,
      ),
      Product(
        id: 729,
        name: 'Fender Set - Mountain',
        productNumber: 'FE-6654',
        listPrice: 21.98,
        color: 'Black',
      ),
      Product(
        id: 730,
        name: 'ML Bottom Bracket',
        productNumber: 'BB-7421',
        listPrice: 101.24,
        color: null,
      ),

      // Bike Components
      Product(
        id: 731,
        name: 'HL Mountain Pedal',
        productNumber: 'PD-M282',
        listPrice: 80.99,
        color: 'Silver',
      ),
      Product(
        id: 732,
        name: 'Road-150 Red, 52',
        productNumber: 'BK-R93R-52',
        listPrice: 3578.27,
        color: 'Red',
      ),
      Product(
        id: 733,
        name: 'Mountain-400-W Silver, 38',
        productNumber: 'BK-M68S-38',
        listPrice: 769.49,
        color: 'Silver',
      ),
      Product(
        id: 734,
        name: 'Road-550-W Yellow, 48',
        productNumber: 'BK-R50Y-48',
        listPrice: 1120.49,
        color: 'Yellow',
      ),
    ];
  }
}
