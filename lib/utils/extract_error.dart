import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_error_translator_flutter/supabase_error_translator_flutter.dart';

String extractSupabaseErrorMessage(Object error) {

  if (error is PostgrestException) {
    final errorCode = error.message;
    return SupabaseErrorTranslator.translate(
      errorCode,
      ErrorService.database,
    );
  }

  if (error is AuthException) {
    final errorCode = error.message;
    return SupabaseErrorTranslator.translate(
      errorCode,
      ErrorService.auth,
    );
  }

  if (error is StorageException) {
    final errorCode = error.message;
    return SupabaseErrorTranslator.translate(
      errorCode,
      ErrorService.storage,
    );
  }

  if (error is AuthApiException) {
    final errorCode = error.message;
    return SupabaseErrorTranslator.translate(
      errorCode,
      ErrorService.auth,
    );
  }

  return 'Ocorreu um erro inesperado. Tente novamente.';
}