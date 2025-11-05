import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../dashboard_controller.dart';
import 'dashboard_theme.dart';

class LineChartCard extends StatefulWidget {
  final List<CategoryPriceData> categoryPriceData;

  const LineChartCard({super.key, required this.categoryPriceData});

  @override
  State<LineChartCard> createState() => _LineChartCardState();
}

class _LineChartCardState extends State<LineChartCard> {
  int? _selectedSpotIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: DashboardTheme.cardBackgroundColor,
        borderRadius: DashboardTheme.cardBorderRadius,
        boxShadow: DashboardTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Tendencia de Precios por Categoría",
                style: DashboardTheme.headingSmall,
              ),
              if (_selectedSpotIndex != null && 
                  _selectedSpotIndex! < widget.categoryPriceData.length)
                Text(
                  widget.categoryPriceData[_selectedSpotIndex!].category ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    color: DashboardTheme.primaryBlue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((barSpot) {
                        final flSpot = barSpot;
                        if (flSpot.x.toInt() >= 0 && flSpot.x.toInt() < widget.categoryPriceData.length) {
                          final data = widget.categoryPriceData[flSpot.x.toInt()];
                          final category = data.category ?? '';
                          final price = data.averagePrice.toStringAsFixed(2);
                          
                          return LineTooltipItem(
                            '$category\n',
                            const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            children: [
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
                  touchCallback: (FlTouchEvent event, lineTouchResponse) {
                    if (event is FlTapUpEvent && lineTouchResponse != null) {
                      // For older versions of fl_chart, we'll use a simpler approach
                      if (lineTouchResponse.lineBarSpots != null && lineTouchResponse.lineBarSpots!.isNotEmpty) {
                        setState(() {
                          _selectedSpotIndex = lineTouchResponse.lineBarSpots!.first.spotIndex;
                        });
                      }
                    }
                  },
                ),
                gridData: FlGridData(show: true),
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
                        // Only show every 2nd label to avoid crowding
                        if (index % 2 == 0 && index >= 0 && index < widget.categoryPriceData.length) {
                          final category = widget.categoryPriceData[index].category ?? '';
                          // Truncate long category names
                          final truncated = category.length > 10
                              ? '${category.substring(0, 10)}...'
                              : category;
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(
                              truncated,
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
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: widget.categoryPriceData.length > 1 
                    ? (widget.categoryPriceData.length - 1).toDouble() 
                    : 1,
                minY: _calculateMinY(),
                maxY: _calculateMaxY(),
                lineBarsData: [
                  LineChartBarData(
                    spots: widget.categoryPriceData
                        .asMap()
                        .entries
                        .map((e) => FlSpot(
                              e.key.toDouble(),
                              e.value.averagePrice,
                            ))
                        .toList(),
                    isCurved: true,
                    color: DashboardTheme.primaryBlue,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: _selectedSpotIndex == index 
                              ? DashboardTheme.accentOrange 
                              : DashboardTheme.primaryBlue,
                          strokeWidth: 2,
                          strokeColor: DashboardTheme.cardBackgroundColor,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: DashboardTheme.primaryBlue.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_selectedSpotIndex != null && 
              _selectedSpotIndex! < widget.categoryPriceData.length)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDetailItem(
                    'Categoría', 
                    widget.categoryPriceData[_selectedSpotIndex!].category ?? ''
                  ),
                  _buildDetailItem(
                    'Precio Promedio', 
                    '\$${widget.categoryPriceData[_selectedSpotIndex!].averagePrice.toStringAsFixed(2)}'
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  double _calculateMinY() {
    if (widget.categoryPriceData.isEmpty) return 0;
    
    final minPrice = widget.categoryPriceData
        .map((data) => data.averagePrice)
        .reduce((a, b) => a < b ? a : b);
    
    // Add some padding below
    return minPrice * 0.9;
  }

  double _calculateMaxY() {
    if (widget.categoryPriceData.isEmpty) return 100;
    
    final maxPrice = widget.categoryPriceData
        .map((data) => data.averagePrice)
        .reduce((a, b) => a > b ? a : b);
    
    // Add some padding above
    return maxPrice * 1.1;
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: DashboardTheme.labelMedium,
        ),
        Text(
          value,
          style: DashboardTheme.bodyLarge.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}