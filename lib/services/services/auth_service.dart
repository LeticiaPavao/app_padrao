//& Imports packages
import 'package:app_lojinha/utils/extract_error.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'supabase_service.dart';

class AuthService {
  final _supabase = SupabaseService().client;

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? userData,
  }) async {
    try {
      return await _supabase.auth.signUp(
        email: email,
        password: password,
        data: userData,
      );
    } catch (e) {
      final message = extractSupabaseErrorMessage(e);
      throw message; 
    }
  }

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      return await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      final message = extractSupabaseErrorMessage(e);
      throw message;
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      final message = extractSupabaseErrorMessage(e);
      throw message;
    }
  }

  User? get currentUser => _supabase.auth.currentUser;

  Stream<AuthState> get authState => _supabase.auth.onAuthStateChange;

  Future<void> resetPassword({required String email}) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      final message = extractSupabaseErrorMessage(e);
      throw message;
    }
  }

  Future<UserResponse> updateUser({
    required String email,
    required String password,
  }) async {
    try {
      return await _supabase.auth.updateUser(
        UserAttributes(email: email, password: password),
      );
    } catch (e) {
      final message = extractSupabaseErrorMessage(e);
      throw message;
    }
  }
}
