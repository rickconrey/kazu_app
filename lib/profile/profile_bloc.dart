import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kazu_app/image_cache.dart';
import 'package:kazu_app/models/User.dart';
import 'package:kazu_app/profile/profile_event.dart';
import 'package:kazu_app/profile/profile_state.dart';
import 'package:kazu_app/repositories/data_repository.dart';
import 'package:kazu_app/repositories/storage_repository.dart';
import 'package:kazu_app/states/form_submission_status.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final StorageRepository storageRepository;
  final DataRepository dataRepository;
  final _picker = ImagePicker();

  ProfileBloc({required this.storageRepository, required this.dataRepository, required User user, required bool isCurrentUser})
      : super(ProfileState(user: user, isCurrentUser: isCurrentUser)) {
    if (user.avatarKey != null) {
      ImageUrlCache.instance
          .getUrl(user.avatarKey!)
          .then((url) => add(ProvideImagePath(avatarPath: url)));
    }
  }

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is ChangeAvatarRequest) {
      yield state.copyWith(imageSourceActionSheetIsVisible: true);
    } else if (event is OpenImagePicker) {
      yield state.copyWith(imageSourceActionSheetIsVisible: false);
      final pickedImage = await _picker.pickImage(source: event.imageSource);
      if (pickedImage == null) return;

      final imageKey = await storageRepository.uploadFile(File(pickedImage.path));
      final updatedUser = state.user.copyWith(avatarKey: imageKey);

      final results = await Future.wait([
        dataRepository.updateUser(updatedUser),
        storageRepository.getUrlForFile(imageKey),
      ]);

      yield state.copyWith(user: updatedUser, avatarPath: results.last.toString());
    } else if (event is ProvideImagePath) {
      yield state.copyWith(avatarPath: event.avatarPath);
    } else if (event is ProfileDescriptionChanged) {
      yield state.copyWith(userDescription: event.description);
    } else if (event is SaveProfileChanges) {
      yield state.copyWith(formStatus: FormSubmitting());

      final updatedUser = state.user.copyWith(description: state.userDescription);

      try {
        await dataRepository.updateUser(updatedUser);
        yield state.copyWith(user: updatedUser, formStatus: SubmissionSuccess(), userDescription: updatedUser.description);
      } on Exception catch (e) {
        yield state.copyWith(formStatus: SubmissionFailed(e));
      }

    }
  }
}