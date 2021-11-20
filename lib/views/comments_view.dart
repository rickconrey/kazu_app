import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommentsView extends StatelessWidget {
  final _dummyAvatar =
      'https://getwiti.com/wp-content/uploads/2019/07/witi_logo.png';
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: _commentsListView(),
    );
  }

  Widget _commentView() {
    const double avatarDiameter = 44;
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            width: avatarDiameter,
            height: avatarDiameter,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(avatarDiameter / 2),
              child: CachedNetworkImage(
                imageUrl: _dummyAvatar,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const Flexible(
          child: Text(
            'This is a very witi comment.',
            maxLines: 5,
          ),
        ),
      ],
    );

  }

  Widget _commentsListView() {
    return ListView.builder(
      itemCount: 20,
      itemBuilder: (context, index) {
        return _commentView();
      }
    );
  }
}