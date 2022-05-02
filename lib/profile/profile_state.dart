import 'package:kazu_app/models/User.dart';
import 'package:kazu_app/states/form_submission_status.dart';

class ProfileState {
  final User user;
  final bool isCurrentUser;
  final String? avatarPath;
  final String? userDescription;
  final User selectedUser;

  String? get username => user.username;
  String? get email => user.email;

  final FormSubmissionStatus formStatus;
  bool imageSourceActionSheetIsVisible;

  ProfileState({
    required User user,
    required bool isCurrentUser,
    String? avatarPath,
    String? userDescription,
    this.formStatus = const InitialFormStatus(),
    imageSourceActionSheetIsVisible = false,
    User? selectedUser,
  }) : this.user = user,
        this.isCurrentUser = isCurrentUser,
        this.avatarPath = avatarPath,
        this.userDescription = userDescription ?? user.description,
        this.imageSourceActionSheetIsVisible = imageSourceActionSheetIsVisible,
        this.selectedUser = selectedUser ?? user;

  ProfileState copyWith({
    User? user,
    String? avatarPath,
    String? userDescription,
    FormSubmissionStatus? formStatus,
    bool? imageSourceActionSheetIsVisible,
    User? selectedUser
  }) {
    return ProfileState(
      user: user ?? this.user,
      isCurrentUser: isCurrentUser,
      avatarPath: avatarPath ?? this.avatarPath,
      userDescription: userDescription ?? this.userDescription,
      formStatus: formStatus ?? this.formStatus,
      imageSourceActionSheetIsVisible: imageSourceActionSheetIsVisible ??
        this.imageSourceActionSheetIsVisible,
      selectedUser: selectedUser ?? this.selectedUser,
    );
  }

}