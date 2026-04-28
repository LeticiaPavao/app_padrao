import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/utils/extract_error.dart';
import '../models/product.dart';

class ProductService {
  final SupabaseClient _supabase = Supabase.instance.client;

  SupabaseQueryBuilder get _products => _supabase.from('products');

  Future<List<Product>> getActiveProducts() async {
    try {
      final response = await _products
          .select()
          .eq('is_active', true)
          .order('name', ascending: true);

      return (response as List)
          .map((json) => Product.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar produtos: $e');
    }
  }

  Future<Product?> getProduct(String id) async {
    try {
      final response = await _products.select().eq('id', id).maybeSingle();

      if (response == null) return null;

      return Product.fromJson(response);
    } catch (e) {
      throw Exception('Erro ao buscar produto: $e');
    }
  }

  Future<void> createProduct(Product product) async {
    try {
      final json = product.toJson();

      json.remove('id');
      json.remove('created_at');
      json.remove('updated_at');

      await _products.insert(json);
    } catch (e) {
      throw extractSupabaseErrorMessage(e);
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      final json = product.toJson();

      json.remove('id');
      json.remove('created_at');
      json.remove('updated_at');

      await _products.update(json).eq('id', product.id);
    } catch (e) {
      throw extractSupabaseErrorMessage(e);
    }
  }

  Future<void> deactivateProduct(String id) async {
    try {
      await _products.update({'is_active': false}).eq('id', id);
    } catch (e) {
      throw extractSupabaseErrorMessage(e);
    }
  }
}
