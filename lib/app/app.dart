import 'package:recipe_x/bloc/country/country_bloc.dart';
import 'package:recipe_x/bloc/recipe/recipe_bloc.dart';
import 'package:recipe_x/bloc/region/region_bloc.dart';
import 'package:recipe_x/bloc/theme/theme_bloc.dart';
import 'package:recipe_x/core/routes/app_router.dart';
import 'package:recipe_x/core/utils/color_scheme.dart';
import 'package:recipe_x/data/services/service.dart';
import 'package:recipe_x/debug/router_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class Application extends StatelessWidget {
  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        /// ThemeBloc
        BlocProvider<ThemeBloc>(
          create: (BuildContext context) => ThemeBloc(),
        ),

        /// CountryBloc
        BlocProvider<CountryBloc>(
          create: (BuildContext context) => CountryBloc(
            service: Service(),
          )..add(
              const LoadCountries(),
            ),
        ),

        /// RegionBloc
        BlocProvider<RegionBloc>(
          create: (BuildContext context) => RegionBloc(
            service: Service(),
          )..add(
              const LoadRegions(),
            ),
        ),

        /// RecipeBloc
        BlocProvider<RecipeBloc>(
          create: (BuildContext context) => RecipeBloc(service: Service())
            ..add(
              const LoadRecipes(),
            ),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeMode>(
        builder: (context, mode) {
          return MaterialApp.router(
            title: 'RecipeX',
            debugShowCheckedModeBanner: false,
            themeMode: mode,
            theme: ThemeData(
              colorScheme: lightColorScheme,
              useMaterial3: true,
              textTheme: GoogleFonts.urbanistTextTheme(
                Theme.of(context).textTheme,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            darkTheme: ThemeData.dark().copyWith(
              colorScheme: darkColorScheme,
              useMaterial3: true,
              textTheme: GoogleFonts.urbanistTextTheme(
                Theme.of(context).textTheme,
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            routerConfig: AppRouter(
              observer: RouterObserver(),
            ).router,
          );
        },
      ),
    );
  }
}
