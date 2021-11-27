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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Placeholder(
            fallbackHeight: 500,
          ),
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
          height: 400,
          child: ListView(
          children: snapshot.data!.items.map((item) {
            return Center(
              child: _buildEventCard(item),
            );
          }).toList(),
        ),
        );
      },
    );
  }

  Widget _buildEventCard(PuffEvent event) {
    var dateTime = DateTime.fromMillisecondsSinceEpoch(event.time!.toSeconds() * 1000);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
      child: ListTile(
        leading: const Icon(Icons.whatshot),
        //leading: const Icon(Icons.bolt),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Puff Event"),
            Text("$dateTime"),
          ]
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Dose Number: ${event.doseNumber}"),
            Text("Duration: ${event.duration}"),
            const Text("Amount: "),
          ],
        ),
      ),
    );
  }

  //Widget _buildPuffEventCard(PuffEvent event) {
  //
  //}
}