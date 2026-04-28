import 'package:flutter/material.dart';
import '../../../core/utils/format_utils.dart';
import '../../../models/product.dart';

class ProductForm extends StatefulWidget {
  final Product? initialProduct;
  final String buttonText;
  final Future<void> Function(Product product) onSubmit;

  const ProductForm({
    super.key,
    this.initialProduct,
    required this.buttonText,
    required this.onSubmit,
  });

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _categoryController = TextEditingController();
  final _stockController = TextEditingController();
  final _supplierController = TextEditingController();
  final _weightController = TextEditingController();

  DateTime? _expiryDate;
  String _unitOfMeasure = 'un';
  bool _isActive = true;
  bool _isLoading = false;

  final List<String> _units = ['un', 'kg', 'g', 'l', 'ml', 'cx'];

  @override
  void initState() {
    super.initState();

    final product = widget.initialProduct;

    if (product != null) {
      _nameController.text = product.name;
      _priceController.text = product.price.toStringAsFixed(2);
      _descriptionController.text = product.description ?? '';
      _imageUrlController.text = product.imageUrl ?? '';
      _categoryController.text = product.category;
      _stockController.text = product.stock.toString();
      _supplierController.text = product.supplier;
      _weightController.text = product.weight?.toString() ?? '';
      _expiryDate = product.expiryDate;
      _unitOfMeasure = product.unitOfMeasure;
      _isActive = product.isActive;
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expiryDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _expiryDate = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final now = DateTime.now();
      final initial = widget.initialProduct;

      final product = Product(
        id: initial?.id ?? '',
        name: _nameController.text.trim(),
        price: FormatUtils.parseBrazilianDouble(_priceController.text.trim()),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        imageUrl: _imageUrlController.text.trim().isEmpty
            ? null
            : _imageUrlController.text.trim(),
        category: _categoryController.text.trim(),
        stock: int.parse(_stockController.text.trim()),
        expiryDate: _expiryDate,
        supplier: _supplierController.text.trim(),
        weight: _weightController.text.trim().isEmpty
            ? null
            : FormatUtils.parseBrazilianDouble(_weightController.text.trim()),
        unitOfMeasure: _unitOfMeasure,
        isActive: _isActive,
        createdAt: initial?.createdAt ?? now,
        updatedAt: now,
      );

      await widget.onSubmit(product);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _categoryController.dispose();
    _stockController.dispose();
    _supplierController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nome do Produto *',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Campo obrigatório';
              }

              return null;
            },
          ),
          const SizedBox(height: 12),

          TextFormField(
            controller: _priceController,
            decoration: const InputDecoration(
              labelText: 'Preço (R\$) *',
              border: OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Campo obrigatório';
              }

              final parsed = double.tryParse(value.replaceAll(',', '.'));

              if (parsed == null) {
                return 'Digite um número válido';
              }

              if (parsed < 0) {
                return 'O preço não pode ser negativo';
              }

              return null;
            },
          ),
          const SizedBox(height: 12),

          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Descrição',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 12),

          TextFormField(
            controller: _imageUrlController,
            decoration: const InputDecoration(
              labelText: 'URL da Imagem',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          TextFormField(
            controller: _categoryController,
            decoration: const InputDecoration(
              labelText: 'Categoria *',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Campo obrigatório';
              }

              return null;
            },
          ),
          const SizedBox(height: 12),

          TextFormField(
            controller: _stockController,
            decoration: const InputDecoration(
              labelText: 'Estoque *',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Campo obrigatório';
              }

              final parsed = int.tryParse(value);

              if (parsed == null) {
                return 'Digite um número inteiro';
              }

              if (parsed < 0) {
                return 'O estoque não pode ser negativo';
              }

              return null;
            },
          ),
          const SizedBox(height: 12),

          TextFormField(
            controller: _supplierController,
            decoration: const InputDecoration(
              labelText: 'Fornecedor *',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Campo obrigatório';
              }

              return null;
            },
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _weightController,
                  decoration: const InputDecoration(
                    labelText: 'Peso',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _unitOfMeasure,
                  decoration: const InputDecoration(
                    labelText: 'Unidade *',
                    border: OutlineInputBorder(),
                  ),
                  items: _units.map((unit) {
                    return DropdownMenuItem(value: unit, child: Text(unit));
                  }).toList(),
                  onChanged: (value) {
                    if (value == null) return;

                    setState(() {
                      _unitOfMeasure = value;
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          InkWell(
            onTap: _selectDate,
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Data de Validade',
                border: OutlineInputBorder(),
              ),
              child: Text(FormatUtils.formatDate(_expiryDate)),
            ),
          ),
          const SizedBox(height: 12),

          SwitchListTile(
            title: const Text('Produto ativo'),
            value: _isActive,
            onChanged: (value) {
              setState(() {
                _isActive = value;
              });
            },
          ),
          const SizedBox(height: 24),

          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: Text(widget.buttonText),
                ),
        ],
      ),
    );
  }
}
