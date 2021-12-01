import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kazu_app/session_cubit.dart';

class SessionView extends StatelessWidget {
  final String? username;

  const SessionView({Key? key, this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hello, $username'),
            TextButton(
              child: const Text('sign out'),
              onPressed: () => BlocProvider.of<SessionCubit>(context).signOut(),
            ),
          ],
        ),
      ),
    );
  }
}