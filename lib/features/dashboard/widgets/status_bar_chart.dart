import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../dashboard_controller.dart';
import 'dashboard_theme.dart';

class StatusBarChart extends StatefulWidget {
  final List<StatusCountData> statusCountData;

  const StatusBarChart({super.key, required this.statusCountData});

  @override
  State<StatusBarChart> createState() => _StatusBarChartState();
}

class _StatusBarChartState extends State<StatusBarChart> {
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
            "Distribución por Estado",
            style: DashboardTheme.headingSmall,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 250,
            child: BarChart(
              BarChartData(
                barGroups: widget.statusCountData
                    .asMap()
                    .entries
                    .map((e) => BarChartGroupData(
                          x: e.key,
                          barRods: [
                            BarChartRodData(
                              toY: e.value.count.toDouble(),
                              color: _selectedBarIndex == e.key 
                                  ? DashboardTheme.accentOrange 
                                  : DashboardTheme.primaryBlue,
                              width: 25,
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
                        if (index >= 0 && index < widget.statusCountData.length) {
                          final status = widget.statusCountData[index].status ?? '';
                          // Truncate long status names
                          final truncated = status.length > 12
                              ? '${status.substring(0, 12)}...'
                              : status;
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
                      reservedSize: 40,
                    ),
                  ),
                  leftTitles: AxisTitles(
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
                      final status = widget.statusCountData[group.x].status ?? '';
                      return BarTooltipItem(
                        '$status\n',
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