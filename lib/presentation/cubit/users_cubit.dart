import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';

enum UsersStatus { initial, loading, success, error }

class UsersState {
  const UsersState({
    this.status = UsersStatus.initial,
    this.users = const [],
    this.query = '',
    this.favoriteIds = const {},
    this.errorMessage,
  });

  final UsersStatus status;
  final List<User> users;
  final String query;
  final Set<int> favoriteIds;
  final String? errorMessage;

  List<User> get filteredUsers {
    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) return users;
    return users
        .where((user) => user.name.toLowerCase().contains(normalizedQuery))
        .toList();
  }

  UsersState copyWith({
    UsersStatus? status,
    List<User>? users,
    String? query,
    Set<int>? favoriteIds,
    String? errorMessage,
  }) {
    return UsersState(
      status: status ?? this.status,
      users: users ?? this.users,
      query: query ?? this.query,
      favoriteIds: favoriteIds ?? this.favoriteIds,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class UsersCubit extends Cubit<UsersState> {
  UsersCubit(this._repository) : super(const UsersState());

  final UserRepository _repository;

  Future<void> loadUsers() async {
    emit(state.copyWith(status: UsersStatus.loading, errorMessage: null));
    final result = await _repository.getUsers();
    result.fold(
      (error) => emit(
        state.copyWith(status: UsersStatus.error, errorMessage: error),
      ),
      (users) => emit(state.copyWith(status: UsersStatus.success, users: users)),
    );
  }

  void updateQuery(String query) => emit(state.copyWith(query: query));

  void toggleFavorite(int userId) {
    final favoriteIds = {...state.favoriteIds};
    favoriteIds.contains(userId)
        ? favoriteIds.remove(userId)
        : favoriteIds.add(userId);
    emit(state.copyWith(favoriteIds: favoriteIds));
  }
}