import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kazu_app/cubit/auth_cubit.dart';
import 'package:kazu_app/events/confirmation_event.dart';
import 'package:kazu_app/repositories/auth_repository.dart';
import 'package:kazu_app/states/confirmation_state.dart';
import 'package:kazu_app/states/form_submission_status.dart';


class ConfirmationBloc extends Bloc<ConfirmationEvent, ConfirmationState> {
  final AuthRepository authRepository;
  final AuthCubit authCubit;

  ConfirmationBloc({
    required this.authRepository,
    required this.authCubit,
  }) : super(ConfirmationState());

  @override
  Stream<ConfirmationState> mapEventToState(ConfirmationEvent event) async*{
    if (event is ConfirmationCodeChanged) {
      yield state.copyWith(code: event.code);
    } else if (event is ConfirmationSubmitted) {
      yield state.copyWith(formStatus: FormSubmitting());

      try {
        final userId = await authRepository.confirmSignUp(
            username: authCubit.credentials.username,
            confirmationCode: state.code
        );
        yield state.copyWith(formStatus: SubmissionSuccess());

        final credentials = authCubit.credentials;
        credentials.userId = userId;

        authCubit.launchSession(credentials);
      } on Exception catch (e) {
        yield state.copyWith(formStatus: SubmissionFailed(e));
      }
    }
  }
}