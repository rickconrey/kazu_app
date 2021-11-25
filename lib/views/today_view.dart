import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kazu_app/cubit/home_navigator_cubit.dart';
import 'package:kazu_app/models/PuffEvent.dart';
import 'package:kazu_app/repositories/data_repository.dart';

class TodayView extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kazu"),
        leading: IconButton(
          onPressed: () => BlocProvider.of<HomeNavigatorCubit>(context).showProfile(),
          icon: const Icon(Icons.person),
        ),
      ),
      body: Column(
        children: [
          _buildEventStream(context),
          _deviceButton(context),
        ],
      ),
    );
  }

  Widget _deviceButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => BlocProvider.of<HomeNavigatorCubit>(context).showDevice(),
      child: const Text('Add Device'),
    );
  }

  Widget _buildEventStream(BuildContext context) {
    Stream<QuerySnapshot<PuffEvent>> _stream = context.read<DataRepository>().puffEventStream();
    return StreamBuilder<QuerySnapshot<PuffEvent>>(
      stream: _stream,
      builder: (c, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        print("${snapshot.data!.items.length}");
        return SizedBox(
          height: 200,
          child: ListView(
          children: snapshot.data!.items.map((item) {
            return Center(
              child: Container(
                child: Text("${item.duration}"),
              ),
            );
          }).toList(),
        ),
        );
      },
    );
  }

  Widget _buildEventsList() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return _eventsView(context);
      }
    );
  }

  Widget _eventsView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Event"),
      ],
    );
  }

}