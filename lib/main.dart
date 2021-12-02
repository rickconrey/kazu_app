import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_datastore/amplify_datastore.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kazu_app/amplifyconfiguration.dart';
import 'package:kazu_app/models/ModelProvider.dart';
import 'package:kazu_app/profile/profile_bloc.dart';
import 'package:kazu_app/repositories/auth_repository.dart';
import 'package:kazu_app/repositories/ble_repository.dart';
import 'package:kazu_app/repositories/data_repository.dart';
import 'package:kazu_app/repositories/storage_repository.dart';
import 'package:kazu_app/session_cubit.dart';
import 'package:kazu_app/simple_bloc_observer.dart';

import 'package:permission_handler/permission_handler.dart';

import 'app_navigator.dart';
import 'blocs/ble_bloc.dart';
import 'loading_view.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  //BlocOverrides.runZoned(() => runApp(KazuApp()), blocObserver: observer);
  runApp(const KazuApp());
  //runApp(const MyApp());
}

class KazuApp extends StatefulWidget {
  const KazuApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<KazuApp> {
  bool _isAmplifyConfigured = false;
  bool _isPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _configureAmplify();
    _permissions();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kazu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: _isAmplifyConfigured
          ? MultiRepositoryProvider(
              providers: [
                RepositoryProvider(create: (context) => AuthRepository()),
                RepositoryProvider(create: (context) => DataRepository()),
                RepositoryProvider(create: (context) => StorageRepository()),
                RepositoryProvider(create: (context) => BleRepository()),
              ],
              child: MultiBlocProvider(providers: [
                  BlocProvider(
                    create: (context) => SessionCubit(
                      authRepository: context.read<AuthRepository>(),
                      dataRepository: context.read<DataRepository>(),
                    ),
                  ),
                  BlocProvider(
                    create: (context) => ProfileBloc(
                      storageRepository: context.read<StorageRepository>(),
                      dataRepository: context.read<DataRepository>(),
                      user: context.read<User>(),
                      isCurrentUser: false,
                    ),
                  ),
                  BlocProvider(
                      create: (context) => BleBloc(
                        bleRepository: context.read<BleRepository>(),
                        dataRepository: context.read<DataRepository>(),
                      ),
                  ),
                ],
                child: AppNavigator(),
              ),
            )
          : LoadingView()
    );//const MyHomePage(title: 'Flutter Demo Home Page'),
  }

  Future<void> _configureAmplify() async {
    try {
      print ('Configuring amplify...');
      await Amplify.addPlugins([
        AmplifyAuthCognito(),
        AmplifyDataStore(modelProvider: ModelProvider.instance),
        AmplifyAPI(),
        AmplifyStorageS3(),
        //AmplifyAnalyticsPinpoint(),
      ]);

      await Amplify.configure(amplifyconfig);

      setState(() => _isAmplifyConfigured = true);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _permissions() async {
    try {
      if (await Permission.bluetoothScan.request().isGranted) {
        setState(() => _isPermissionGranted = true);
      }

    } catch (e) {
      print (e);
    }
  }
}