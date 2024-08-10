import 'dart:collection';

import 'package:dermai/env/env.dart';
import 'package:dermai/features/auth/data/models/user_model.dart';
import 'package:dermai/features/core/error/exception.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart' as stream;

abstract interface class AuthRemoteDataSource {
  Session? get session;

  Future<UserModel> signIn({required String email, required String password});
  Future<UserModel> signUp(
      {required String name, required String email, required String password});
  Future<String> forgotPassword({required String email});
  Future<UserModel?> getCurrentUserData();
  Future<void> verifyOTPForRecovery(
      {required String email, required String token});
  Future<void> changePassword(
      {required String email, required String password});
  Future<void> deleteAccount();
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

      await stream.StreamVideo.reset(disconnect: true);

      if (response.user!.userMetadata!['isDoctor'] == true) {
        final userData = await client.from('doctor').select().eq(
              'doctorID',
              response.user!.id,
            );
        final streamClient = stream.StreamVideo(Env.streamAPIKey,
            user: stream.User.guest(
                userId: response.user!.id,
                name: response.user!.userMetadata!['name']));
        await streamClient.connect();
        return UserModel.fromJsonDoctor(userData.first);
      } else {
        final userData = await client.from('patient').select().eq(
              'patientID',
              response.user!.id,
            );
        final streamClient = stream.StreamVideo(Env.streamAPIKey,
            user: stream.User.guest(
                userId: response.user!.id,
                name: response.user!.userMetadata!['name']));
        await streamClient.connect();
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
      final userData = await client.from('patient').select().eq(
            'patientID',
            response.user!.id,
          );
      final streamClient = stream.StreamVideo(Env.streamAPIKey,
          user: stream.User.guest(
              userId: response.user!.id,
              name: response.user!.userMetadata!['name']));
      await streamClient.connect();
      return UserModel.fromJsonPatient(userData.first);
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

  @override
  Future<void> verifyOTPForRecovery(
      {required String email, required String token}) async {
    try {
      final verifyOTP = await client.auth
          .verifyOTP(email: email, token: token, type: OtpType.recovery);

      if (verifyOTP.user == null) {
        throw const ServerException('An error occurred while verifying OTP');
      }
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> changePassword(
      {required String email, required String password}) async {
    try {
      final response = await client.auth
          .updateUser(UserAttributes(email: email, password: password));

      if (response.user == null) {
        throw const ServerException(
            'An error occurred while updating password');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await stream.StreamVideo.reset(disconnect: true);
      await client.auth.signOut();
    } catch (e) {
      throw const ServerException(
          'An error occurred while deleting the account');
    }
  }
}
