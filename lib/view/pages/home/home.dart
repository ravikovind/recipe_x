// import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
// import 'package:recipe_x/bloc/category/category_bloc.dart';
// import 'package:recipe_x/bloc/country/country_bloc.dart';
import 'package:recipe_x/bloc/ingredient/ingredient_bloc.dart';
import 'package:recipe_x/bloc/recipe/recipe_bloc.dart';
import 'package:recipe_x/bloc/region/region_bloc.dart';
import 'package:recipe_x/bloc/theme/theme_bloc.dart';
import 'package:recipe_x/core/routes/routes.dart';
import 'package:recipe_x/core/utils/extenstions.dart';
import 'package:recipe_x/core/utils/responsive.dart';
// import 'package:recipe_x/data/entities/category.dart';
import 'package:recipe_x/data/entities/region.dart';
// import 'package:recipe_x/view/widgets/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:vector_graphics/vector_graphics.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selected = -1;
  @override
  Widget build(BuildContext context) {
    final tablet = medium(context);
    final desktop = expanded(context);
    final regions = context.watch<RegionBloc>().state.regions;
    // final countries = context.watch<CountryBloc>().state.countries;
    final recipesState = context.watch<RecipeBloc>().state;
    final count = recipesState.recipes.length;
    final recipes = recipesState.randomRecipes;
    final busy = recipesState.busy;
    final svgs = recipesState.svgs;
    final svgsAsWidget = svgs
        .map(
          (svg) => Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.25,
            alignment: Alignment.center,
            child: SvgPicture(
              AssetBytesLoader(
                svg,
              ),
              fit: BoxFit.fitWidth,
              clipBehavior: Clip.antiAlias,
            ),
          ),
        )
        .toList();
    final ingredients = context.watch<IngredientBloc>().state.ingredients;
    // final categories = context.watch<CategoryBloc>().state.categories;
    return Scaffold(
      appBar: AppBar(
        title: const Text('RecipeX'),
        actions: [
          /// theme
          IconButton(
            onPressed: () {
              context.read<ThemeBloc>().add(
                    const ToggleTheme(),
                  );
            },
            icon: const Icon(Icons.brightness_4_outlined),
          ),
        ],
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Cooking Delicious Recipes is now easier than ever.',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            TextField(
              onTap: () => context.goNamed(kFilterRoute),
              decoration: InputDecoration(
                hintText: 'Search for recipes',
                hintStyle: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: const Icon(Icons.filter_list),
              ),
            ),
            const SizedBox(
              height: 24,
            ),

            /// 5 Random Recipes from around the world
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Explore a collection of ${count <= 0 ? 'Loading...' : '$count'} recipes from around the world.',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              subtitle: Text(
                '11 Random Recipes, Refresh to get new ones anytime.',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.outline,
                    ),
              ),
              trailing: IconButton(
                onPressed: busy
                    ? null
                    : () {
                        context.read<RecipeBloc>().add(
                              const LoadRandomRecipes(
                                refresh: true,
                              ),
                            );
                      },
                icon: Icon(
                  Icons.refresh,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              children: [
                if (recipes.isEmpty && busy)
                  ...List.generate(
                    11,
                    (index) => Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      width: desktop
                          ? MediaQuery.of(context).size.width * 0.3
                          : tablet
                              ? MediaQuery.of(context).size.width * 0.45
                              : MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.25,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            child: SvgPicture(
                              AssetBytesLoader(
                                svgs[index],
                              ),
                              fit: BoxFit.fitWidth,
                              clipBehavior: Clip.antiAlias,
                            ),
                          ),
                          ListTile(
                            contentPadding: const EdgeInsets.all(8),
                            title: RichText(
                              textAlign: TextAlign.start,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Recipe Loading...',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          wordSpacing: 2.4,
                                          letterSpacing: 2.4,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            trailing: Container(
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 1,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              child: Container(
                                width: 8,
                                height: 8,
                                padding: const EdgeInsets.all(2),
                                margin: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: index % 2 == 0
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ),
                            subtitle: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                Text(
                                  'Loading some random recipes for you to explore...',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...recipes.map(
                    (recipe) {
                      final index = recipes.indexOf(recipe);
                      final svg = svgsAsWidget[index];
                      // final recipeIngredients = ingredients
                      //     .where((ingredient) =>
                      //         recipe.ingredients?.contains(ingredient.id) == true)
                      //     .toList();
                      final region = regions.firstWhere(
                        (element) => element.id == recipe.region,
                        orElse: () => const Region(),
                      );
                      return MouseRegion(
                        onHover: (event) {
                          setState(() {
                            selected = index;
                          });
                        },
                        onExit: (event) {
                          setState(() {
                            selected = -1;
                          });
                        },
                        child: Container(
                          width: desktop
                              ? MediaQuery.of(context).size.width * 0.3
                              : tablet
                                  ? MediaQuery.of(context).size.width * 0.45
                                  : MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: selected == index
                                ? Theme.of(context).colorScheme.surfaceVariant
                                : null,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: GestureDetector(
                            onTap: () => context
                                .pushNamed(kRecipeRoute, pathParameters: {
                              'recipe': recipe.id ?? '',
                            }),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                svg,
                                ListTile(
                                  contentPadding: const EdgeInsets.all(8),
                                  title: RichText(
                                    textAlign: TextAlign.start,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: recipe.name?.capitalizeAll ??
                                              'Recipe',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headlineMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                 decorationStyle:
                                                        TextDecorationStyle
                                                            .solid,
                                                wordSpacing: 2.4,
                                                letterSpacing: 2.4,
                                              ),
                                          children: [
                                            TextSpan(
                                              text:
                                                  ' (${region.name?.capitalizeAll??"World"})',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall
                                                  ?.copyWith(
                                                    letterSpacing: 2.4,
                                                    wordSpacing: 2.4,
                                                    fontWeight: FontWeight.bold,                                                   
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .outline,
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  trailing: Container(
                                    width: 16,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                    ),
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      padding: const EdgeInsets.all(2),
                                      margin: const EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: ingredients
                                                .where((ingredient) =>
                                                    recipe.ingredients
                                                        ?.contains(
                                                            ingredient.id) ==
                                                    true)
                                                .every((element) =>
                                                    element.isVegan == true)
                                            ? Colors.green
                                            : ingredients
                                                    .where((ingredient) =>
                                                        recipe.ingredients
                                                            ?.contains(
                                                                ingredient
                                                                    .id) ==
                                                        true)
                                                    .every((element) =>
                                                        element.isVeg == true)
                                                ? Colors.green
                                                : Colors.red,
                                      ),
                                    ),
                                  ),
                                  subtitle: Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      Text(
                                        recipe.description?.capitalizeAll ?? '',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),

                                      /// ingredients
                                      // ExpansionTile(
                                      //   title: Text(
                                      //     'Ingredients',
                                      //     style: Theme.of(context)
                                      //         .textTheme
                                      //         .labelLarge
                                      //         ?.copyWith(
                                      //           letterSpacing: 2.4,
                                      //           wordSpacing: 2.4,
                                      //           fontWeight: FontWeight.bold,
                                      //         ),
                                      //   ),
                                      //   trailing: const Icon(Icons.arrow_forward_ios),
                                      //   childrenPadding: EdgeInsets.zero,
                                      //   tilePadding: EdgeInsets.zero,
                                      //   children: [
                                      //     Wrap(
                                      //       runSpacing: 2,
                                      //       spacing: 2,
                                      //       children: [
                                      //         ...recipeIngredients.map(
                                      //           (ingredient) {
                                      //             final category =
                                      //                 categories.firstWhere(
                                      //               (element) =>
                                      //                   element.id ==
                                      //                   ingredient.category,
                                      //               orElse: () => const Category(),
                                      //             );
                                      //             return RawChip(
                                      //               onPressed: () {
                                      //                 /// show ingredient details
                                      //                 showCupertinoModalPopup(
                                      //                   context: context,
                                      //                   builder: (context) =>
                                      //                       Scaffold(
                                      //                     appBar: AppBar(
                                      //                       title: Text(
                                      //                         ingredient.name ?? '',
                                      //                         style: Theme.of(context)
                                      //                             .textTheme
                                      //                             .labelLarge
                                      //                             ?.copyWith(
                                      //                               letterSpacing:
                                      //                                   2.4,
                                      //                               wordSpacing: 2.4,
                                      //                               fontWeight:
                                      //                                   FontWeight
                                      //                                       .bold,
                                      //                             ),
                                      //                       ),
                                      //                     ),
                                      //                     body: SingleChildScrollView(
                                      //                       child: Column(
                                      //                         crossAxisAlignment:
                                      //                             CrossAxisAlignment
                                      //                                 .start,
                                      //                         children: [
                                      //                           ListTile(
                                      //                             title: Text(
                                      //                               'Ingredient Details',
                                      //                               style: Theme.of(
                                      //                                       context)
                                      //                                   .textTheme
                                      //                                   .labelLarge
                                      //                                   ?.copyWith(
                                      //                                     letterSpacing:
                                      //                                         2.4,
                                      //                                     wordSpacing:
                                      //                                         2.4,
                                      //                                     fontWeight:
                                      //                                         FontWeight
                                      //                                             .bold,
                                      //                                   ),
                                      //                             ),
                                      //                           ),
                                      //                           ListTile(
                                      //                             trailing: Container(
                                      //                               width: 16,
                                      //                               height: 16,
                                      //                               decoration:
                                      //                                   BoxDecoration(
                                      //                                 border:
                                      //                                     Border.all(
                                      //                                   width: 1,
                                      //                                   color: Theme.of(
                                      //                                           context)
                                      //                                       .colorScheme
                                      //                                       .onSurface,
                                      //                                 ),
                                      //                               ),
                                      //                               child: Container(
                                      //                                 width: 8,
                                      //                                 height: 8,
                                      //                                 margin:
                                      //                                     const EdgeInsets
                                      //                                         .all(2),
                                      //                                 padding:
                                      //                                     const EdgeInsets
                                      //                                         .all(2),
                                      //                                 decoration:
                                      //                                     BoxDecoration(
                                      //                                   shape: BoxShape
                                      //                                       .circle,
                                      //                                   color: ingredient
                                      //                                               .isVegan ==
                                      //                                           true
                                      //                                       ? Colors
                                      //                                           .green
                                      //                                       : ingredient.isVeg ==
                                      //                                               true
                                      //                                           ? Colors
                                      //                                               .green
                                      //                                           : Colors
                                      //                                               .red,
                                      //                                 ),
                                      //                               ),
                                      //                             ),
                                      //                             title: Text(
                                      //                               '#${ingredient.name ?? ''}',
                                      //                               style: Theme.of(
                                      //                                       context)
                                      //                                   .textTheme
                                      //                                   .labelLarge
                                      //                                   ?.copyWith(
                                      //                                     letterSpacing:
                                      //                                         2.4,
                                      //                                     wordSpacing:
                                      //                                         2.4,
                                      //                                     fontWeight:
                                      //                                         FontWeight
                                      //                                             .bold,
                                      //                                   ),
                                      //                             ),
                                      //                             dense: true,
                                      //                           ),
                                      //                           if (ingredient
                                      //                                   .synonyms
                                      //                                   ?.isNotEmpty ==
                                      //                               true)
                                      //                             ListTile(
                                      //                               title: Text(
                                      //                                 'Synonyms',
                                      //                                 style: Theme.of(
                                      //                                         context)
                                      //                                     .textTheme
                                      //                                     .labelLarge
                                      //                                     ?.copyWith(
                                      //                                       letterSpacing:
                                      //                                           2.4,
                                      //                                       wordSpacing:
                                      //                                           2.4,
                                      //                                       fontWeight:
                                      //                                           FontWeight
                                      //                                               .bold,
                                      //                                     ),
                                      //                               ),
                                      //                             ),
                                      //                           Padding(
                                      //                             padding:
                                      //                                 const EdgeInsets
                                      //                                     .all(8.0),
                                      //                             child: Wrap(
                                      //                               spacing: 8,
                                      //                               runSpacing: 8,
                                      //                               alignment:
                                      //                                   WrapAlignment
                                      //                                       .start,
                                      //                               crossAxisAlignment:
                                      //                                   WrapCrossAlignment
                                      //                                       .start,
                                      //                               runAlignment:
                                      //                                   WrapAlignment
                                      //                                       .start,
                                      //                               children: [
                                      //                                 ...ingredient
                                      //                                         .synonyms
                                      //                                         ?.map(
                                      //                                           (e) =>
                                      //                                               Chip(
                                      //                                             backgroundColor:
                                      //                                                 Theme.of(context).colorScheme.surface,
                                      //                                             label:
                                      //                                                 Text(
                                      //                                               e,
                                      //                                               style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      //                                                     letterSpacing: 2.4,
                                      //                                                     wordSpacing: 2.4,
                                      //                                                     fontWeight: FontWeight.bold,
                                      //                                                     color: Theme.of(context).colorScheme.tertiary,
                                      //                                                   ),
                                      //                                             ),
                                      //                                           ),
                                      //                                         )
                                      //                                         .toList() ??
                                      //                                     [],
                                      //                               ],
                                      //                             ),
                                      //                           ),
                                      //                           if (ingredient
                                      //                                   .compounds
                                      //                                   ?.isNotEmpty ==
                                      //                               true)
                                      //                             ListTile(
                                      //                               title: Text(
                                      //                                 'Compounds',
                                      //                                 style: Theme.of(
                                      //                                         context)
                                      //                                     .textTheme
                                      //                                     .labelLarge
                                      //                                     ?.copyWith(
                                      //                                       letterSpacing:
                                      //                                           2.4,
                                      //                                       wordSpacing:
                                      //                                           2.4,
                                      //                                       fontWeight:
                                      //                                           FontWeight
                                      //                                               .bold,
                                      //                                     ),
                                      //                               ),
                                      //                             ),
                                      //                           Padding(
                                      //                             padding:
                                      //                                 const EdgeInsets
                                      //                                     .all(8.0),
                                      //                             child: Wrap(
                                      //                               spacing: 8,
                                      //                               runSpacing: 8,
                                      //                               alignment:
                                      //                                   WrapAlignment
                                      //                                       .start,
                                      //                               crossAxisAlignment:
                                      //                                   WrapCrossAlignment
                                      //                                       .start,
                                      //                               runAlignment:
                                      //                                   WrapAlignment
                                      //                                       .start,
                                      //                               children: [
                                      //                                 ...ingredient
                                      //                                         .compounds
                                      //                                         ?.map(
                                      //                                           (e) =>
                                      //                                               Chip(
                                      //                                             backgroundColor:
                                      //                                                 Theme.of(context).colorScheme.surface,
                                      //                                             label:
                                      //                                                 Text(
                                      //                                               e,
                                      //                                               style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      //                                                     letterSpacing: 2.4,
                                      //                                                     wordSpacing: 2.4,
                                      //                                                     fontWeight: FontWeight.bold,
                                      //                                                     color: Theme.of(context).colorScheme.tertiary,
                                      //                                                   ),
                                      //                                             ),
                                      //                                           ),
                                      //                                         )
                                      //                                         .toList() ??
                                      //                                     [],
                                      //                               ],
                                      //                             ),
                                      //                           ),
                                      //                           ListTile(
                                      //                             title: Text(
                                      //                               'Type',
                                      //                               style: Theme.of(
                                      //                                       context)
                                      //                                   .textTheme
                                      //                                   .labelLarge
                                      //                                   ?.copyWith(
                                      //                                     letterSpacing:
                                      //                                         2.4,
                                      //                                     wordSpacing:
                                      //                                         2.4,
                                      //                                     fontWeight:
                                      //                                         FontWeight
                                      //                                             .bold,
                                      //                                   ),
                                      //                             ),
                                      //                             subtitle: Text(
                                      //                               ingredient.type ??
                                      //                                   '',
                                      //                               style: Theme.of(
                                      //                                       context)
                                      //                                   .textTheme
                                      //                                   .labelLarge
                                      //                                   ?.copyWith(
                                      //                                     letterSpacing:
                                      //                                         2.4,
                                      //                                     wordSpacing:
                                      //                                         2.4,
                                      //                                     fontWeight:
                                      //                                         FontWeight
                                      //                                             .bold,
                                      //                                   ),
                                      //                             ),
                                      //                           ),
                                      //                           ExpansionTile(
                                      //                             initiallyExpanded:
                                      //                                 true,
                                      //                             title: Text(
                                      //                               'Categoriy Details',
                                      //                               style: Theme.of(
                                      //                                       context)
                                      //                                   .textTheme
                                      //                                   .labelLarge
                                      //                                   ?.copyWith(
                                      //                                     letterSpacing:
                                      //                                         2.4,
                                      //                                     wordSpacing:
                                      //                                         2.4,
                                      //                                     fontWeight:
                                      //                                         FontWeight
                                      //                                             .bold,
                                      //                                   ),
                                      //                             ),
                                      //                             children: [
                                      //                               ListTile(
                                      //                                 title: Text(
                                      //                                   'Category #${category.name ?? ''}',
                                      //                                   style: Theme.of(
                                      //                                           context)
                                      //                                       .textTheme
                                      //                                       .labelLarge
                                      //                                       ?.copyWith(
                                      //                                         letterSpacing:
                                      //                                             2.4,
                                      //                                         wordSpacing:
                                      //                                             2.4,
                                      //                                         fontWeight:
                                      //                                             FontWeight.bold,
                                      //                                       ),
                                      //                                 ),
                                      //                                 trailing:
                                      //                                     Container(
                                      //                                   width: 16,
                                      //                                   height: 16,
                                      //                                   decoration:
                                      //                                       BoxDecoration(
                                      //                                     border:
                                      //                                         Border
                                      //                                             .all(
                                      //                                       width: 1,
                                      //                                       color: Theme.of(
                                      //                                               context)
                                      //                                           .colorScheme
                                      //                                           .onSurface,
                                      //                                     ),
                                      //                                   ),
                                      //                                   child:
                                      //                                       Container(
                                      //                                     width: 8,
                                      //                                     height: 8,
                                      //                                     margin:
                                      //                                         const EdgeInsets
                                      //                                             .all(
                                      //                                             2),
                                      //                                     padding:
                                      //                                         const EdgeInsets
                                      //                                             .all(
                                      //                                             2),
                                      //                                     decoration:
                                      //                                         BoxDecoration(
                                      //                                       shape: BoxShape
                                      //                                           .circle,
                                      //                                       color: category.isVegan ==
                                      //                                               true
                                      //                                           ? Colors
                                      //                                               .green
                                      //                                           : category.isVeg == true
                                      //                                               ? Colors.green
                                      //                                               : Colors.red,
                                      //                                     ),
                                      //                                   ),
                                      //                                 ),
                                      //                               ),
                                      //                               ListTile(
                                      //                                 title: Text(
                                      //                                   'Description',
                                      //                                   style: Theme.of(
                                      //                                           context)
                                      //                                       .textTheme
                                      //                                       .labelLarge
                                      //                                       ?.copyWith(
                                      //                                         letterSpacing:
                                      //                                             2.4,
                                      //                                         wordSpacing:
                                      //                                             2.4,
                                      //                                         fontWeight:
                                      //                                             FontWeight.bold,
                                      //                                       ),
                                      //                                 ),
                                      //                                 subtitle: Text(
                                      //                                   category.description ??
                                      //                                       '',
                                      //                                   style: Theme.of(
                                      //                                           context)
                                      //                                       .textTheme
                                      //                                       .labelLarge
                                      //                                       ?.copyWith(
                                      //                                         letterSpacing:
                                      //                                             2.4,
                                      //                                         wordSpacing:
                                      //                                             2.4,
                                      //                                         fontWeight:
                                      //                                             FontWeight.bold,
                                      //                                       ),
                                      //                                 ),
                                      //                               ),
                                      //                               ListTile(
                                      //                                 title: Text(
                                      //                                   'Is Vegan',
                                      //                                   style: Theme.of(
                                      //                                           context)
                                      //                                       .textTheme
                                      //                                       .labelLarge
                                      //                                       ?.copyWith(
                                      //                                         letterSpacing:
                                      //                                             2.4,
                                      //                                         wordSpacing:
                                      //                                             2.4,
                                      //                                         fontWeight:
                                      //                                             FontWeight.bold,
                                      //                                       ),
                                      //                                 ),
                                      //                                 subtitle: Text(
                                      //                                   category.isVegan ==
                                      //                                           true
                                      //                                       ? 'Yes'
                                      //                                       : 'No',
                                      //                                   style: Theme.of(
                                      //                                           context)
                                      //                                       .textTheme
                                      //                                       .labelLarge
                                      //                                       ?.copyWith(
                                      //                                         letterSpacing:
                                      //                                             2.4,
                                      //                                         wordSpacing:
                                      //                                             2.4,
                                      //                                         fontWeight:
                                      //                                             FontWeight.bold,
                                      //                                       ),
                                      //                                 ),
                                      //                               ),
                                      //                               ListTile(
                                      //                                 title: Text(
                                      //                                   'Is Veg',
                                      //                                   style: Theme.of(
                                      //                                           context)
                                      //                                       .textTheme
                                      //                                       .labelLarge
                                      //                                       ?.copyWith(
                                      //                                         letterSpacing:
                                      //                                             2.4,
                                      //                                         wordSpacing:
                                      //                                             2.4,
                                      //                                         fontWeight:
                                      //                                             FontWeight.bold,
                                      //                                       ),
                                      //                                 ),
                                      //                                 subtitle: Text(
                                      //                                   category.isVeg ==
                                      //                                           true
                                      //                                       ? 'Yes'
                                      //                                       : 'No',
                                      //                                   style: Theme.of(
                                      //                                           context)
                                      //                                       .textTheme
                                      //                                       .labelLarge
                                      //                                       ?.copyWith(
                                      //                                         letterSpacing:
                                      //                                             2.4,
                                      //                                         wordSpacing:
                                      //                                             2.4,
                                      //                                         fontWeight:
                                      //                                             FontWeight.bold,
                                      //                                       ),
                                      //                                 ),
                                      //                               ),

                                      //                               /// culinaryUses
                                      //                               ListTile(
                                      //                                 title: Text(
                                      //                                   'Culinary Uses',
                                      //                                   style: Theme.of(
                                      //                                           context)
                                      //                                       .textTheme
                                      //                                       .labelLarge
                                      //                                       ?.copyWith(
                                      //                                         letterSpacing:
                                      //                                             2.4,
                                      //                                         wordSpacing:
                                      //                                             2.4,
                                      //                                         fontWeight:
                                      //                                             FontWeight.bold,
                                      //                                       ),
                                      //                                 ),
                                      //                                 subtitle: Text(
                                      //                                   category.culinaryUses ??
                                      //                                       '',
                                      //                                   style: Theme.of(
                                      //                                           context)
                                      //                                       .textTheme
                                      //                                       .labelLarge
                                      //                                       ?.copyWith(
                                      //                                         letterSpacing:
                                      //                                             2.4,
                                      //                                         wordSpacing:
                                      //                                             2.4,
                                      //                                         fontWeight:
                                      //                                             FontWeight.bold,
                                      //                                       ),
                                      //                                 ),
                                      //                               ),

                                      //                               /// safetyConsiderations
                                      //                               ListTile(
                                      //                                 title: Text(
                                      //                                   'Safety Considerations',
                                      //                                   style: Theme.of(
                                      //                                           context)
                                      //                                       .textTheme
                                      //                                       .labelLarge
                                      //                                       ?.copyWith(
                                      //                                         letterSpacing:
                                      //                                             2.4,
                                      //                                         wordSpacing:
                                      //                                             2.4,
                                      //                                         fontWeight:
                                      //                                             FontWeight.bold,
                                      //                                       ),
                                      //                                 ),
                                      //                                 subtitle: Text(
                                      //                                   category.safetyConsiderations ??
                                      //                                       '',
                                      //                                   style: Theme.of(
                                      //                                           context)
                                      //                                       .textTheme
                                      //                                       .labelLarge
                                      //                                       ?.copyWith(
                                      //                                         letterSpacing:
                                      //                                             2.4,
                                      //                                         wordSpacing:
                                      //                                             2.4,
                                      //                                         fontWeight:
                                      //                                             FontWeight.bold,
                                      //                                       ),
                                      //                                 ),
                                      //                               ),
                                      //                             ],
                                      //                           ),
                                      //                         ],
                                      //                       ),
                                      //                     ),
                                      //                   ),
                                      //                 );
                                      //               },
                                      //               backgroundColor: Theme.of(context)
                                      //                   .colorScheme
                                      //                   .onSurface,
                                      //               label: Text(
                                      //                 ingredient.name ?? '',
                                      //                 style: Theme.of(context)
                                      //                     .textTheme
                                      //                     .labelSmall
                                      //                     ?.copyWith(
                                      //                       letterSpacing: 2.4,
                                      //                       wordSpacing: 2.4,
                                      //                       fontWeight:
                                      //                           FontWeight.bold,
                                      //                       color: Theme.of(context)
                                      //                           .colorScheme
                                      //                           .onError,
                                      //                     ),
                                      //               ),
                                      //             );
                                      //           },
                                      //         ),
                                      //       ],
                                      //     )
                                      //   ],
                                      // )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),

            /// Regions
            // Text(
            //   'Regions : ${regions.length} based cuisines',
            //   style: Theme.of(context).textTheme.titleLarge?.copyWith(
            //         fontWeight: FontWeight.bold,
            //       ),
            // ),
            // ...regions.map(
            //   (region) {
            //     final regionCountries = countries
            //         .where((country) =>
            //             region.countries?.map((e) => e.toLowerCase()).any((e) =>
            //                     e.contains(
            //                         country.name?.toLowerCase() ?? '')) ==
            //                 true ||
            //             country.name?.toLowerCase().contains(
            //                       region.name?.toLowerCase() ?? '',
            //                     ) ==
            //                 true)
            //         .toList();

            //     /// 5 random recipes from the region
            //     final regionRecipes = recipes
            //         .where((recipe) => recipe.region == region.id)
            //         .take(5)
            //         .toList()
            //       ..shuffle();

            //     return ExpansionTile(
            //       title: Text(
            //         region.name ?? '',
            //         style: Theme.of(context).textTheme.labelLarge?.copyWith(
            //               fontWeight: FontWeight.bold,
            //               color: Theme.of(context).colorScheme.primary,
            //             ),
            //       ),
            //       subtitle: Wrap(
            //         spacing: 8,
            //         runSpacing: 8,
            //         children: [
            //           ...regionCountries.map(
            //             (e) => Chip(
            //               backgroundColor:
            //                   Theme.of(context).colorScheme.surface,
            //               label: Text(
            //                 '${e.name ?? ''}[${e.emoji ?? ''}${e.code ?? ''}]',
            //                 style: Theme.of(context)
            //                     .textTheme
            //                     .labelSmall
            //                     ?.copyWith(
            //                       letterSpacing: 2.4,
            //                       wordSpacing: 2.4,
            //                       fontWeight: FontWeight.bold,
            //                       color: Theme.of(context).colorScheme.tertiary,
            //                     ),
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //       children: [
            //         ...regionRecipes.map(
            //           (recipe) {
            //             final recipeIngredients = ingredients
            //                 .where((ingredient) =>
            //                     recipe.ingredients?.contains(ingredient.id) ==
            //                     true)
            //                 .toList();
            //             final ingredientsCategories = recipeIngredients
            //                 .map((ingredient) => categories.firstWhere(
            //                       (element) =>
            //                           element.id == ingredient.category,
            //                       orElse: () => const Category(),
            //                     ))
            //                 .toList();
            //             return ListTile(
            //               onTap: () {
            //                 context.pushNamed(kRecipeRoute, pathParameters: {
            //                   'recipe': recipe.id ?? '',
            //                 });
            //               },
            //               title: Text(
            //                 recipe.name?.capitalizeAll ?? '',
            //                 style: Theme.of(context)
            //                     .textTheme
            //                     .headlineSmall
            //                     ?.copyWith(
            //                       fontWeight: FontWeight.bold,
            //                       color: Theme.of(context).colorScheme.primary,
            //                     ),
            //               ),
            //               trailing: Container(
            //                 width: 16,
            //                 height: 16,
            //                 decoration: BoxDecoration(
            //                   border: Border.all(
            //                     width: 1,
            //                     color: Theme.of(context).colorScheme.onSurface,
            //                   ),
            //                 ),
            //                 child: Container(
            //                   width: 8,
            //                   height: 8,
            //                   padding: const EdgeInsets.all(2),
            //                   margin: const EdgeInsets.all(2),
            //                   decoration: BoxDecoration(
            //                     borderRadius: BorderRadius.circular(16),
            //                     color: ingredientsCategories.every(
            //                             (element) => element.isVegan == true)
            //                         ? Colors.green
            //                         : ingredientsCategories.every(
            //                                 (element) => element.isVeg == true)
            //                             ? Colors.green
            //                             : Colors.red,
            //                   ),
            //                 ),
            //               ),
            //               subtitle: Wrap(
            //                 spacing: 8,
            //                 runSpacing: 8,
            //                 children: [
            //                   Text(
            //                     recipe.description?.capitalizeAll ?? '',
            //                     style: Theme.of(context)
            //                         .textTheme
            //                         .labelSmall
            //                         ?.copyWith(
            //                           letterSpacing: 2.4,
            //                           wordSpacing: 2.4,
            //                           fontWeight: FontWeight.bold,
            //                         ),
            //                   ),

            //                   /// ingredients
            //                   ExpansionTile(
            //                     title: Text(
            //                       'Ingredients',
            //                       style: Theme.of(context)
            //                           .textTheme
            //                           .labelLarge
            //                           ?.copyWith(
            //                             letterSpacing: 2.4,
            //                             wordSpacing: 2.4,
            //                             fontWeight: FontWeight.bold,
            //                           ),
            //                     ),
            //                     trailing: const Icon(Icons.arrow_forward_ios),
            //                     childrenPadding: EdgeInsets.zero,
            //                     tilePadding: EdgeInsets.zero,
            //                     children: [
            //                       Wrap(
            //                         runSpacing: 2,
            //                         spacing: 2,
            //                         children: [
            //                           ...recipeIngredients.map(
            //                             (ingredient) {
            //                               final category =
            //                                   categories.firstWhere(
            //                                 (element) =>
            //                                     element.id ==
            //                                     ingredient.category,
            //                                 orElse: () => const Category(),
            //                               );
            //                               return RawChip(
            //                                 onPressed: () {
            //                                   /// show ingredient details
            //                                   showCupertinoModalPopup(
            //                                     context: context,
            //                                     builder: (context) => Scaffold(
            //                                       appBar: AppBar(
            //                                         title: Text(
            //                                           ingredient.name ?? '',
            //                                           style: Theme.of(context)
            //                                               .textTheme
            //                                               .labelLarge
            //                                               ?.copyWith(
            //                                                 letterSpacing: 2.4,
            //                                                 wordSpacing: 2.4,
            //                                                 fontWeight:
            //                                                     FontWeight.bold,
            //                                               ),
            //                                         ),
            //                                       ),
            //                                       body: SingleChildScrollView(
            //                                         child: Column(
            //                                           crossAxisAlignment:
            //                                               CrossAxisAlignment
            //                                                   .start,
            //                                           children: [
            //                                             ListTile(
            //                                               title: Text(
            //                                                 'Ingredient Details',
            //                                                 style: Theme.of(
            //                                                         context)
            //                                                     .textTheme
            //                                                     .labelLarge
            //                                                     ?.copyWith(
            //                                                       letterSpacing:
            //                                                           2.4,
            //                                                       wordSpacing:
            //                                                           2.4,
            //                                                       fontWeight:
            //                                                           FontWeight
            //                                                               .bold,
            //                                                     ),
            //                                               ),
            //                                             ),
            //                                             ListTile(
            //                                               trailing: Container(
            //                                                 width: 16,
            //                                                 height: 16,
            //                                                 decoration:
            //                                                     BoxDecoration(
            //                                                   border:
            //                                                       Border.all(
            //                                                     width: 1,
            //                                                     color: Theme.of(
            //                                                             context)
            //                                                         .colorScheme
            //                                                         .onSurface,
            //                                                   ),
            //                                                 ),
            //                                                 child: Container(
            //                                                   width: 8,
            //                                                   height: 8,
            //                                                   margin:
            //                                                       const EdgeInsets
            //                                                           .all(2),
            //                                                   padding:
            //                                                       const EdgeInsets
            //                                                           .all(2),
            //                                                   decoration:
            //                                                       BoxDecoration(
            //                                                     shape: BoxShape
            //                                                         .circle,
            //                                                     color: ingredient
            //                                                                 .isVegan ==
            //                                                             true
            //                                                         ? Colors
            //                                                             .green
            //                                                         : ingredient.isVeg ==
            //                                                                 true
            //                                                             ? Colors
            //                                                                 .green
            //                                                             : Colors
            //                                                                 .red,
            //                                                   ),
            //                                                 ),
            //                                               ),
            //                                               title: Text(
            //                                                 '#${ingredient.name ?? ''}',
            //                                                 style: Theme.of(
            //                                                         context)
            //                                                     .textTheme
            //                                                     .labelLarge
            //                                                     ?.copyWith(
            //                                                       letterSpacing:
            //                                                           2.4,
            //                                                       wordSpacing:
            //                                                           2.4,
            //                                                       fontWeight:
            //                                                           FontWeight
            //                                                               .bold,
            //                                                     ),
            //                                               ),
            //                                               dense: true,
            //                                             ),
            //                                             if (ingredient.synonyms
            //                                                     ?.isNotEmpty ==
            //                                                 true)
            //                                               ListTile(
            //                                                 title: Text(
            //                                                   'Synonyms',
            //                                                   style: Theme.of(
            //                                                           context)
            //                                                       .textTheme
            //                                                       .labelLarge
            //                                                       ?.copyWith(
            //                                                         letterSpacing:
            //                                                             2.4,
            //                                                         wordSpacing:
            //                                                             2.4,
            //                                                         fontWeight:
            //                                                             FontWeight
            //                                                                 .bold,
            //                                                       ),
            //                                                 ),
            //                                               ),
            //                                             Padding(
            //                                               padding:
            //                                                   const EdgeInsets
            //                                                       .all(8.0),
            //                                               child: Wrap(
            //                                                 spacing: 8,
            //                                                 runSpacing: 8,
            //                                                 alignment:
            //                                                     WrapAlignment
            //                                                         .start,
            //                                                 crossAxisAlignment:
            //                                                     WrapCrossAlignment
            //                                                         .start,
            //                                                 runAlignment:
            //                                                     WrapAlignment
            //                                                         .start,
            //                                                 children: [
            //                                                   ...ingredient
            //                                                           .synonyms
            //                                                           ?.map(
            //                                                             (e) =>
            //                                                                 Chip(
            //                                                               backgroundColor: Theme.of(context)
            //                                                                   .colorScheme
            //                                                                   .surface,
            //                                                               label:
            //                                                                   Text(
            //                                                                 e,
            //                                                                 style: Theme.of(context).textTheme.labelSmall?.copyWith(
            //                                                                       letterSpacing: 2.4,
            //                                                                       wordSpacing: 2.4,
            //                                                                       fontWeight: FontWeight.bold,
            //                                                                       color: Theme.of(context).colorScheme.tertiary,
            //                                                                     ),
            //                                                               ),
            //                                                             ),
            //                                                           )
            //                                                           .toList() ??
            //                                                       [],
            //                                                 ],
            //                                               ),
            //                                             ),
            //                                             if (ingredient.compounds
            //                                                     ?.isNotEmpty ==
            //                                                 true)
            //                                               ListTile(
            //                                                 title: Text(
            //                                                   'Compounds',
            //                                                   style: Theme.of(
            //                                                           context)
            //                                                       .textTheme
            //                                                       .labelLarge
            //                                                       ?.copyWith(
            //                                                         letterSpacing:
            //                                                             2.4,
            //                                                         wordSpacing:
            //                                                             2.4,
            //                                                         fontWeight:
            //                                                             FontWeight
            //                                                                 .bold,
            //                                                       ),
            //                                                 ),
            //                                               ),
            //                                             Padding(
            //                                               padding:
            //                                                   const EdgeInsets
            //                                                       .all(8.0),
            //                                               child: Wrap(
            //                                                 spacing: 8,
            //                                                 runSpacing: 8,
            //                                                 alignment:
            //                                                     WrapAlignment
            //                                                         .start,
            //                                                 crossAxisAlignment:
            //                                                     WrapCrossAlignment
            //                                                         .start,
            //                                                 runAlignment:
            //                                                     WrapAlignment
            //                                                         .start,
            //                                                 children: [
            //                                                   ...ingredient
            //                                                           .compounds
            //                                                           ?.map(
            //                                                             (e) =>
            //                                                                 Chip(
            //                                                               backgroundColor: Theme.of(context)
            //                                                                   .colorScheme
            //                                                                   .surface,
            //                                                               label:
            //                                                                   Text(
            //                                                                 e,
            //                                                                 style: Theme.of(context).textTheme.labelSmall?.copyWith(
            //                                                                       letterSpacing: 2.4,
            //                                                                       wordSpacing: 2.4,
            //                                                                       fontWeight: FontWeight.bold,
            //                                                                       color: Theme.of(context).colorScheme.tertiary,
            //                                                                     ),
            //                                                               ),
            //                                                             ),
            //                                                           )
            //                                                           .toList() ??
            //                                                       [],
            //                                                 ],
            //                                               ),
            //                                             ),
            //                                             ListTile(
            //                                               title: Text(
            //                                                 'Type',
            //                                                 style: Theme.of(
            //                                                         context)
            //                                                     .textTheme
            //                                                     .labelLarge
            //                                                     ?.copyWith(
            //                                                       letterSpacing:
            //                                                           2.4,
            //                                                       wordSpacing:
            //                                                           2.4,
            //                                                       fontWeight:
            //                                                           FontWeight
            //                                                               .bold,
            //                                                     ),
            //                                               ),
            //                                               subtitle: Text(
            //                                                 ingredient.type ??
            //                                                     '',
            //                                                 style: Theme.of(
            //                                                         context)
            //                                                     .textTheme
            //                                                     .labelLarge
            //                                                     ?.copyWith(
            //                                                       letterSpacing:
            //                                                           2.4,
            //                                                       wordSpacing:
            //                                                           2.4,
            //                                                       fontWeight:
            //                                                           FontWeight
            //                                                               .bold,
            //                                                     ),
            //                                               ),
            //                                             ),
            //                                             ExpansionTile(
            //                                               initiallyExpanded:
            //                                                   true,
            //                                               title: Text(
            //                                                 'Categoriy Details',
            //                                                 style: Theme.of(
            //                                                         context)
            //                                                     .textTheme
            //                                                     .labelLarge
            //                                                     ?.copyWith(
            //                                                       letterSpacing:
            //                                                           2.4,
            //                                                       wordSpacing:
            //                                                           2.4,
            //                                                       fontWeight:
            //                                                           FontWeight
            //                                                               .bold,
            //                                                     ),
            //                                               ),
            //                                               children: [
            //                                                 ListTile(
            //                                                   title: Text(
            //                                                     'Category #${category.name ?? ''}',
            //                                                     style: Theme.of(
            //                                                             context)
            //                                                         .textTheme
            //                                                         .labelLarge
            //                                                         ?.copyWith(
            //                                                           letterSpacing:
            //                                                               2.4,
            //                                                           wordSpacing:
            //                                                               2.4,
            //                                                           fontWeight:
            //                                                               FontWeight
            //                                                                   .bold,
            //                                                         ),
            //                                                   ),
            //                                                   trailing:
            //                                                       Container(
            //                                                     width: 16,
            //                                                     height: 16,
            //                                                     decoration:
            //                                                         BoxDecoration(
            //                                                       border: Border
            //                                                           .all(
            //                                                         width: 1,
            //                                                         color: Theme.of(
            //                                                                 context)
            //                                                             .colorScheme
            //                                                             .onSurface,
            //                                                       ),
            //                                                     ),
            //                                                     child:
            //                                                         Container(
            //                                                       width: 8,
            //                                                       height: 8,
            //                                                       margin:
            //                                                           const EdgeInsets
            //                                                               .all(
            //                                                               2),
            //                                                       padding:
            //                                                           const EdgeInsets
            //                                                               .all(
            //                                                               2),
            //                                                       decoration:
            //                                                           BoxDecoration(
            //                                                         shape: BoxShape
            //                                                             .circle,
            //                                                         color: category.isVegan ==
            //                                                                 true
            //                                                             ? Colors
            //                                                                 .green
            //                                                             : category.isVeg ==
            //                                                                     true
            //                                                                 ? Colors.green
            //                                                                 : Colors.red,
            //                                                       ),
            //                                                     ),
            //                                                   ),
            //                                                 ),
            //                                                 ListTile(
            //                                                   title: Text(
            //                                                     'Description',
            //                                                     style: Theme.of(
            //                                                             context)
            //                                                         .textTheme
            //                                                         .labelLarge
            //                                                         ?.copyWith(
            //                                                           letterSpacing:
            //                                                               2.4,
            //                                                           wordSpacing:
            //                                                               2.4,
            //                                                           fontWeight:
            //                                                               FontWeight
            //                                                                   .bold,
            //                                                         ),
            //                                                   ),
            //                                                   subtitle: Text(
            //                                                     category.description ??
            //                                                         '',
            //                                                     style: Theme.of(
            //                                                             context)
            //                                                         .textTheme
            //                                                         .labelLarge
            //                                                         ?.copyWith(
            //                                                           letterSpacing:
            //                                                               2.4,
            //                                                           wordSpacing:
            //                                                               2.4,
            //                                                           fontWeight:
            //                                                               FontWeight
            //                                                                   .bold,
            //                                                         ),
            //                                                   ),
            //                                                 ),
            //                                                 ListTile(
            //                                                   title: Text(
            //                                                     'Is Vegan',
            //                                                     style: Theme.of(
            //                                                             context)
            //                                                         .textTheme
            //                                                         .labelLarge
            //                                                         ?.copyWith(
            //                                                           letterSpacing:
            //                                                               2.4,
            //                                                           wordSpacing:
            //                                                               2.4,
            //                                                           fontWeight:
            //                                                               FontWeight
            //                                                                   .bold,
            //                                                         ),
            //                                                   ),
            //                                                   subtitle: Text(
            //                                                     category.isVegan ==
            //                                                             true
            //                                                         ? 'Yes'
            //                                                         : 'No',
            //                                                     style: Theme.of(
            //                                                             context)
            //                                                         .textTheme
            //                                                         .labelLarge
            //                                                         ?.copyWith(
            //                                                           letterSpacing:
            //                                                               2.4,
            //                                                           wordSpacing:
            //                                                               2.4,
            //                                                           fontWeight:
            //                                                               FontWeight
            //                                                                   .bold,
            //                                                         ),
            //                                                   ),
            //                                                 ),
            //                                                 ListTile(
            //                                                   title: Text(
            //                                                     'Is Veg',
            //                                                     style: Theme.of(
            //                                                             context)
            //                                                         .textTheme
            //                                                         .labelLarge
            //                                                         ?.copyWith(
            //                                                           letterSpacing:
            //                                                               2.4,
            //                                                           wordSpacing:
            //                                                               2.4,
            //                                                           fontWeight:
            //                                                               FontWeight
            //                                                                   .bold,
            //                                                         ),
            //                                                   ),
            //                                                   subtitle: Text(
            //                                                     category.isVeg ==
            //                                                             true
            //                                                         ? 'Yes'
            //                                                         : 'No',
            //                                                     style: Theme.of(
            //                                                             context)
            //                                                         .textTheme
            //                                                         .labelLarge
            //                                                         ?.copyWith(
            //                                                           letterSpacing:
            //                                                               2.4,
            //                                                           wordSpacing:
            //                                                               2.4,
            //                                                           fontWeight:
            //                                                               FontWeight
            //                                                                   .bold,
            //                                                         ),
            //                                                   ),
            //                                                 ),

            //                                                 /// culinaryUses
            //                                                 ListTile(
            //                                                   title: Text(
            //                                                     'Culinary Uses',
            //                                                     style: Theme.of(
            //                                                             context)
            //                                                         .textTheme
            //                                                         .labelLarge
            //                                                         ?.copyWith(
            //                                                           letterSpacing:
            //                                                               2.4,
            //                                                           wordSpacing:
            //                                                               2.4,
            //                                                           fontWeight:
            //                                                               FontWeight
            //                                                                   .bold,
            //                                                         ),
            //                                                   ),
            //                                                   subtitle: Text(
            //                                                     category.culinaryUses ??
            //                                                         '',
            //                                                     style: Theme.of(
            //                                                             context)
            //                                                         .textTheme
            //                                                         .labelLarge
            //                                                         ?.copyWith(
            //                                                           letterSpacing:
            //                                                               2.4,
            //                                                           wordSpacing:
            //                                                               2.4,
            //                                                           fontWeight:
            //                                                               FontWeight
            //                                                                   .bold,
            //                                                         ),
            //                                                   ),
            //                                                 ),

            //                                                 /// safetyConsiderations
            //                                                 ListTile(
            //                                                   title: Text(
            //                                                     'Safety Considerations',
            //                                                     style: Theme.of(
            //                                                             context)
            //                                                         .textTheme
            //                                                         .labelLarge
            //                                                         ?.copyWith(
            //                                                           letterSpacing:
            //                                                               2.4,
            //                                                           wordSpacing:
            //                                                               2.4,
            //                                                           fontWeight:
            //                                                               FontWeight
            //                                                                   .bold,
            //                                                         ),
            //                                                   ),
            //                                                   subtitle: Text(
            //                                                     category.safetyConsiderations ??
            //                                                         '',
            //                                                     style: Theme.of(
            //                                                             context)
            //                                                         .textTheme
            //                                                         .labelLarge
            //                                                         ?.copyWith(
            //                                                           letterSpacing:
            //                                                               2.4,
            //                                                           wordSpacing:
            //                                                               2.4,
            //                                                           fontWeight:
            //                                                               FontWeight
            //                                                                   .bold,
            //                                                         ),
            //                                                   ),
            //                                                 ),
            //                                               ],
            //                                             ),
            //                                           ],
            //                                         ),
            //                                       ),
            //                                     ),
            //                                   );
            //                                 },
            //                                 backgroundColor: Theme.of(context)
            //                                     .colorScheme
            //                                     .onSurface,
            //                                 label: Text(
            //                                   ingredient.name ?? '',
            //                                   style: Theme.of(context)
            //                                       .textTheme
            //                                       .labelSmall
            //                                       ?.copyWith(
            //                                         letterSpacing: 2.4,
            //                                         wordSpacing: 2.4,
            //                                         fontWeight: FontWeight.bold,
            //                                         color: Theme.of(context)
            //                                             .colorScheme
            //                                             .onError,
            //                                       ),
            //                                 ),
            //                               );
            //                             },
            //                           ),
            //                         ],
            //                       )
            //                     ],
            //                   ),

            //                   Divider(
            //                     color: Theme.of(context).colorScheme.tertiary,
            //                   ),
            //                 ],
            //               ),
            //             );
            //           },
            //         ),
            //       ],
            //     );
            //   },
            // ),

            const SizedBox(
              height: 16,
            ),
            Divider(
              color: Theme.of(context).colorScheme.tertiary,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              trailing: Icon(
                Icons.info_outline,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                'Legal & Open Source Licenses',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              subtitle: Text(
                'Legal & Open Source Licenses: RecipeX is based on data from CulinaryDB, which is licensed under Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License. RecipeX is licensed under MIT License.',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'About',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => showAboutDialog(
                context: context,
                applicationName: 'RecipeX',
                applicationVersion: '2.0.0',
                applicationIcon: const FlutterLogo(),
                applicationLegalese: '© 2024 Ravi Kovind',
              ),
            ),

            /// liscence
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Liscence',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => showLicensePage(
                context: context,
                applicationName: 'RecipeX',
                applicationVersion: '2.0.0',
                applicationIcon: const FlutterLogo(),
                applicationLegalese: '© 2024 Ravi Kovind',
              ),
            ),
            if (!kIsWeb)
              ListTile(
                contentPadding: EdgeInsets.zero,
                onTap: () async {
                  final uri =
                      Uri.parse('https://ravikovind.github.io/recipe_x/');
                  try {
                    launchUrl(uri);
                  } catch (e) {
                    throw 'There was an error trying to launch the URL: $uri';
                  }
                },
                title: Text(
                  'Website : https://ravikovind.github.io/recipe_x/',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                subtitle: RichText(
                  text: TextSpan(
                    text: 'Web version of RecipeX',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            const SizedBox(
              height: 16,
            ),
            RichText(
              text: TextSpan(
                text: 'Main Data Source of RecipeX is : ',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                children: [
                  TextSpan(
                    text: 'https://cosylab.iiitd.edu.in/culinarydb/',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        final uri = Uri.parse(
                          'https://cosylab.iiitd.edu.in/culinarydb/',
                        );

                        try {
                          launchUrl(uri);
                        } catch (e) {
                          throw 'There was an error trying to launch the URL: $uri';
                        }
                      },
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                  const TextSpan(
                    text: '.\n',
                  ),
                  TextSpan(
                    text:
                        'using above data, we have created a database for RecipeX, you can find it here : ',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                  TextSpan(
                    text: 'Get RecipeX Database',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        final uri = Uri.parse(
                          'mailto:ravikumar2710999@gmail.com?subject=Please%20Share%20RecipeX%20DB&body=Hey%20There!%0A%3CPlease%20write%20your%20reason%20here%3E',
                        );
                        try {
                          launchUrl(uri);
                        } catch (e) {
                          throw 'There was an error trying to launch the URL: $uri';
                        }
                      },
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ],
              ),
            ),

            RichText(
              text: TextSpan(
                text:
                    'Some of ingredients data is taken from AI, it may not be accurate. based on that, the app may not be accurate as well. if you find any mistakes, please report it on.\nDeciding the recipe is going to be vegan or vegetarian is based on the ingredients, not the recipe itself.\n\n',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                      fontWeight: FontWeight.w200,
                    ),
                children: [
                  /// illustrations are just for showcase, they don't represent the actual recipe, ingredients
                  TextSpan(
                    text:
                        'Illustrations are just for showcase, they don\'t represent the actual recipe, ingredients etc.',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                          fontWeight: FontWeight.w200,
                        ),
                  ),
                ],
                // children: [
                //   TextSpan(
                //     text: 'Report Issues',
                //     recognizer: TapGestureRecognizer()
                //       ..onTap = () {
                //         final uri = Uri.parse(
                //           'mailto:ravikumar2710999@gmail.com?subject=Issue%20in%20RecipeX&body=Hey%20There!%0A%3CPlease%20write%20issue%20here%3E',
                //         );
                //         try {
                //           launchUrl(uri);
                //         } catch (e) {
                //           throw 'There was an error trying to launch the URL: $uri';
                //         }
                //       },
                //     style: Theme.of(context).textTheme.labelLarge?.copyWith(
                //           fontWeight: FontWeight.bold,
                //           color: Theme.of(context).colorScheme.primary,
                //         ),
                //   ),
                // ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () async {
                final uri = Uri.parse(
                  'mailto:ravikumar2710999@gmail.com?subject=Issue%20in%20RecipeX&body=Hey%20There!%0A%3CPlease%20write%20issue%20here%3E',
                );
                try {
                  await launchUrl(uri);
                } catch (e) {
                  throw 'There was an error trying to launch the URL: $uri';
                }
              },
              title: Text(
                'Report Issues',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.error,
                    ),
              ),
              leading: Icon(
                Icons.bug_report,
                color: Theme.of(context).colorScheme.error,
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),

            /// feedback & suggestions
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () async {
                final uri = Uri.parse(
                  'mailto:ravikumar2710999@gmail.com?subject=Feedback%20for%20RecipeX&body=Hey%20There!%0A%3CPlease%20write%20your%20feedback%20here%3E',
                );
                try {
                  await launchUrl(uri);
                } catch (e) {
                  throw 'There was an error trying to launch the URL: $uri';
                }
              },
              title: Text(
                'Feedback & Suggestions',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              leading: Icon(
                Icons.feedback,
                color: Theme.of(context).colorScheme.primary,
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),

            /// contact us
            ListTile(
              contentPadding: EdgeInsets.zero,
              onTap: () async {
                final uri = Uri.parse(
                  'https://ravikovind.github.io/',
                );
                try {
                  await launchUrl(uri);
                } catch (e) {
                  throw 'There was an error trying to launch the URL: $uri';
                }
              },
              title: Text(
                'Contact Us',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              leading: Icon(
                Icons.contact_mail,
                color: Theme.of(context).colorScheme.primary,
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),

            const SizedBox(
              height: 32.0,
            ),

            /// Thank You
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'Thank You\n',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      letterSpacing: 2.4,
                      wordSpacing: 2.4,
                    ),
                children: [
                  TextSpan(
                    text: 'Made with ',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.4,
                          wordSpacing: 2.4,
                        ),
                    children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          Icons.favorite,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),

                      /// Footbus Ltd
                      /// A UK Company Reg No 12986850
                      const TextSpan(
                        text: ' in India🇮🇳\n',
                      ),
                      const TextSpan(
                        text: 'by Team RecipeX',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),

            Text(
              'RecipeX v2.0.0',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.surfaceVariant,
                  ),
            ),
            Text(
              '© 2024 Ravi Kovind',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.surfaceVariant,
                  ),
            ),
            const SizedBox(height: 64.0),
          ],
        ),
      ),
    );
  }
}

// /// [RecipeClipper] is used to clip the recipe svg widget

// class RecipeClipper extends CustomClipper<Path> {
//   const RecipeClipper();
//   @override
//   Path getClip(Size size) {
//     final path = Path()
//       ..moveTo(size.width * 0.5, 0)
//       ..lineTo(size.width, 0)
//       ..lineTo(size.width, size.height)
//       ..lineTo(size.width * 0.5, size.height)
//       ..lineTo(size.width * 0.5, size.height * 0.5)
//       ..lineTo(0, size.height * 0.5)
//       ..lineTo(0, size.height)
//       ..lineTo(size.width * 0.5, size.height)
//       ..lineTo(size.width * 0.5, 0)
//       ..close();
//     return path;
//   }

//   @override
//   bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
// }

