import 'package:flutter/material.dart';

import '../../models/product.dart';
import '../../services/product_service.dart';
import 'widgets/product_form.dart';

class RegisterProductPage extends StatelessWidget {
  const RegisterProductPage({super.key});

  Future<void> _createProduct(BuildContext context, Product product) async {
    final productService = ProductService();

    try {
      await productService.createProduct(product);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produto cadastrado com sucesso!')),
        );

        Navigator.pop(context, true);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao cadastrar produto: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Produto')),
      body: ProductForm(
        buttonText: 'Salvar Produto',
        onSubmit: (product) => _createProduct(context, product),
      ),
    );
  }
}