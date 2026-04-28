import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/utils/extract_error.dart';
import 'supabase_service.dart';

class AuthService {
  final SupabaseClient _supabase = SupabaseService().client;

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
      throw extractSupabaseErrorMessage(e);
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
      throw extractSupabaseErrorMessage(e);
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw extractSupabaseErrorMessage(e);
    }
  }

  Future<void> resetPassword({required String email}) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw extractSupabaseErrorMessage(e);
    }
  }

  Future<UserResponse> updateUser({String? email, String? password}) async {
    try {
      return await _supabase.auth.updateUser(
        UserAttributes(email: email, password: password),
      );
    } catch (e) {
      throw extractSupabaseErrorMessage(e);
    }
  }

  User? get currentUser => _supabase.auth.currentUser;

  Stream<AuthState> get authState => _supabase.auth.onAuthStateChange;
}
