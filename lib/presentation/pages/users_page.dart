import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user.dart';
import '../cubit/users_cubit.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          BlocSelector<UsersCubit, UsersState, int>(
            selector: (state) => state.favoriteIds.length,
            builder: (context, favoriteCount) => Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                children: [
                  const Icon(Icons.favorite, color: Colors.red),
                  const SizedBox(width: 4),
                  Text('$favoriteCount'),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                onChanged: context.read<UsersCubit>().updateQuery,
                decoration: const InputDecoration(
                  labelText: 'Search by name',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<UsersCubit, UsersState>(
                builder: (context, state) {
                  return switch (state.status) {
                    UsersStatus.initial || UsersStatus.loading =>
                      const Center(child: CircularProgressIndicator()),
                    UsersStatus.error => _ErrorView(
                        message: state.errorMessage ?? 'Something went wrong',
                        onRetry: context.read<UsersCubit>().loadUsers,
                      ),
                    UsersStatus.success => _UsersList(state: state),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UsersList extends StatelessWidget {
  const _UsersList({required this.state});

  final UsersState state;

  @override
  Widget build(BuildContext context) {
    if (state.filteredUsers.isEmpty) {
      return const Center(child: Text('No users found'));
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      itemCount: state.filteredUsers.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final user = state.filteredUsers[index];
        return _UserTile(
          user: user,
          isFavorite: state.favoriteIds.contains(user.id),
          onFavoritePressed: () =>
              context.read<UsersCubit>().toggleFavorite(user.id),
        );
      },
    );
  }
}

class _UserTile extends StatelessWidget {
  const _UserTile({
    required this.user,
    required this.isFavorite,
    required this.onFavoritePressed,
  });

  final User user;
  final bool isFavorite;
  final VoidCallback onFavoritePressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text(user.name[0])),
        title: Text(user.name),
        subtitle: Text('${user.email}\n${user.company}'),
        isThreeLine: true,
        trailing: IconButton(
          tooltip: isFavorite ? 'Remove favorite' : 'Add favorite',
          onPressed: onFavoritePressed,
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : null,
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}