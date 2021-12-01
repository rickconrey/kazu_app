import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kazu_app/blocs/feed_bloc.dart';
import 'package:kazu_app/cubit/feed_navigator_cubit.dart';
import 'package:kazu_app/states/feed_state.dart';
import 'package:kazu_app/widgets/event_widgets.dart';

import '../image_cache.dart';
import '../session_cubit.dart';

class FeedView extends StatelessWidget {
  final _dummyAvatar =
      'https://getwiti.com/wp-content/uploads/2019/07/witi_logo.png';
  final _dummyImage =
      'https://getwiti.com/wp-content/uploads/2019/07/witi_logo.png';
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeedBloc, FeedState>(builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Kazu'),
        ),
        body: _postsListView(),
      );
    });
  }

  Widget _postAuthorRow(dynamic event) {
    const double avatarDiameter = 44;
    return BlocBuilder<FeedBloc, FeedState>(builder: (context, state) {
      String? userId = event.userId;
      String username = state.users?[userId]?.username ?? "Username";
      String _avatarPath = state.userAvatarPaths?[userId] ?? _dummyAvatar;

      return GestureDetector(
        onTap: () {
          context.read<SessionCubit>().selectUser(userId);
          BlocProvider.of<FeedNavigatorCubit>(context).showProfile();
          },
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Container(
                width: avatarDiameter,
                height: avatarDiameter,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(avatarDiameter / 2),
                  child: CachedNetworkImage(
                      imageUrl: _avatarPath,
                      fit: BoxFit.cover
                  ),
                ),
              ),
            ),
            Text(
              username,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _postImage() {
    return AspectRatio(
      aspectRatio: 1,
      child: CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: _dummyImage,
      )
    );
  }

  Widget _postCaption() {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      child: Text(
        'Welcome to Kazu, please vape responsibly.'),
      );
  }

  Widget _postView(dynamic event) {
    return BlocBuilder<FeedBloc, FeedState>(builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _postAuthorRow(event),
          buildEventCard(event),
          //_postCaption(),
          //_postCommentsButton(context),
        ],
      );
    });
  }

  Widget _postCommentsButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: () => BlocProvider.of<FeedNavigatorCubit>(context).showComments(),
        child: const Text(
          'View Comments',
          style: TextStyle(fontWeight: FontWeight.w200),
        )
      )
    );
  }

  Widget _postsListView() {
    return BlocBuilder<FeedBloc, FeedState>(builder: (context, state) {
      return ListView(
        children: state.feedEvents != null
          ? state.feedEvents!.map((item) {
            return _postView(item);
          //if(item is PuffEvent){
          //  return buildPuffEventCard(item);
          //} else if (item is ChargeEvent) {
          //  return buildChargeEventCard(item);
          //} else if (item is CartridgeEvent) {
          //  return buildCartridgeEventCard(item);
          //} else if (item is ResetEvent) {
          //  return buildResetEventCard(item);
          //}
          //  return const Text("Invalid Event");
            }).toList()
        : []
      );

    });
    //Stream<QuerySnapshot<PuffEvent>> _stream = context.read<DataRepository>()
    //    .puffEventStream();

    //return StreamBuilder<QuerySnapshot<PuffEvent>>(
    //  stream: _stream,
    //  builder: (c, snapshot) {
    //    if (!snapshot.hasData) {
    //      return const Center(child: CircularProgressIndicator());
    //    }
    //    return ListView(
    //        children: snapshot.data!.items.map((item) {
    //          return _postView(context, item);
    //        }).toList()
    //    );
    //  }
    //);
  }
        //print("${snapshot.data!.items.length}");
        //return SizedBox(
        //  height: 400,
        //  child: ListView(
        //    children: snapshot.data!.items.map((item) {
        //      if (item is PuffEvent) {
        //        return Center(
        //          child: buildPuffEventCard(item),
        //        );
        //      } else if (item is CartridgeEvent) {
        //        return Center(
        //          child: buildCartridgeEventCard(item),
        //        );
        //      } else if (item is ChargeEvent) {
        //        return Center(
        //          child: buildChargeEventCard(item),
        //        );
        //      } else if (item is ResetEvent) {
        //        return Center(
        //          child: buildResetEventCard(item),
        //        );
        //      }

        //      return const Center(
        //        child: Text("Invalid Event"),
        //      );
        //    }).toList(),
        //  ),
        //);
      //});

    //return ListView.builder(
    //  itemCount: 3,
    //  itemBuilder: (context, index) {
    //    return _postView(context);
    //  }
    //);
  }