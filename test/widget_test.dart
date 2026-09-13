// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:test/domain/entities/user.dart';
import 'package:test/domain/repositories/user_repository.dart';
import 'package:test/presentation/cubit/users_cubit.dart';
import 'package:test/presentation/pages/users_page.dart';

class _FakeUserRepository implements UserRepository {
  @override
  Future<Either<String, List<User>>> getUsers() async => const Right([]);
}

void main() {
  testWidgets('renders the users screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) => UsersCubit(_FakeUserRepository())..loadUsers(),
          child: const UsersPage(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Users'), findsOneWidget);
    expect(find.text('Search by name'), findsOneWidget);
  });
}
