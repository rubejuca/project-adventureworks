import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../dashboard_controller.dart';
import 'dashboard_theme.dart';

class PieChartCard extends StatefulWidget {
  final List<CategoryPriceData> categoryPriceData;

  const PieChartCard({super.key, required this.categoryPriceData});

  @override
  State<PieChartCard> createState() => _PieChartCardState();
}

class _PieChartCardState extends State<PieChartCard> {
  int _touchedIndex = -1;

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
            "Distribución de Precios por Categoría",
            style: DashboardTheme.headingSmall,
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 300,
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              _touchedIndex = -1;
                              return;
                            }
                            _touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      sectionsSpace: 0,
                      centerSpaceRadius: 50,
                      sections: _getSections(),
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
        ],
      ),
    );
  }

  List<PieChartSectionData> _getSections() {
    final total = widget.categoryPriceData.fold<double>(
      0, 
      (sum, item) => sum + item.averagePrice
    );
    
    return List.generate(
      widget.categoryPriceData.length,
      (i) {
        final data = widget.categoryPriceData[i];
        final percentage = total > 0 ? (data.averagePrice / total) * 100 : 0;
        final isTouched = i == _touchedIndex;
        final fontSize = isTouched ? 14.0 : 12.0;
        final radius = isTouched ? 55.0 : 50.0;
        
        // Generate colors based on index
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
        
        final color = colors[i % colors.length];
        
        return PieChartSectionData(
          color: color,
          value: data.averagePrice,
          title: '${percentage.toStringAsFixed(1)}%',
          radius: radius,
          titleStyle: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        );
      },
    );
  }

  Widget _buildLegend() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          widget.categoryPriceData.length,
          (i) {
            final data = widget.categoryPriceData[i];
            final isTouched = i == _touchedIndex;
            
            // Generate colors based on index
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
            
            final color = colors[i % colors.length];
            
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
                      data.category ?? '',
                      style: DashboardTheme.bodyMedium.copyWith(
                        fontWeight: isTouched ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                  Text(
                    '\$${data.averagePrice.toStringAsFixed(2)}',
                    style: DashboardTheme.bodyMedium.copyWith(
                      fontWeight: isTouched ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}