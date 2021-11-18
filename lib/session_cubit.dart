import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kazu_app/repositories/auth_repository.dart';
import 'package:kazu_app/session_state.dart';
import 'package:kazu_app/states/auth_credentials.dart';

class SessionCubit extends Cubit<SessionState> {
  final AuthRepository authRepository;
  //final DataRepository dataRepository;

  SessionCubit({required this.authRepository}) : super(UnknownSessionState()) {
    attemptAutoLogin();
  }

  void attemptAutoLogin() async {
    try {
      final userId = await authRepository.attemptAutoLogin();
      // final user = dataRepo.getUser(userId);
      final user = userId;
      emit(Authenticated(user: user));
    } on Exception {
      emit(Unauthenticated());
    }
  }
  void showAuth() => emit(Unauthenticated());

  void showSession(AuthCredentials credentials) {
    //final user = dataRepository.getUser(credentials.userId);
    final user = credentials.username;
    emit(Authenticated(user: user));
  }

  void signOut() {
    authRepository.signOut();
    emit(Unauthenticated());
  }
}