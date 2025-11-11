import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheToken(String token);
  Future<String?> getCachedToken();
  Future<void> deleteToken();

  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> deleteUser();

  Future<void> clearAll();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({
    required this.secureStorage,
    required this.sharedPreferences,
  });

  @override
  Future<void> cacheToken(String token) async {
    try {
      await secureStorage.write(
        key: AppConstants.authTokenKey,
        value: token,
      );
    } catch (e) {
      throw CacheException('Failed to cache token');
    }
  }

  @override
  Future<String?> getCachedToken() async {
    try {
      return await secureStorage.read(key: AppConstants.authTokenKey);
    } catch (e) {
      throw CacheException('Failed to get cached token');
    }
  }

  @override
  Future<void> deleteToken() async {
    try {
      await secureStorage.delete(key: AppConstants.authTokenKey);
    } catch (e) {
      throw CacheException('Failed to delete token');
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final userJson = json.encode(user.toJson());
      await sharedPreferences.setString(AppConstants.userKey, userJson);
    } catch (e) {
      throw CacheException('Failed to cache user');
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userJson = sharedPreferences.getString(AppConstants.userKey);
      if (userJson != null) {
        return UserModel.fromJson(json.decode(userJson));
      }
      return null;
    } catch (e) {
      throw CacheException('Failed to get cached user');
    }
  }

  @override
  Future<void> deleteUser() async {
    try {
      await sharedPreferences.remove(AppConstants.userKey);
    } catch (e) {
      throw CacheException('Failed to delete user');
    }
  }

  @override
  Future<void> clearAll() async {
    try {
      await deleteToken();
      await deleteUser();
    } catch (e) {
      throw CacheException('Failed to clear cache');
    }
  }
}
