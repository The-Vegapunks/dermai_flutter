import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Future<String> signIn({required String email, required String password});
  Future<String> signUp(
      {required String name, required String email, required String password});
  Future<String> forgotPassword({required String email});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient client;
  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<String> forgotPassword({
    required String email,
  }) async {
    try {
      await client.auth.resetPasswordForEmail(email);
      return "Reset password email sent";
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    final response = await client.auth.signInWithPassword(email: email, password: password);

    return response.user!.id;
  }

  @override
  Future<String> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await client.auth.signUp(email: email, password: password, data: {
      'name': name,
      'doctor': false,
    });

    return response.user!.id;
  }
}
