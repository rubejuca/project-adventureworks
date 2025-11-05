import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../dashboard_controller.dart';
import 'dashboard_theme.dart';

class HorizontalBarChart extends StatefulWidget {
  final List<CategoryCountData> categoryCountData;

  const HorizontalBarChart({super.key, required this.categoryCountData});

  @override
  State<HorizontalBarChart> createState() => _HorizontalBarChartState();
}

class _HorizontalBarChartState extends State<HorizontalBarChart> {
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
          Text(
            "Productos por Categoría",
            style: DashboardTheme.headingSmall,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 300,
            child: BarChart(
              BarChartData(
                barGroups: widget.categoryCountData
                    .asMap()
                    .entries
                    .map((e) => BarChartGroupData(
                          x: e.key,
                          barRods: [
                            BarChartRodData(
                              toY: e.value.count.toDouble(),
                              color: _selectedBarIndex == e.key 
                                  ? DashboardTheme.accentOrange 
                                  : DashboardTheme.primaryGreen,
                              width: 22,
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ],
                        ))
                    .toList(),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: DashboardTheme.textTertiary.withValues(alpha: 0.1),
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  show: true,
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < widget.categoryCountData.length) {
                          final category = widget.categoryCountData[index].category ?? '';
                          // Truncate long category names
                          final truncated = category.length > 15
                              ? '${category.substring(0, 15)}...'
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
                      reservedSize: 100,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: DashboardTheme.bodySmall,
                        );
                      },
                      reservedSize: 30,
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
                      final category = widget.categoryCountData[group.x].category ?? '';
                      return BarTooltipItem(
                        '$category\n',
                        const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        children: [
                          TextSpan(
                            text: '${rod.toY.toInt()} productos',
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
        ],
      ),
    );
  }
}