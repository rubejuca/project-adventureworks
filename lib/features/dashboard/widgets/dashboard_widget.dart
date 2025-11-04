import 'package:flutter/material.dart';
import '../dashboard_controller.dart';
import 'summary_widget.dart';
import 'line_chart_card.dart';
import 'bar_graph_widget.dart';
import 'pie_chart_card.dart';
import 'horizontal_bar_chart.dart';
import 'status_bar_chart.dart';

class DashboardWidget extends StatelessWidget {
  final DashboardData data;

  const DashboardWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    // Filter out null categories for charts
    final validCategoryPriceData = data.categoryPriceData
        .where((item) => item.category != null)
        .toList();
        
    // Filter out null statuses for charts
    final validStatusCountData = data.statusCountData
        .where((item) => item.status != null)
        .toList();
        
    // Filter out null categories for count charts
    final validCategoryCountData = data.categoryCountData
        .where((item) => item.category != null)
        .toList();

    return Column(
      children: [
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            SummaryWidget(
              title: 'Productos',
              value: data.totalProducts.toString(),
              icon: Icons.shopping_bag,
              color: Colors.orange,
            ),
            SummaryWidget(
              title: 'Categorías',
              value: data.totalCategories.toString(),
              icon: Icons.category,
              color: Colors.blue,
            ),
            SummaryWidget(
              title: 'Estados',
              value: data.totalStatuses.toString(),
              icon: Icons.flag,
              color: Colors.green,
            ),
          ],
        ),
        const SizedBox(height: 24),
        if (validCategoryPriceData.isNotEmpty) ...[
          LineChartCard(categoryPriceData: validCategoryPriceData),
          const SizedBox(height: 24),
          BarGraphWidget(categoryPriceData: validCategoryPriceData),
          const SizedBox(height: 24),
          PieChartCard(categoryPriceData: validCategoryPriceData),
          const SizedBox(height: 24),
          HorizontalBarChart(categoryCountData: validCategoryCountData),
          const SizedBox(height: 24),
          StatusBarChart(statusCountData: validStatusCountData),
        ] else
          const Center(
            child: Text('No hay datos suficientes para mostrar gráficos'),
          ),
      ],
    );
  }
}
