import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/device_bloc.dart';
import '../states/device_state.dart';

class DeviceView extends StatelessWidget {

  DeviceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (context) => DeviceBloc(),
      child: BlocListener<DeviceBloc, DeviceState>(
        listener: (context, state) {

        },
        child: Scaffold(

        ),
      ),
    );
  }
}