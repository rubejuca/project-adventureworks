import 'package:flutter/material.dart';
import 'widgets/dashboard_widget.dart';
import 'widgets/header_widget.dart';
import 'dashboard_controller.dart';

class DashboardPage extends StatefulWidget {
  final bool useFirebase;
  
  const DashboardPage({super.key, this.useFirebase = true});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final DashboardController _controller;

  @override
  void initState() {
    super.initState();
    _controller = DashboardController(useFirebase: widget.useFirebase);
    _controller.loadDashboardData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: StreamBuilder<DashboardData?> (
          stream: _controller.dashboardDataStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError || !snapshot.hasData) {
              return const Center(
                child: Text('Error al cargar los datos'),
              );
            }

            final data = snapshot.data!;
            
            // Show empty state if no products
            if (data.totalProducts == 0) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Sin información disponible',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderWidget(
                    title: widget.useFirebase 
                      ? 'Dashboard (Firebase)' 
                      : 'Dashboard (Estático)'
                  ),
                  const SizedBox(height: 20),
                  DashboardWidget(data: data),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}