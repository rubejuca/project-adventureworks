import 'package:flutter/material.dart';
import '../../../models/product.dart';
import '../../../services/product_service_firebase.dart';
import 'dart:math';

class CreateProductPage extends StatefulWidget {
  static const route = '/create-product';

  const CreateProductPage({super.key});

  @override
  State<CreateProductPage> createState() => _CreateProductPageState();
}

class _CreateProductPageState extends State<CreateProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _firebaseService = ProductServiceFirebase();

  // Form controllers
  final _nameController = TextEditingController();
  final _productNumberController = TextEditingController();
  final _colorController = TextEditingController();
  final _listPriceController = TextEditingController();
  final _categoryController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _brandController = TextEditingController();
  final _statusController = TextEditingController();
  final _warrantyController = TextEditingController();
  final _shippingController = TextEditingController();
  bool _stock = true;

  // Dropdown values
  String? _selectedCategory;
  String? _selectedColor;
  String? _selectedStatus;
  String? _selectedWarranty;

  // Predefined options
  final List<String> _categories = [
    'Bicicletas',
    'Marcos',
    'Cascos',
    'Ropa',
    'Herramientas',
    'Componentes',
    'Otros',
  ];

  final List<String> _colors = [
    'Rojo',
    'Azul',
    'Verde',
    'Negro',
    'Blanco',
    'Amarillo',
    'Morado',
    'Naranja',
    'Gris',
    'Plateado',
    'Dorado',
    'Multicolor',
  ];

  final List<String> _statuses = [
    'Nuevo',
    'Usado',
    'Reacondicionado',
    'Defectuoso',
  ];

  final List<String> _warranties = [
    'Sin garantía',
    '30 días',
    '3 meses',
    '6 meses',
    '1 año',
    '2 años',
    '3 años',
    '5 años',
    'Garantía de por vida',
  ];

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _productNumberController.dispose();
    _colorController.dispose();
    _listPriceController.dispose();
    _categoryController.dispose();
    _descriptionController.dispose();
    _brandController.dispose();
    _statusController.dispose();
    _warrantyController.dispose();
    _shippingController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      // Generate a unique ID for the product
      final productId = _generateProductId();

      final product = Product(
        id: productId,
        name: _nameController.text.trim(),
        productNumber: _productNumberController.text.trim(),
        color:
            _selectedColor ??
            (_colorController.text.trim().isEmpty
                ? null
                : _colorController.text.trim()),
        listPrice: double.tryParse(_listPriceController.text) ?? 0.0,
        category:
            _selectedCategory ??
            (_categoryController.text.trim().isEmpty
                ? null
                : _categoryController.text.trim()),
        description:
            _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
        brand:
            _brandController.text.trim().isEmpty
                ? null
                : _brandController.text.trim(),
        status:
            _selectedStatus ??
            (_statusController.text.trim().isEmpty
                ? null
                : _statusController.text.trim()),
        warranty:
            _selectedWarranty ??
            (_warrantyController.text.trim().isEmpty
                ? null
                : _warrantyController.text.trim()),
        shipping:
            _shippingController.text.trim().isEmpty
                ? null
                : _shippingController.text.trim(),
        stock: _stock,
      );

      await _firebaseService.addProduct(product);

      if (!mounted) return;

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Producto creado exitosamente'),
            ],
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back
      Navigator.of(context).pop(true); // Return true to indicate success
    } catch (e) {
      if (!mounted) return;

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 8),
              Text('Error: ${e.toString()}'),
            ],
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _generateProductId() {
    // Generate a unique ID using timestamp and random number
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(1000);
    return 'prod_$timestamp$random';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Producto'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Name field
              _buildTextFormField(
                controller: _nameController,
                label: 'Nombre',
                hint: 'Nombre del producto',
                icon: Icons.label_outline,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el nombre del producto';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Product Number field
              _buildTextFormField(
                controller: _productNumberController,
                label: 'Número de Producto',
                hint: 'Número único del producto',
                icon: Icons.confirmation_number_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el número de producto';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Category dropdown
              _buildDropdownField(
                label: 'Categoría',
                hint: 'Selecciona una categoría',
                icon: Icons.category_outlined,
                value: _selectedCategory,
                items: _categories,
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                controller: _categoryController,
              ),
              const SizedBox(height: 16),

              // Color dropdown
              _buildDropdownField(
                label: 'Color',
                hint: 'Selecciona un color',
                icon: Icons.color_lens_outlined,
                value: _selectedColor,
                items: _colors,
                onChanged: (value) {
                  setState(() {
                    _selectedColor = value;
                  });
                },
                controller: _colorController,
              ),
              const SizedBox(height: 16),

              // Price field
              _buildTextFormField(
                controller: _listPriceController,
                label: 'Precio',
                hint: 'Precio del producto',
                icon: Icons.attach_money,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el precio';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Por favor ingresa un precio válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description field
              _buildTextFormField(
                controller: _descriptionController,
                label: 'Descripción',
                hint: 'Descripción del producto (opcional)',
                icon: Icons.description_outlined,
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              // Brand field
              _buildTextFormField(
                controller: _brandController,
                label: 'Marca',
                hint: 'Marca del producto (opcional)',
                icon: Icons.branding_watermark_outlined,
              ),
              const SizedBox(height: 16),

              // Status dropdown
              _buildDropdownField(
                label: 'Estado',
                hint: 'Selecciona el estado',
                icon: Icons.info_outline,
                value: _selectedStatus,
                items: _statuses,
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value;
                  });
                },
                controller: _statusController,
              ),
              const SizedBox(height: 16),

              // Warranty dropdown
              _buildDropdownField(
                label: 'Garantía',
                hint: 'Selecciona la garantía',
                icon: Icons.security_outlined,
                value: _selectedWarranty,
                items: _warranties,
                onChanged: (value) {
                  setState(() {
                    _selectedWarranty = value;
                  });
                },
                controller: _warrantyController,
              ),
              const SizedBox(height: 16),

              // Shipping field
              _buildTextFormField(
                controller: _shippingController,
                label: 'Envío',
                hint: 'Información de envío (opcional)',
                icon: Icons.local_shipping_outlined,
              ),
              const SizedBox(height: 16),

              // Stock switch
              Card(
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.inventory_outlined,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Text('En Stock', style: theme.textTheme.titleMedium),
                        ],
                      ),
                      Switch(
                        value: _stock,
                        onChanged: (value) {
                          setState(() => _stock = value);
                        },
                        activeColor: colorScheme.primary,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Submit button
              FilledButton(
                onPressed: _isLoading ? null : _submitForm,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child:
                    _isLoading
                        ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 12),
                            Text('Creando producto...'),
                          ],
                        )
                        : const Text(
                          'Crear Producto',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            prefixIcon: Icon(icon),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          validator: validator,
          keyboardType: keyboardType,
          maxLines: maxLines,
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String hint,
    required IconData icon,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    required TextEditingController controller,
  }) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 24),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: value,
              hint: Text(hint),
              items:
                  items.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              onChanged: onChanged,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'O escribe una opción personalizada',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
