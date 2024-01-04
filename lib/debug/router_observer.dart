import 'package:flutter/material.dart';

/// [RouterObserver] is a [NavigatorObserver] subclass that stores the history of
/// [Route]s visited by the app.

class RouterObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // print(
    //   '\x1B[32m[Navigator] ${route.settings.name} pushed to stack and previous route was ${previousRoute?.settings.name}\x1B[0m',
    // );
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // print(
    //   '\x1B[32m[Navigator] ${route.settings.name} popped from stack and previous route was ${previousRoute?.settings.name}\x1B[0m',
    // );
    super.didPop(route, previousRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // print(
    //   '\x1B[32m[Navigator] ${route.settings.name} removed from stack and previous route was ${previousRoute?.settings.name}\x1B[0m',
    // );
    super.didRemove(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    // print(
    //   '\x1B[32m[Navigator] ${oldRoute?.settings.name} replaced with ${newRoute?.settings.name}\x1B[0m',
    // );
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didStartUserGesture(
      Route<dynamic> route, Route<dynamic>? previousRoute) {
    // print(
    //   '\x1B[32m[Navigator] User started gesture to ${route.settings.name} and previous route was ${previousRoute?.settings.name}\x1B[0m',
    // );
    super.didStartUserGesture(route, previousRoute);
  }
}
