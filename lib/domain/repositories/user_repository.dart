import 'package:dartz/dartz.dart';

import '../entities/user.dart';

abstract interface class UserRepository {
  Future<Either<String, List<User>>> getUsers();
}