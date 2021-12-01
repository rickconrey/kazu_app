import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kazu_app/profile/profile_bloc.dart';
import 'package:kazu_app/profile/profile_event.dart';
import 'package:kazu_app/profile/profile_state.dart';
import 'package:kazu_app/repositories/data_repository.dart';
import 'package:kazu_app/repositories/storage_repository.dart';
import 'package:kazu_app/session_cubit.dart';
import 'package:kazu_app/states/form_submission_status.dart';

class ProfileView extends StatelessWidget {
  final appBarHeight = AppBar().preferredSize.height;

  ProfileView({Key? key, String? userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sessionCubit = context.read<SessionCubit>();
    return BlocProvider(
        create: (context) => ProfileBloc(
          dataRepository: context.read<DataRepository>(),
          storageRepository: context.read<StorageRepository>(),
          user: sessionCubit.selectedUser ?? sessionCubit.currentUser,
          isCurrentUser: sessionCubit.isCurrentUserSelected,
        ),
      child: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state.imageSourceActionSheetIsVisible) {
            _showImageSourceActionSheet(context);
          }

          final formStatus = state.formStatus;
          if (formStatus is SubmissionFailed) {
            _showSnackBar(context, formStatus.exception.toString());
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFFF2F2F7),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(appBarHeight),
            child: _appBar()
          ),
          body: _profilePage(),
        ),
      ),
    );
  }

  Widget _appBar() {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
        return AppBar(
          title: const Text('Profile'),
          actions: [
            if (state.isCurrentUser)
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => context.read<SessionCubit>().signOut(),
              ),
          ],
        );
      });
  }

  Widget _profilePage() {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state)
    {
      return SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 30),
              _avatar(),
              if (state.isCurrentUser) _changeAvatarButton(),
              const SizedBox(height: 30),
              _usernameTile(),
              _emailTile(),
              _descriptionTile(),
              if (state.isCurrentUser) _saveProfileChangesButton(),
            ],
          ),
        ),
      );
    });
  }

  Widget _avatar() {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      return Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue,
          ),
        width: 100,
        height: 100,
        child: state.avatarPath == null
          ? const Icon(
              Icons.person,
              size: 50
            )
            : ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CachedNetworkImage(
                imageUrl: state.avatarPath!,
                fit: BoxFit.cover,
              ),
            ),
        );
    });
  }

  Widget _changeAvatarButton() {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      return TextButton(
        onPressed: () => context.read<ProfileBloc>().add(ChangeAvatarRequest()),
        child: const Text('Change Avatar'),
      );
    });
  }

  Widget _usernameTile() {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      return ListTile(
        tileColor: Colors.white,
        leading: const Icon(Icons.person),
        title: Text(state.username!),
      );
    });
  }

  Widget _emailTile() {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      return ListTile(
        tileColor: Colors.white,
        leading: const Icon(Icons.mail),
        title: Text(state.email ?? ''),
      );
    });
  }

  Widget _descriptionTile() {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      return ListTile(
          tileColor: Colors.white,
          leading: const Icon(Icons.edit),
          title: TextFormField(
            initialValue: state.userDescription,
            decoration: InputDecoration.collapsed(
                hintText: state.isCurrentUser
                    ? 'description'
                    : 'This user hasn\'t updated their profile'),
            maxLines: null,
            readOnly: !state.isCurrentUser,
            toolbarOptions: ToolbarOptions(
              copy: state.isCurrentUser,
              cut: state.isCurrentUser,
              paste: state.isCurrentUser,
              selectAll: state.isCurrentUser,
            ),
            onChanged: (value) => context
                .read<ProfileBloc>()
                .add(ProfileDescriptionChanged(description: value)),
          ),
      );
    });
  }

  Widget _saveProfileChangesButton() {
    return BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      return (state.formStatus is FormSubmitting)
        ? const CircularProgressIndicator() : ElevatedButton(
          onPressed: () => context.read<ProfileBloc>().add(SaveProfileChanges()),
          child: const Text('Save'),
      );
    });
  }

  void _showImageSourceActionSheet(BuildContext context) {
    selectImageSource(imageSource) {
      context
        .read<ProfileBloc>()
          .add(OpenImagePicker(imageSource: imageSource));
    }
    if (Platform.isIOS) {
      showCupertinoModalPopup(
          context: context,
          builder: (context) => CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.pop(context);
                    selectImageSource(ImageSource.camera);
                  },
                  child: const Text('Camera'),
              ),
              CupertinoActionSheetAction(
                child: const Text('Gallery'),
                onPressed: () {
                  Navigator.pop(context);
                  selectImageSource(ImageSource.gallery);
                },
              ),
            ]
          )
      );
    } else {
      showModalBottomSheet(
          context: context,
          builder: (context) => Wrap(children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                selectImageSource(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_album),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                selectImageSource(ImageSource.gallery);
              },
            ),
          ],)
      );
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}