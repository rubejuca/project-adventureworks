import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'card_with_header.dart';
import 'dashboard_theme.dart';

class InventoryDistributionChart extends StatelessWidget {
  final List<Map<String, dynamic>> inventoryData;

  const InventoryDistributionChart({super.key, required this.inventoryData});

  @override
  Widget build(BuildContext context) {
    return CardWithHeader(
      title: 'Distribución de Inventario por Categoría',
      icon: Icons.inventory,
      child: SizedBox(
        height: 300,
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: PieChart(
                PieChartData(
                  sectionsSpace: 0,
                  centerSpaceRadius: 50,
                  sections: _getSections(),
                  pieTouchData: PieTouchData(
                    touchCallback: (FlTouchEvent event, pieTouchResponse) {
                      // Handle touch events if needed
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: _buildLegend(),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _getSections() {
    final total = inventoryData.fold<int>(
      0, 
      (sum, item) => sum + (item['count'] as int)
    );
    
    return List.generate(
      inventoryData.length,
      (index) {
        final data = inventoryData[index];
        final count = data['count'] as int;
        final percentage = total > 0 ? (count / total) * 100 : 0;
        final color = _getColorForIndex(index);
        
        return PieChartSectionData(
          color: color,
          value: count.toDouble(),
          title: '${percentage.toStringAsFixed(1)}%',
          radius: 50,
          titleStyle: DashboardTheme.bodySmall.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        );
      },
    );
  }

  Widget _buildLegend() {
    return ListView.builder(
      itemCount: inventoryData.length,
      itemBuilder: (context, index) {
        final data = inventoryData[index];
        final category = data['category'] as String;
        final count = data['count'] as int;
        final color = _getColorForIndex(index);
        
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  category,
                  style: DashboardTheme.bodyMedium,
                ),
              ),
              Text(
                count.toString(),
                style: DashboardTheme.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _getColorForIndex(int index) {
    final colors = [
      DashboardTheme.primaryBlue,
      DashboardTheme.primaryGreen,
      DashboardTheme.accentOrange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
      Colors.cyan,
      Colors.lime,
      Colors.amber,
    ];
    
    return colors[index % colors.length];
  }
}