import 'package:recipe_x/bloc/category/category_bloc.dart';
import 'package:recipe_x/bloc/country/country_bloc.dart';
import 'package:recipe_x/bloc/ingredient/ingredient_bloc.dart';
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

        /// CategoryBloc
        BlocProvider<CategoryBloc>(
          create: (BuildContext context) => CategoryBloc(
            service: Service(),
          )..add(
              const LoadCategories(),
            ),
        ),

        /// IngredientBloc
        BlocProvider<IngredientBloc>(
          create: (BuildContext context) => IngredientBloc(
            service: Service(),
          )..add(
              const LoadIngredients(),
            ),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeMode>(
        builder: (context, mode) {
          return MaterialApp.router(
            title: 'RecipeX',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              colorScheme: lightColorScheme,
              brightness: Brightness.light,
              useMaterial3: true,
              textTheme: GoogleFonts.nunitoSansTextTheme(
                Theme.of(context).textTheme,
              ),
              appBarTheme: AppBarTheme(
                titleTextStyle: GoogleFonts.nunitoSansTextTheme(
                  Theme.of(context).textTheme,
                ).titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: lightColorScheme.primary,
                    ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: lightColorScheme.onPrimaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  minimumSize: const Size(double.infinity, 64.0),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              colorScheme: darkColorScheme,
              useMaterial3: true,
              textTheme: GoogleFonts.nunitoSansTextTheme(
                Theme.of(context).textTheme.apply(
                      bodyColor: darkColorScheme.onSurface,
                      displayColor: darkColorScheme.onSurface,
                      decorationColor: darkColorScheme.onSurface,
                    ),
              ),
              appBarTheme: AppBarTheme(
                titleTextStyle: GoogleFonts.nunitoSansTextTheme(
                  Theme.of(context).textTheme.apply(
                        bodyColor: darkColorScheme.onSurface,
                        displayColor: darkColorScheme.onSurface,
                        decorationColor: darkColorScheme.onSurface,
                      ),
                ).titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: darkColorScheme.primary,
                      wordSpacing: 2.4,
                      letterSpacing: 2.4,
                    ),
              ),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  minimumSize: const Size(double.infinity, 64.0),
                  backgroundColor: darkColorScheme.onPrimaryContainer,
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
            ),
            themeMode: mode,
            routerConfig: AppRouter(
              observer: RouterObserver(),
            ).router,
          );
        },
      ),
    );
  }
}
