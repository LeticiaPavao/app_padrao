import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  bool get isEmpty => _items.isEmpty;

  double get total {
    return _items.fold(0, (sum, item) => sum + item.subtotal);
  }

  int get totalQuantity {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  void add(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);

    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }

    notifyListeners();
  }

  void removeOne(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);

    if (index < 0) return;

    if (_items[index].quantity > 1) {
      _items[index].quantity--;
    } else {
      _items.removeAt(index);
    }

    notifyListeners();
  }

  void removeAll(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  Future<void> finishOrder(String userId) async {
    if (_items.isEmpty) return;

    try {
      final supabase = Supabase.instance.client;

      final orderResponse = await supabase
          .from('orders')
          .insert({
            'user_id': userId,
            'status': 'pending',
            'payment_status': 'pending',
          })
          .select('id')
          .single();

      final orderId = orderResponse['id'] as String;

      final itemsToInsert = _items.map((item) {
        return {
          'order_id': orderId,
          'product_id': item.product.id,
          'product_name': item.product.name,
          'quantity': item.quantity,
          'unit_price': item.product.price,
          'subtotal': item.subtotal,
        };
      }).toList();

      await supabase.from('order_items').insert(itemsToInsert);

      clear();
    } catch (e) {
      throw Exception('Erro ao processar pedido: $e');
    }
  }
}
