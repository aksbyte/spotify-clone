import 'dart:convert';
import 'package:client/core/constant/server_constant.dart';
import 'package:client/core/failure/app_failure.dart';
import 'package:client/core/model/user_model.dart';
import 'package:client/helper/logcat.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_remote_repository.g.dart';

@riverpod
AuthRemoteRepository authRemoteRepository(AuthRemoteRepositoryRef ref) {
  return AuthRemoteRepository();
}

class AuthRemoteRepository {
  static const Map<String, String> header = {
    'Content-Type': 'application/json',
  };

  Future<Either<AppFailure, UserModel>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ServerConstant.signupUrl),
        headers: header,
        body: jsonEncode({'name': name, 'email': email, 'password': password}),
      );
      //  logCat(response.body);
      logCat(response.statusCode);
      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;
      //  logCat(resBodyMap.toString());
      if (response.statusCode != 201) {
        return Left(AppFailure(resBodyMap['detail']));
      }
      return Right(UserModel.fromMap(resBodyMap));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> login(
      {required String email, required String password}) async {
    try {
      final response = await http.post(
        Uri.parse(ServerConstant.loginUrl),
        headers: header,
        body: jsonEncode({'email': email, 'password': password}),
      );
      // logCat(response.body);
      logCat(response.statusCode);
      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;
      //logCat(resBodyMap.toString());
      if (response.statusCode != 200) {
        return Left(AppFailure(resBodyMap['detail']));
      }
      logCat(resBodyMap['token']);
      return Right(UserModel.fromMap(resBodyMap['user'])
          .copyWith(token: resBodyMap['token']));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> getCurrentUser(
      {required String token}) async {
    try {
      final response = await http.get(
        Uri.parse(ServerConstant.auth),
        headers: {'Content-Type': 'application/json', 'x-auth-token': token},
      );
      // logCat(response.body);
      logCat(response.statusCode);
      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;
      //logCat(resBodyMap.toString());
      if (response.statusCode != 200) {
        return Left(AppFailure(resBodyMap['detail']));
      }
      logCat(resBodyMap['token']);
      return Right(UserModel.fromMap(resBodyMap).copyWith(token: token));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}

/*
class AuthRemoteRepository {
  // Previous api 192.168.50.173

  static const String signupUrl = 'http://192.168.50.173:8000/auth/signup';
  static const String loginUrl = 'http://192.168.50.173:8000/auth/login';
  static const Map<String, String> header = {
    'Content-Type': 'application/json'
  };

  Future<Either<AppFailure, UserModel>> _post(
      {required String endpoint, required Map<String, dynamic> body}) async {
    try {
      final response = await http.post(Uri.parse(endpoint),
          headers: header, body: jsonEncode(body));
      logCat(response.body);
      logCat(response.statusCode);
      final resBodyMap = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode != 200) {
        return Left(AppFailure(resBodyMap['detail']));
      }
      return Right(UserModel.fromMap(resBodyMap));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  Future<void> _get({required String url, required Object object}) async {
    try {
      final response = await http.post(Uri.parse(url),
          headers: header, body: jsonEncode(object));
      logCat(response.body);
      logCat(response.statusCode);
    } catch (e) {
      logCat(e.toString());
    }
  }

  Future<void> signup(
      {required String name,
      required String email,
      required String password}) async {
    await _post(
        endpoint: signupUrl,
        body: {'name': name, 'email': email, 'password': password});
  }

  Future<void> login({required String email, required String password}) async {
    final res = await _post(
        endpoint: loginUrl, body: {'email': email, 'password': password});
    logCat(res);
  }
}*/
