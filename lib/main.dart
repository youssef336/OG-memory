import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'data/datasources/user_remote_data_source.dart';
import 'data/repositories/user_repository_impl.dart';
import 'domain/repositories/user_repository.dart';
import 'presentation/cubit/users_cubit.dart';
import 'presentation/pages/users_page.dart';

final getIt = GetIt.instance;

void configureDependencies() {
  getIt
    ..registerLazySingleton<Dio>(Dio.new)
    ..registerLazySingleton<UserRemoteDataSource>(
      () => UserRemoteDataSourceImpl(getIt()),
    )
    ..registerLazySingleton<UserRepository>(() => UserRepositoryImpl(getIt()));
}

void main() {
  configureDependencies();
  runApp(const UsersApp());
}

class UsersApp extends StatelessWidget {
  const UsersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interview Users',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (_) => UsersCubit(getIt())..loadUsers(),
        child: const UsersPage(),
      ),
    );
  }
}