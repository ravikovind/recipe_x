import 'package:flutter_bloc/flutter_bloc.dart';

/// [ApplicationBlocObserver] is used to observe the state changes in the blocs
/// and cubits.

class ApplicationBlocObserver extends BlocObserver {
  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
  }

  // @override
  // void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
  //   super.onEvent(bloc, event);
  //   // print('\x1B[32m$bloc is emitting $event\x1B[0m');
  // }

  // @override
  // void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
  //   super.onChange(bloc, change);
  //   // print('\x1B[33m$bloc has changed to $change\x1B[0m');
  // }
}
