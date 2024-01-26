import 'package:recipe_x/core/routes/routes.dart';
import 'package:recipe_x/debug/router_observer.dart';
import 'package:recipe_x/view/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_x/view/pages/home/recipe.dart';
import 'package:recipe_x/view/pages/filter/filter.dart';

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
            /// search route
            GoRoute(
              path: kFilterRoute,
              name: kFilterRoute,
              builder: (context, state) => const FilterPage(),
            ),
            GoRoute(
              path: '$kRecipeRoute/:recipe',
              name: kRecipeRoute,
              redirect: (context, state) {
                final recipe = state.pathParameters['recipe']?.toString();
                if (recipe == null || recipe.isEmpty) {
                  return kHomeRoute;
                }
                return null;
              },
              builder: (context, state) {
                final recipe = state.pathParameters['recipe']?.toString();
                if (recipe == null || recipe.isEmpty) {
                  return state.noMatch;
                }
                return RecipePage(
                  recipe: recipe,
                );
              },
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

extension OfGoRouterState on GoRouterState {
  Widget get noMatch => Scaffold(
        appBar: AppBar(
          title: const Text('No Found'),
        ),
        body: const Center(
          child: Text('Buddy, Are you lost?'),
        ),
      );
}
