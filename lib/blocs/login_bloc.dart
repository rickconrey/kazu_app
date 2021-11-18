import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kazu_app/cubit/auth_cubit.dart';
import 'package:kazu_app/events/login_event.dart';
import 'package:kazu_app/repositories/auth_repository.dart';
import 'package:kazu_app/states/auth_credentials.dart';
import 'package:kazu_app/states/form_submission_status.dart';
import 'package:kazu_app/states/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;
  final AuthCubit authCubit;

  LoginBloc({required this.authRepository, required this.authCubit}) : super(LoginState());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async*{
    if (event is LoginUsernameChanged) {
      yield state.copyWith(username: event.username);
    } else if (event is LoginPasswordChanged) {
      yield state.copyWith(password: event.password);
    } else if (event is LoginSubmitted) {
      yield state.copyWith(formStatus: FormSubmitting());

      try {
        final userId = await authRepository.login(
            username: state.username,
            password: state.password
        );
        yield state.copyWith(formStatus: SubmissionSuccess());

        authCubit.launchSession(AuthCredentials(
          username: state.username,
          userId: userId,
        ));
      } on Exception catch (e) {
        yield state.copyWith(formStatus: SubmissionFailed(e));
      }
    }
  }
}