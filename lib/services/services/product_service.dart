//& Imports packages
import 'package:app_lojinha/utils/extract_error.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
//& Imports models
import 'package:app_lojinha/models/product.dart';

class ProductService {
  final _supabase = Supabase.instance.client;

  late final _products = _supabase.from('products');

  Future<List<Product>> getActiveProducts() async {
    try {
      final response = await _products
          .select()
          .eq('is_active', true)
          .order('name');

      return (response as List).map((json) => Product.fromJson(json)).toList();
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
      return null;
    }
  }

  Future<void> createProduct(Product product) async {
    try {
      final json = product.toJson();
      json.remove('id');
      await _products.insert(json);
    } catch (e) {
      throw extractSupabaseErrorMessage(e);
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      await _products.update(product.toJson()).eq('id', product.id);
    } catch (e) {
      throw Exception('Erro ao atualizar produto: $e');
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await _products.delete().eq('id', id);
    } catch (e) {
      throw Exception('Erro ao deletar produto: $e');
    }
  }
}

