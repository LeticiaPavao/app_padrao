import 'package:supabase_error_translator_flutter/supabase_error_translator_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

String extractSupabaseErrorMessage(Object error) {
  if (error is PostgrestException) {
    return SupabaseErrorTranslator.translate(
      error.message,
      ErrorService.database,
    );
  }

  if (error is AuthApiException) {
    return SupabaseErrorTranslator.translate(error.message, ErrorService.auth);
  }

  if (error is AuthException) {
    return SupabaseErrorTranslator.translate(error.message, ErrorService.auth);
  }

  if (error is StorageException) {
    return SupabaseErrorTranslator.translate(
      error.message,
      ErrorService.storage,
    );
  }

  return 'Ocorreu um erro inesperado. Tente novamente.';
}
