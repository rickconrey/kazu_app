import 'package:amplify_datastore/amplify_datastore.dart';

import '../models/User.dart';

abstract class FeedEvent {}

class FeedEmpty extends FeedEvent {}

class FeedUpdateFeed extends FeedEvent {
  final QuerySnapshot? event;

  FeedUpdateFeed({this.event});
}

class FeedUpdateUser extends FeedEvent {
  final QuerySnapshot? event;

  FeedUpdateUser({this.event});
}

class FeedUpdateUserList extends FeedEvent {
  final User user;

  FeedUpdateUserList({required this.user});
}