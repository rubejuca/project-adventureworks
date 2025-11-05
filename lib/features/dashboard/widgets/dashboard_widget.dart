import 'package:flutter/material.dart';
import '../dashboard_controller.dart';
import 'summary_widget.dart';
import 'extended_summary_widget.dart';
import 'line_chart_card.dart';
import 'bar_graph_widget.dart';
import 'pie_chart_card.dart';
import 'horizontal_bar_chart.dart';
import 'status_bar_chart.dart';
import 'top_products_chart.dart';
import 'price_trend_chart.dart';
import 'inventory_distribution_chart.dart';
import 'dashboard_theme.dart';

class DashboardWidget extends StatefulWidget {
  final DashboardData data;

  const DashboardWidget({super.key, required this.data});

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> with TickerProviderStateMixin {
  int _selectedChartIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;

  // Filter out null categories for charts
  late final List<CategoryPriceData> validCategoryPriceData;
  late final List<StatusCountData> validStatusCountData;
  late final List<CategoryCountData> validCategoryCountData;

  @override
  void initState() {
    super.initState();
    validCategoryPriceData = widget.data.categoryPriceData
        .where((item) => item.category != null)
        .toList();
        
    validStatusCountData = widget.data.statusCountData
        .where((item) => item.status != null)
        .toList();
        
    validCategoryCountData = widget.data.categoryCountData
        .where((item) => item.category != null)
        .toList();
        
    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    
    // Start initial animation
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onChartSelected(int index) {
    _animationController.reset();
    setState(() {
      _selectedChartIndex = index;
    });
    _animationController.forward();
  }

  // Chart options with names and icons
  List<Map<String, dynamic>> get chartOptions => [
    {
      'name': 'Tendencia de Precios',
      'icon': Icons.show_chart,
    },
    {
      'name': 'Comparativo de Precios',
      'icon': Icons.bar_chart,
    },
    {
      'name': 'Distribución de Precios',
      'icon': Icons.pie_chart,
    },
    {
      'name': 'Productos por Categoría',
      'icon': Icons.view_week,
    },
    {
      'name': 'Estado de Productos',
      'icon': Icons.flag,
    },
    {
      'name': 'Productos Más Vendidos',
      'icon': Icons.trending_up,
    },
    {
      'name': 'Tendencia Histórica',
      'icon': Icons.timeline,
    },
    {
      'name': 'Distribución de Inventario',
      'icon': Icons.inventory,
    },
  ];

  Widget _buildSelectedChart() {
    Widget chartWidget;
    
    switch (_selectedChartIndex) {
      case 0:
        chartWidget = validCategoryPriceData.isNotEmpty 
          ? LineChartCard(categoryPriceData: validCategoryPriceData)
          : _buildNoDataWidget();
        break;
      case 1:
        chartWidget = validCategoryPriceData.isNotEmpty 
          ? BarGraphWidget(categoryPriceData: validCategoryPriceData)
          : _buildNoDataWidget();
        break;
      case 2:
        chartWidget = validCategoryPriceData.isNotEmpty 
          ? PieChartCard(categoryPriceData: validCategoryPriceData)
          : _buildNoDataWidget();
        break;
      case 3:
        chartWidget = validCategoryCountData.isNotEmpty 
          ? HorizontalBarChart(categoryCountData: validCategoryCountData)
          : _buildNoDataWidget();
        break;
      case 4:
        chartWidget = validStatusCountData.isNotEmpty 
          ? StatusBarChart(statusCountData: validStatusCountData)
          : _buildNoDataWidget();
        break;
      case 5:
        chartWidget = TopProductsChart(topProducts: widget.data.topProducts);
        break;
      case 6:
        chartWidget = PriceTrendChart(priceTrendData: widget.data.priceTrendData);
        break;
      case 7:
        chartWidget = InventoryDistributionChart(inventoryData: widget.data.inventoryData);
        break;
      default:
        chartWidget = _buildNoDataWidget();
    }
    
    return FadeTransition(
      opacity: _animation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            chartOptions[_selectedChartIndex]['name'] as String,
            style: DashboardTheme.headingMedium,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: DashboardTheme.cardBackgroundColor,
              borderRadius: DashboardTheme.cardBorderRadius,
              boxShadow: DashboardTheme.cardShadow,
            ),
            child: chartWidget,
          ),
        ],
      ),
    );
  }

  Widget _buildNoDataWidget() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.info_outline,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'No hay datos suficientes para mostrar esta gráfica',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: DashboardTheme.backgroundColor,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main KPIs with vibrant colors
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                SummaryWidget(
                  title: 'Productos',
                  value: widget.data.totalProducts.toString(),
                  icon: Icons.shopping_bag,
                  color: DashboardTheme.primaryBlue,
                ),
                SummaryWidget(
                  title: 'Categorías',
                  value: widget.data.totalCategories.toString(),
                  icon: Icons.category,
                  color: DashboardTheme.primaryGreen,
                ),
                SummaryWidget(
                  title: 'Estados',
                  value: widget.data.totalStatuses.toString(),
                  icon: Icons.flag,
                  color: DashboardTheme.accentOrange,
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Secondary KPIs with white cards and soft shadows
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildSecondaryKPI(
                  'Valor Inventario',
                  '\$${widget.data.totalInventoryValue.toStringAsFixed(0)}',
                  Icons.attach_money,
                ),
                _buildSecondaryKPI(
                  'Bajo Stock',
                  widget.data.lowStockProducts.toString(),
                  Icons.warning,
                ),
                _buildSecondaryKPI(
                  'Top Categoría',
                  widget.data.topCategory,
                  Icons.star,
                ),
                _buildSecondaryKPI(
                  'Precio Promedio',
                  '\$${widget.data.averagePrice.toStringAsFixed(2)}',
                  Icons.trending_up,
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // Chart selector (vertical)
            Container(
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
                    'Seleccionar Gráfica',
                    style: DashboardTheme.headingSmall,
                  ),
                  const SizedBox(height: 16),
                  ...List.generate(chartOptions.length, (index) {
                    final chart = chartOptions[index];
                    final isSelected = _selectedChartIndex == index;
                    
                    return Padding(
                      padding: EdgeInsets.only(bottom: index == chartOptions.length - 1 ? 0 : 8),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected 
                              ? DashboardTheme.primaryBlue 
                              : DashboardTheme.cardBackgroundColor,
                          foregroundColor: isSelected 
                              ? Colors.white 
                              : DashboardTheme.textPrimary,
                          elevation: isSelected ? 4 : 1,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: DashboardTheme.cardBorderRadius,
                          ),
                          side: BorderSide(
                            color: isSelected 
                                ? DashboardTheme.primaryBlue 
                                : DashboardTheme.textTertiary.withOpacity(0.2),
                          ),
                        ),
                        onPressed: () => _onChartSelected(index),
                        child: Row(
                          children: [
                            Icon(
                              chart['icon'] as IconData,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              chart['name'] as String,
                              style: TextStyle(
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                            const Spacer(),
                            if (isSelected)
                              const Icon(
                                Icons.check,
                                size: 18,
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Selected chart display with animation
            _buildSelectedChart(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSecondaryKPI(String title, String value, IconData icon) {
    return Container(
      width: 180,
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
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: DashboardTheme.primaryBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: DashboardTheme.primaryBlue,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: DashboardTheme.labelMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: DashboardTheme.headingSmall,
          ),
        ],
      ),
    );
  }
}