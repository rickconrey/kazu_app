import 'package:kazu_app/events/chart_event.dart';
import 'package:kazu_app/repositories/data_repository.dart';
import 'package:kazu_app/states/feed_state.dart';
import 'package:kazu_app/models/PuffEvent.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kazu_app/events/feed_event.dart';
import 'package:amplify_datastore_plugin_interface/amplify_datastore_plugin_interface.dart';

import '../image_cache.dart';
import '../models/User.dart';
import 'chart_bloc.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final DataRepository dataRepository;
  final User user;
  ChartBloc? chartBloc;

  FeedBloc({required this.dataRepository, required this.user}) : super(FeedState()) {
    if (state.feedEvents == null && state.userEvents == null) {
      add(FeedEmpty());
    }
  }

  @override
  Stream<FeedState> mapEventToState(FeedEvent event) async*{
    if (event is FeedEmpty) {
      Stream<QuerySnapshot> _userStream = dataRepository.getUserEventsStream(user.id);
      Stream<QuerySnapshot> _feedStream = dataRepository.getFeedEventsStream(user.id);

      _userStream.listen((e) {
        add(FeedUpdateUser(event: e));
      });

      _feedStream.listen((e) {
        add(FeedUpdateFeed(event: e));
      });

    } else if (event is FeedUpdateUser) {
      List<Model> userEvents = state.userEvents ?? [];
      for (dynamic e in event.event!.items) {
        bool test = false;
        for (dynamic item in userEvents) {
          if (e.id == item.id) {
            test = true;
            break;
          }
        }
        if (test == false) {
          userEvents.add(e);
          if (e is PuffEvent) {
            chartBloc?.add(ChartUpdateData(event: e));
          }
        }
        //if ((userEvents.singleWhere((item) => item.id == e.id,
        //orElse: () => null,
        //)))//if (userEvents.contains(e) == false) {
        //    userEvents.add(e);
        //  }
        //}
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
        if(feedEvents.contains(e) == false) {
          feedEvents.add(e);
        }
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