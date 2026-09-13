import 'package:dartz/dartz.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._remoteDataSource);

  final UserRemoteDataSource _remoteDataSource;

  @override
  Future<Either<String, List<User>>> getUsers() async {
    try {
      final models = await _remoteDataSource.fetchUsers();
      return Right(models.map((model) => model.toEntity()).toList());
    } catch (error) {
      return Left(error.toString());
    }
  }
}