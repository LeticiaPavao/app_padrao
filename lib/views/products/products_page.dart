import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../providers/cart_provider.dart';
import '../../services/product_service.dart';
import '../../widgets/product_tile.dart';
import 'register_product_page.dart';
import 'update_product_page.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final ProductService _productService = ProductService();

  late Future<List<Product>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    _futureProducts = _productService.getActiveProducts();
  }

  Future<void> _refreshProducts() async {
    setState(_loadProducts);
  }

  Future<void> _openRegisterProduct() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterProductPage()),
    );

    if (result == true) {
      _refreshProducts();
    }
  }

  Future<void> _openUpdateProduct(String productId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateProductPage(productId: productId),
      ),
    );

    if (result == true) {
      _refreshProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _openRegisterProduct,
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshProducts,
        child: FutureBuilder<List<Product>>(
          future: _futureProducts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Erro: ${snapshot.error}'));
            }

            final products = snapshot.data ?? [];

            if (products.isEmpty) {
              return const Center(child: Text('Nenhum produto encontrado'));
            }

            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];

                return ProductTile(
                  product: product,
                  onAdd: () {
                    cart.add(product);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${product.name} adicionado ao carrinho.',
                        ),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  onEdit: () => _openUpdateProduct(product.id),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
