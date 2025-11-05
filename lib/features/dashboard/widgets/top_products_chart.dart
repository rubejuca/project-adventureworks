import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'card_with_header.dart';
import 'dashboard_theme.dart';

class TopProductsChart extends StatelessWidget {
  final List<Map<String, dynamic>> topProducts;

  const TopProductsChart({super.key, required this.topProducts});

  @override
  Widget build(BuildContext context) {
    return CardWithHeader(
      title: 'Productos Más Vendidos',
      icon: Icons.trending_up,
      child: SizedBox(
        height: 300,
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: _getMaxY(),
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    '${topProducts[group.x]['name']}\n',
                    const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: '${rod.toY.toInt()} ventas',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= 0 && index < topProducts.length) {
                      // Show abbreviated product names
                      final name = topProducts[index]['name'] as String;
                      final abbreviated = name.length > 10 
                          ? '${name.substring(0, 10)}...' 
                          : name;
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        child: Text(
                          abbreviated,
                          style: DashboardTheme.bodySmall,
                        ),
                      );
                    }
                    return const Text('');
                  },
                  reservedSize: 30,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(),
                      style: DashboardTheme.bodySmall,
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(
                color: DashboardTheme.textTertiary.withOpacity(0.2),
              ),
            ),
            gridData: const FlGridData(show: true),
            barGroups: _getBarGroups(),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _getBarGroups() {
    return List.generate(
      topProducts.length,
      (index) {
        final product = topProducts[index];
        final sales = product['sales'] as int;
        final color = _getColorForIndex(index);
        
        return BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: sales.toDouble(),
              color: color,
              width: 20,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
              rodStackItems: [
                BarChartRodStackItem(
                  0,
                  sales.toDouble(),
                  color.withOpacity(0.8),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  double _getMaxY() {
    if (topProducts.isEmpty) return 10;
    
    final maxSales = topProducts
        .map((product) => product['sales'] as int)
        .reduce((a, b) => a > b ? a : b);
    
    // Add 20% padding to the top
    return maxSales * 1.2;
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