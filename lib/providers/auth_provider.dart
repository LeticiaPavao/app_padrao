import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;
  bool _isLoading = false;
  StreamSubscription<AuthState>? _authSubscription;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _user = _authService.currentUser;

    _authSubscription = _authService.authState.listen((AuthState state) {
      _user = state.session?.user;
      notifyListeners();
    });
  }

  Future<String?> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    _setLoading(true);

    try {
      final response = await _authService.signUp(
        email: email,
        password: password,
        userData: {'full_name': fullName},
      );

      _user = response.user;
      return null;
    } catch (e) {
      return e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    _setLoading(true);

    try {
      final response = await _authService.signIn(
        email: email,
        password: password,
      );

      _user = response.user;
      return null;
    } catch (e) {
      return e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> resetPassword({required String email}) async {
    _setLoading(true);

    try {
      await _authService.resetPassword(email: email);
      return null;
    } catch (e) {
      return e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> updateUser({String? email, String? password}) async {
    _setLoading(true);

    try {
      await _authService.updateUser(email: email, password: password);
      return null;
    } catch (e) {
      return e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<String?> signOut() async {
    _setLoading(true);

    try {
      await _authService.signOut();
      _user = null;
      return null;
    } catch (e) {
      return e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
