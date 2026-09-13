import 'package:dio/dio.dart';

import '../models/user_model.dart';

abstract interface class UserRemoteDataSource {
  Future<List<UserModel>> fetchUsers();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  UserRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<UserModel>> fetchUsers() async {
    final response = await _dio.get(
      'https://jsonplaceholder.typicode.com/users',
    );
    final data = response.data as List<dynamic>;
    return data
        .map((item) => UserModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}