//import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kazu_app/repositories/auth_repository.dart';
import 'package:kazu_app/repositories/data_repository.dart';
import 'package:kazu_app/session_state.dart';
import 'package:kazu_app/states/auth_credentials.dart';

import 'models/User.dart';

class SessionCubit extends Cubit<SessionState> {
  final AuthRepository authRepository;
  final DataRepository dataRepository;

  User get currentUser => (state as Authenticated).user;
  User? get selectedUser => (state as Authenticated).selectedUser;
  bool get isCurrentUserSelected =>
      selectedUser == null || currentUser.id == selectedUser?.id;

  SessionCubit({required this.authRepository, required this.dataRepository}) : super(UnknownSessionState()) {
    attemptAutoLogin();
  }

  void attemptAutoLogin() async {
    try {
      final userId = await authRepository.attemptAutoLogin();

      if (userId == null) {
        throw Exception('User not logged in');
      }

      User user = await dataRepository.getUserById(userId) ??
                  await dataRepository.createUser(
                    userId: userId,
                    username: 'User-${UUID()}',
      );

      emit(Authenticated(user: user));
    } on Exception {
      emit(Unauthenticated());
    }
  }
  void showAuth() => emit(Unauthenticated());

  void selectUser(String? userId) async {
    if (userId == null) {
      emit(Authenticated(user: currentUser));
      return;
    }
    User? _selectedUser = await dataRepository.getUserById(userId);
    emit(Authenticated(user: currentUser, selectedUser: _selectedUser));
  }

  void showSession(AuthCredentials credentials) async {
    try {
      User user = await dataRepository.getUserById(credentials.userId!) ??
                  await dataRepository.createUser(
                    userId: credentials.userId!,
                    username: credentials.username,
                    email: credentials.email,
      );
      emit(Authenticated(user: user));
    } catch (e) {
      rethrow;
    }
  }

  void signOut() {
    authRepository.signOut();
    emit(Unauthenticated());
  }
}