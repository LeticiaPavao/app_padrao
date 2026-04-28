import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/order.dart';

class OrderService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Order>> getUserOrders(String userId) async {
    try {
      final response = await _supabase
          .from('orders')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => Order.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar pedidos: $e');
    }
  }
}
