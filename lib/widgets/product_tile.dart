import 'package:flutter/material.dart';

import '../core/utils/format_utils.dart';
import '../models/product.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  final VoidCallback onAdd;
  final VoidCallback? onEdit;

  const ProductTile({
    super.key,
    required this.product,
    required this.onAdd,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            product.imageUrl ?? 'https://via.placeholder.com/150',
            width: 56,
            height: 56,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 56,
                height: 56,
                color: Colors.grey.shade200,
                child: const Icon(Icons.broken_image),
              );
            },
          ),
        ),
        title: Text(
          product.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${FormatUtils.formatCurrency(product.price)} • Estoque: ${product.stock}',
        ),
        trailing: SizedBox(
          width: onEdit == null ? 48 : 96,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (onEdit != null)
                IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
              IconButton(
                icon: const Icon(Icons.add_shopping_cart),
                onPressed: product.stock > 0 ? onAdd : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
