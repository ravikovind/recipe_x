import 'package:recipe_x/core/routes/routes.dart';
import 'package:recipe_x/debug/router_observer.dart';
import 'package:recipe_x/view/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  AppRouter({
    required this.observer,
  }) {
    _router = GoRouter(
      initialLocation: kHomeRoute,
      observers: [observer],
      routes: [
        GoRoute(
          path: kHomeRoute,
          name: kHomeRoute,
          builder: (context, state) => const HomePage(),
          routes: [
            GoRoute(
              path: kUpdateRoute,
              name: kUpdateRoute,
              builder: (context, state) => Scaffold(
                appBar: AppBar(
                  title: const Text('RecipeX'),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  late final GoRouter _router;
  GoRouter get router => _router;
  final RouterObserver observer;
}
