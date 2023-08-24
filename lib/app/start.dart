import 'dart:async';

import 'package:recipe_x/debug/application_bloc_observer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

/// [startApplication] is the entry point of the application.
/// It is called from the main function.
/// It is responsible for starting the application and binding the application
/// to the device.
/// it accepts builder function as a parameter which returns the root widget
/// of the application.

Future<void> startApplication(FutureOr<Widget> Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    /// user bloc observer to observe the state changes in the blocs and cubits
    Bloc.observer = ApplicationBlocObserver();

    /// initialize the application HydratedBloc storage
    final storage = await HydratedStorage.build(
      storageDirectory: kIsWeb
          ? HydratedStorage.webStorageDirectory
          : await getTemporaryDirectory(),
    );

    /// use the storage to initialize the HydratedBloc delegate
    HydratedBloc.storage = storage;
  } catch (_) {}
  final app = await builder();
  runApp(app);
}
