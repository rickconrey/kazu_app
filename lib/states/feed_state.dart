import 'package:amplify_datastore_plugin_interface/amplify_datastore_plugin_interface.dart';
import '../models/User.dart';

class FeedState {
  List<Model>? userEvents = [];
  List<Model>? feedEvents = [];
  Map<String, User>? users = {};
  Map<String, String>? userAvatarPaths = {};

  FeedState({this.userEvents, this.feedEvents, this.users, this.userAvatarPaths});

  FeedState copyWith({
    List<Model>? userEvents,
    List<Model>? feedEvents,
    Map<String, User>? users,
    Map<String, String>? userAvatarPaths,
  }) {
    return FeedState(
      userEvents: userEvents ?? this.userEvents,
      feedEvents: feedEvents ?? this.feedEvents,
      users: users ?? this.users,
      userAvatarPaths: userAvatarPaths ?? this.userAvatarPaths,
    );
  }
}