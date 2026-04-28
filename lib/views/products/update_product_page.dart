import 'package:flutter/material.dart';

import '../../models/product.dart';
import '../../services/product_service.dart';
import 'widgets/product_form.dart';

class UpdateProductPage extends StatefulWidget {
  final String productId;

  const UpdateProductPage({super.key, required this.productId});

  @override
  State<UpdateProductPage> createState() => _UpdateProductPageState();
}

class _UpdateProductPageState extends State<UpdateProductPage> {
  final ProductService _productService = ProductService();

  late Future<Product?> _futureProduct;

  @override
  void initState() {
    super.initState();
    _futureProduct = _productService.getProduct(widget.productId);
  }

  Future<void> _updateProduct(BuildContext context, Product product) async {
    try {
      await _productService.updateProduct(product);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produto atualizado com sucesso!')),
        );

        Navigator.pop(context, true);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao atualizar produto: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Produto')),
      body: FutureBuilder<Product?>(
        future: _futureProduct,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar produto: ${snapshot.error}'),
            );
          }

          final product = snapshot.data;

          if (product == null) {
            return const Center(child: Text('Produto não encontrado'));
          }

          return ProductForm(
            initialProduct: product,
            buttonText: 'Salvar Alterações',
            onSubmit: (updatedProduct) {
              return _updateProduct(context, updatedProduct);
            },
          );
        },
      ),
    );
  }
}
