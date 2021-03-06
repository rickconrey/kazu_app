import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kazu_app/models/PuffEvent.dart';
import 'package:kazu_app/models/ChargeEvent.dart';
import 'package:kazu_app/models/CartridgeEvent.dart';
import 'package:kazu_app/models/ResetEvent.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:intl/intl.dart';


//Widget buildEventStream(BuildContext context) {
//  //Stream<QuerySnapshot<PuffEvent>> _stream = context.read<DataRepository>().puffEventStream();
//  Stream<QuerySnapshot> _stream = context.read<DataRepository>().getEventsStream();
//  //_stream.listen(print);
//  return StreamBuilder<QuerySnapshot>(
//    stream: _stream,
//    builder: (c, snapshot) {
//      if (!snapshot.hasData) {
//        return const Center(child: CircularProgressIndicator());
//      }
//      print("${snapshot.data!.items.length}");
//      return SizedBox(
//        height: 400,
//        child: ListView(
//          children: snapshot.data!.items.map((item) {
//            if (item is PuffEvent) {
//              return Center(
//                child: buildPuffEventCard(item),
//              );
//            } else if (item is CartridgeEvent) {
//              return Center(
//                child: buildCartridgeEventCard(item),
//              );
//            } else if (item is ChargeEvent) {
//              return Center(
//                child: buildChargeEventCard(item),
//              );
//            } else if (item is ResetEvent) {
//              return Center(
//                child: buildResetEventCard(item),
//              );
//            }
//
//            return const Center(
//              child: Text("Invalid Event"),
//            );
//          }).toList(),
//        ),
//      );
//    },
//  );
//}

Widget buildEventCard(dynamic event) {
  if (event is PuffEvent) {
    return Center(
      child: buildPuffEventCard(event),
    );
  } else if (event is CartridgeEvent) {
    return Center(
      child: buildCartridgeEventCard(event),
    );
  } else if (event is ChargeEvent) {
    return Center(
      child: buildChargeEventCard(event),
    );
  } else if (event is ResetEvent) {
    return Center(
      child: buildResetEventCard(event),
    );
  }

  return const Center(
    child: Text("Invalid Event"),
  );
}

Widget buildPuffEventCard(PuffEvent event) {
  var dateTime = DateTime.fromMillisecondsSinceEpoch(event.time!.toSeconds() * 1000);
  var dateString = DateFormat.yMMMEd().add_jms().format(dateTime);
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
    child: ListTile(
      leading: const Icon(
        //Icons.whatshot,
        MdiIcons.smoke,
        color: Colors.deepPurple,
      ),
      //leading: const Icon(Icons.bolt),
      title: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Puff Event"),
            Text("$dateString"),
          ]
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Dose Number: ${event.doseNumber}"),
          Text("Duration: ${event.duration}"),
          Text("Amount: ${event.amount}"),
        ],
      ),
    ),
  );
}
Widget buildCartridgeEventCard(CartridgeEvent event) {
  var dateTime = DateTime.fromMillisecondsSinceEpoch(event.time!.toSeconds() * 1000);
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
    child: ListTile(
      leading: event.attached!
        ? const Icon(
          MdiIcons.water,
          color: Colors.green,
        )
        : const Icon(
          MdiIcons.waterOffOutline,
          color: Colors.grey,
        ),
  //leading: const Icon(Icons.bolt),
      title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Cartridge Event"),
            Text("$dateTime"),
          ]
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Dose Number: ${event.doseNumber}"),
          //Text("Duration: ${event.duration}"),
          //const Text("Amount: "),
        ],
      ),
    ),
  );
}
Widget buildChargeEventCard(ChargeEvent event) {
  var dateTime = DateTime.fromMillisecondsSinceEpoch(event.time!.toSeconds() * 1000);
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
    child: ListTile(
      leading: event.charging!
        ? const Icon(
          Icons.usb,
          color: Colors.blue
        )
        : const Icon(
            Icons.usb_off,
            color: Colors.grey
        ),
      title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Charge Event"),
            Text("$dateTime"),
          ]
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Battery: ${event.adcVbat}"),
        ],
      ),
    ),
  );
}
Widget buildResetEventCard(ResetEvent event) {
  var dateTime = DateTime.fromMillisecondsSinceEpoch(event.time!.toSeconds() * 1000);
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
    child: ListTile(
      leading: const Icon(
        Icons.restart_alt,
        color: Colors.orange,
      ),
      //leading: const Icon(Icons.bolt),
      title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Reset Event"),
            Text("$dateTime"),
          ]
      ),
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("Reason: ${event.reason}"),
        ],
      ),
    ),
  );
}