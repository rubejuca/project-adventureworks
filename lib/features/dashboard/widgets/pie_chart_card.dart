import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../dashboard_controller.dart';

class PieChartCard extends StatefulWidget {
  final List<CategoryPriceData> categoryPriceData;

  const PieChartCard({super.key, required this.categoryPriceData});

  @override
  State<PieChartCard> createState() => _PieChartCardState();
}

class _PieChartCardState extends State<PieChartCard> {
  int? _selectedSectionIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark 
                ? Colors.black.withValues(alpha: 0.3) 
                : Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Distribución de precios por categoría",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: _showingSections(),
                centerSpaceRadius: 40,
                sectionsSpace: 2,
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    if (event is FlTapUpEvent && pieTouchResponse != null) {
                      setState(() {
                        _selectedSectionIndex = pieTouchResponse.touchedSection?.touchedSectionIndex;
                      });
                    }
                  },
                ),
              ),
            ),
          ),
          if (_selectedSectionIndex != null && 
              _selectedSectionIndex! < widget.categoryPriceData.length)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDetailItem(
                    context, 
                    'Categoría', 
                    widget.categoryPriceData[_selectedSectionIndex!].category ?? ''
                  ),
                  _buildDetailItem(
                    context, 
                    'Precio Promedio', 
                    '\$${widget.categoryPriceData[_selectedSectionIndex!].averagePrice.toStringAsFixed(2)}'
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _showingSections() {
    // Create sections based on category price data
    final sections = <PieChartSectionData>[];
    // Professional color palette
    final colors = [
      const Color(0xFF4A90E2), // Blue
      const Color(0xFF50C878), // Emerald Green
      const Color(0xFFFF6B6B), // Coral Red
      const Color(0xFFFFD93D), // Golden Yellow
      const Color(0xFF6A5ACD), // Slate Blue
      const Color(0xFF20B2AA), // Light Sea Green
    ];
    
    for (int i = 0; i < widget.categoryPriceData.length && i < 6; i++) {
      final data = widget.categoryPriceData[i];
      sections.add(
        PieChartSectionData(
          color: _selectedSectionIndex == i 
              ? colors[i].withValues(alpha: 1.0) 
              : colors[i].withValues(alpha: 0.7),
          value: data.averagePrice,
          title: data.averagePrice.toStringAsFixed(0),
          radius: _selectedSectionIndex == i ? 60 : 50,
          titleStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          borderSide: BorderSide(
            color: _selectedSectionIndex == i 
                ? Colors.white 
                : Colors.transparent,
            width: _selectedSectionIndex == i ? 2 : 0,
          ),
        ),
      );
    }
    
    return sections;
  }

  Widget _buildDetailItem(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).brightness == Brightness.dark 
                ? Colors.white70 
                : Colors.black54,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}