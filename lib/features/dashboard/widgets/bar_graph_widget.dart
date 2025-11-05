import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../dashboard_controller.dart';
import 'dashboard_theme.dart';

class BarGraphWidget extends StatefulWidget {
  final List<CategoryPriceData> categoryPriceData;

  const BarGraphWidget({super.key, required this.categoryPriceData});

  @override
  State<BarGraphWidget> createState() => _BarGraphWidgetState();
}

class _BarGraphWidgetState extends State<BarGraphWidget> {
  int? _selectedBarIndex;

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
                "Comparativo de Precios Promedio",
                style: DashboardTheme.headingSmall,
              ),
              if (_selectedBarIndex != null && 
                  _selectedBarIndex! < widget.categoryPriceData.length)
                Text(
                  widget.categoryPriceData[_selectedBarIndex!].category ?? '',
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
            child: BarChart(
              BarChartData(
                barGroups: widget.categoryPriceData
                    .asMap()
                    .entries
                    .map((e) => BarChartGroupData(
                          x: e.key,
                          barRods: [
                            BarChartRodData(
                              toY: e.value.averagePrice,
                              color: _selectedBarIndex == e.key 
                                  ? DashboardTheme.accentOrange 
                                  : DashboardTheme.primaryBlue,
                              width: 18,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ],
                        ))
                    .toList(),
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: DashboardTheme.textTertiary.withValues(alpha: 0.1),
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  show: true,
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
                barTouchData: BarTouchData(
                  enabled: true,
                  touchCallback: (FlTouchEvent event, barTouchResponse) {
                    if (event is FlTapUpEvent && barTouchResponse != null) {
                      if (barTouchResponse.spot?.touchedBarGroup != null) {
                        setState(() {
                          _selectedBarIndex = barTouchResponse.spot!.touchedBarGroup!.x;
                        });
                      }
                    }
                  },
                  touchTooltipData: BarTouchTooltipData(
                    tooltipRoundedRadius: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final category = widget.categoryPriceData[group.x].category ?? '';
                      return BarTooltipItem(
                        '$category\n',
                        const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: '\$${rod.toY.toStringAsFixed(2)}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

              ),
            ),
          ),
          if (_selectedBarIndex != null && 
              _selectedBarIndex! < widget.categoryPriceData.length)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDetailItem(
                    'Categoría', 
                    widget.categoryPriceData[_selectedBarIndex!].category ?? ''
                  ),
                  _buildDetailItem(
                    'Precio Promedio', 
                    '\$${widget.categoryPriceData[_selectedBarIndex!].averagePrice.toStringAsFixed(2)}'
                  ),
                ],
              ),
            ),
        ],
      ),
    );
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