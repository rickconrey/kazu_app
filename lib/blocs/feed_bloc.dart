import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:kazu_app/repositories/data_repository.dart';
import 'package:kazu_app/states/feed_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kazu_app/events/feed_event.dart';
import 'package:amplify_datastore_plugin_interface/amplify_datastore_plugin_interface.dart';
import 'package:kazu_app/models/PuffEvent.dart';

import '../image_cache.dart';
import '../models/User.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final DataRepository dataRepository;

  FeedBloc({required this.dataRepository}) : super(FeedState()) {
    if (state.feedEvents == null && state.userEvents == null) {
      add(FeedEmpty());
    }
  }

  @override
  Stream<FeedState> mapEventToState(FeedEvent event) async*{
    if (event is FeedEmpty) {
      Stream<QuerySnapshot> _stream = dataRepository.getEventsStream();

      _stream.listen((e) {
        add(FeedUpdateUser(event: e));
        add(FeedUpdateFeed(event: e));
      });

    } else if (event is FeedUpdateUser) {
      List<Model> userEvents = state.userEvents ?? [];
      for (Model e in event.event!.items) {
        userEvents.add(e);
      }
      userEvents.sort((a, b) {
        dynamic event1 = a;
        dynamic event2 = b;
        return -event1.time!.compareTo(event2.time!);
      });
      yield state.copyWith(userEvents: userEvents);
    } else if (event is FeedUpdateFeed) {
      List<Model> feedEvents = state.feedEvents ?? [];
      Map<String, User> users = state.users ?? {};
      Map<String, String> userAvatarPaths = state.userAvatarPaths ?? {};

      for (dynamic e in event.event!.items) {
        feedEvents.add(e);
        if (users.containsKey(e.userId) == false) {
          User? user = await dataRepository.getUserById(e.userId!);
          if (user != null) {
            users[user.id] = user;
            if (user.avatarKey != null && userAvatarPaths.containsKey(user.id) == false) {
              ImageUrlCache.instance
                  .getUrl(user.avatarKey!)
                  .then((url) => userAvatarPaths[user.id] = url);
            }
          }
        }
      }
      yield state.copyWith(users: users);
      yield state.copyWith(userAvatarPaths: userAvatarPaths);
      feedEvents.sort((a, b) {
        dynamic event1 = a;
        dynamic event2 = b;
        return -event1.time!.compareTo(event2.time!);
      });
      yield state.copyWith(feedEvents: feedEvents);
    } else if (event is FeedUpdateUserList) {
      Map<String, User> users = state.users ?? {};

      if (users.containsKey(event.user.id) == false) {
        users[event.user.id] = event.user;
        yield state.copyWith(users: users);
      }

    }
  }
}