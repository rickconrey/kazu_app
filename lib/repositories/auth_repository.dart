import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/cupertino.dart';

class AuthRepository {
  Future<String> _getUserIdFromAttributes() async {
    try {
      final attributes = await Amplify.Auth.fetchUserAttributes();
      final userId = attributes
          .firstWhere((element) => element.userAttributeKey == 'sub')
          .value;
      return userId;
    } catch (e) {
      rethrow;
    }
  }
  Future<String?> attemptAutoLogin() async {
    try {
      final session = await Amplify.Auth.fetchAuthSession();
      return session.isSignedIn ? (await _getUserIdFromAttributes()) : null;
    } catch (e) {
      rethrow;
    }
    //await Future.delayed(const Duration(seconds: 1));
    //throw Exception('not signed in');
  }

  Future<String> login({required String username, required String password}) async {
    try {
      final result = await Amplify.Auth.signIn(
        username: username.trim(),
        password: password.trim(),
      );
      return result.isSignedIn ? (await _getUserIdFromAttributes()) : '';
    } catch (e) {
      rethrow;
    }
    //print('attempting login');
    //await Future.delayed(const Duration(seconds: 3));
    //return 'abc';
  }

  Future<bool> signUp({required String username, required String email, required String password}) async {
    final options = CognitoSignUpOptions(userAttributes: {'email': email.trim()});
    try {
      final result = await Amplify.Auth.signUp(
        username: username.trim(),
        password: password.trim(),
        options: options,
      );
      return result.isSignUpComplete;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> confirmSignUp({required String username, required String confirmationCode}) async {
    try {
      final result = await Amplify.Auth.confirmSignUp(
          username: username.trim(),
          confirmationCode: confirmationCode.trim()
      );
      return result.isSignUpComplete;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await Amplify.Auth.signOut();
  }

}