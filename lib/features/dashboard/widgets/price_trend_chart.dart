import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'card_with_header.dart';
import 'dashboard_theme.dart';

class PriceTrendChart extends StatelessWidget {
  final List<Map<String, dynamic>> priceTrendData;

  const PriceTrendChart({super.key, required this.priceTrendData});

  @override
  Widget build(BuildContext context) {
    return CardWithHeader(
      title: 'Tendencia de Precios Promedio',
      icon: Icons.show_chart,
      child: SizedBox(
        height: 300,
        child: LineChart(
          LineChartData(
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((barSpot) {
                    final flSpot = barSpot;
                    if (flSpot.x.toInt() >= 0 && flSpot.x.toInt() < priceTrendData.length) {
                      final data = priceTrendData[flSpot.x.toInt()];
                      final month = data['month'] as String;
                      final price = (data['averagePrice'] as double).toStringAsFixed(2);
                      
                      return LineTooltipItem(
                        '$month\n',
                        const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: '\$${price}',
                            style: const TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      );
                    }
                    return LineTooltipItem('', const TextStyle());
                  }).toList();
                },
              ),
            ),
            gridData: const FlGridData(show: true),
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
                    if (index >= 0 && index < priceTrendData.length) {
                      final month = priceTrendData[index]['month'] as String;
                      // Show abbreviated month names
                      final abbreviated = month.length > 3 
                          ? month.substring(0, 3) 
                          : month;
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
                  getTitlesWidget: (value, meta) {
                    return Text(
                      '\$${value.toInt()}',
                      style: DashboardTheme.bodySmall,
                    );
                  },
                  reservedSize: 40,
                ),
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(
                color: DashboardTheme.textTertiary.withOpacity(0.2),
              ),
            ),
            minX: 0,
            maxX: priceTrendData.length > 1 ? (priceTrendData.length - 1).toDouble() : 1,
            minY: _getMinY(),
            maxY: _getMaxY(),
            lineBarsData: [
              LineChartBarData(
                spots: _getSpots(),
                isCurved: true,
                color: DashboardTheme.primaryBlue,
                barWidth: 4,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: true),
                belowBarData: BarAreaData(
                  show: true,
                  color: DashboardTheme.primaryBlue.withOpacity(0.3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<FlSpot> _getSpots() {
    return List.generate(
      priceTrendData.length,
      (index) {
        final data = priceTrendData[index];
        final price = data['averagePrice'] as double;
        return FlSpot(index.toDouble(), price);
      },
    );
  }

  double _getMinY() {
    if (priceTrendData.isEmpty) return 0;
    
    final minPrice = priceTrendData
        .map((data) => data['averagePrice'] as double)
        .reduce((a, b) => a < b ? a : b);
    
    // Subtract 10% padding
    return minPrice * 0.9;
  }

  double _getMaxY() {
    if (priceTrendData.isEmpty) return 100;
    
    final maxPrice = priceTrendData
        .map((data) => data['averagePrice'] as double)
        .reduce((a, b) => a > b ? a : b);
    
    // Add 10% padding
    return maxPrice * 1.1;
  }
}