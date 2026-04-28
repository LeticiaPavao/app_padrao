import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/format_utils.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../services/notification_service.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  Future<void> _finishOrder(BuildContext context) async {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);

    final user = auth.user;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Você precisa estar logado para finalizar o pedido.'),
        ),
      );
      return;
    }

    try {
      await cart.finishOrder(user.id);

      await NotificationService.instance.showNotification(
        title: 'Pedido confirmado',
        body: 'Seu pedido foi realizado com sucesso!',
        payload: 'order_success',
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pedido realizado com sucesso!')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao finalizar pedido: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    if (cart.isEmpty) {
      return const Center(child: Text('Seu carrinho está vazio.'));
    }
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: cart.items.length,
            itemBuilder: (context, index) {
              final item = cart.items[index];
              final product = item.product;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: product.imageUrl != null
                      ? Image.network(
                          product.imageUrl!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image, size: 50);
                          },
                        )
                      : const Icon(Icons.shopping_bag, size: 50),
                  title: Text(product.name),
                  subtitle: Text(
                    '${FormatUtils.formatCurrency(product.price)} x ${item.quantity}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () => cart.removeOne(product),
                      ),
                      Text('${item.quantity}'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => cart.add(product),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            border: Border(top: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Total: ${FormatUtils.formatCurrency(cart.total)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () => _finishOrder(context),
                icon: const Icon(Icons.check_circle),
                label: const Text('Finalizar Pedido'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
