import 'dart:collection';

import 'package:dermai/features/auth/data/models/user_model.dart';
import 'package:dermai/features/core/error/exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get session;

  Future<UserModel> signIn({required String email, required String password});
  Future<UserModel> signUp(
      {required String name, required String email, required String password});
  Future<String> forgotPassword({required String email});
  Future<UserModel?> getCurrentUserData();
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
      throw const ServerException(
          'An error occurred while sending the reset password email');
    }
  }

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.auth
          .signInWithPassword(email: email, password: password);

      if (response.user == null) {
        throw const ServerException('User not found');
      }

      if (response.user!.userMetadata!['isDoctor'] == true) {
        final userData = await client.from('doctor').select().eq(
              'doctorID',
              response.user!.id,
            );
        return UserModel.fromJsonDoctor(userData.first);
      } else {
        final userData = await client.from('patient').select().eq(
              'patientID',
              response.user!.id,
            );
        return UserModel.fromJsonPatient(userData.first);
      }
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response =
          await client.auth.signUp(email: email, password: password, data: {
        'name': name,
        'isDoctor': false,
      });

      if (response.user == null) {
        throw const ServerException('User not created');
      }
      return UserModel.fromJsonPatient(response.user!.toJson());
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Session? get session => client.auth.currentSession;

  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (session != null) {
        if (session!.user.userMetadata!['isDoctor'] == true) {
          final userData = await client.from('doctor').select().eq(
                'doctorID',
                session!.user.id,
              );
          return UserModel.fromJsonDoctor(userData.first);
        } else {
          final Map<String, dynamic> map = HashMap();
          map['patientID'] = session!.user.id;
          map['name'] = session!.user.userMetadata!['name'];
          map['email'] = session!.user.email;
          return UserModel.fromJsonPatient(map);
        }
      }

      return null;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
