import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_x/bloc/category/category_bloc.dart';
import 'package:recipe_x/bloc/country/country_bloc.dart';
import 'package:recipe_x/bloc/ingredient/ingredient_bloc.dart';
import 'package:recipe_x/bloc/recipe/recipe_bloc.dart';
import 'package:recipe_x/bloc/region/region_bloc.dart';
import 'package:recipe_x/core/routes/routes.dart';
import 'package:recipe_x/core/utils/extenstions.dart';
import 'package:recipe_x/data/entities/category.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final regions = context.watch<RegionBloc>().state.regions;
    final countries = context.watch<CountryBloc>().state.countries;
    final recipes = context.watch<RecipeBloc>().state.recipes;
    final ingredients = context.watch<IngredientBloc>().state.ingredients;
    final categories = context.watch<CategoryBloc>().state.categories;
    return Scaffold(
      appBar: AppBar(
        title: const Text('RecipeX'),
        actions: [
          /// search
          IconButton(
            onPressed: () {
              context.goNamed(kFilterRoute);
            },
            icon: const Icon(Icons.filter_alt_sharp),
          ),
        ],
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            /// Recipe X : The Recipe App for Everyone
            /// A simple, yet powerful recipe app for everyone.
            /// A collection of 47,000+ recipes from around the world. along with their ingredients, country of origin, and region.
            /// It's free and open source.
            Text(
              'RecipeX : The Recipe Application',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              'A simple, yet powerful recipe app for everyone.',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              'Explore a collection of ${recipes.length} recipes from around the world. along with their ingredients, country of origin, and region. choose from a wide range of categories[${categories.length}] and ingredients[${ingredients.length}] to find the recipe you are looking for.',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            const SizedBox(
              height: 24,
            ),

            /// 5 Random Recipes from around the world
            Text(
              '10 Random Recipes from around the world: ',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(
              height: 16,
            ),
            ...recipes.take(10).map(
              (recipe) {
                final recipeIngredients = ingredients
                    .where((ingredient) =>
                        recipe.ingredients?.contains(ingredient.id) == true)
                    .toList();
                return ListTile(
                  onTap: () {
                    context.pushNamed(kRecipeRoute, pathParameters: {
                      'recipe': recipe.id ?? '',
                    });
                  },
                  title: Text(
                    recipe.name?.capitalizeAll ?? '',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  leading: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Theme.of(context).colorScheme.onSurface,
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
                                        ?.contains(ingredient.id) ==
                                    true)
                                .every((element) => element.isVegan == true)
                            ? Colors.green
                            : ingredients
                                    .where((ingredient) =>
                                        recipe.ingredients
                                            ?.contains(ingredient.id) ==
                                        true)
                                    .every((element) => element.isVeg == true)
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
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              letterSpacing: 2.4,
                              wordSpacing: 2.4,
                              fontWeight: FontWeight.bold,
                            ),
                      ),

                      /// ingredients
                      ExpansionTile(
                        title: Text(
                          'Ingredients',
                          style:
                              Theme.of(context).textTheme.labelLarge?.copyWith(
                                    letterSpacing: 2.4,
                                    wordSpacing: 2.4,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        childrenPadding: EdgeInsets.zero,
                        tilePadding: EdgeInsets.zero,
                        children: [
                          Wrap(
                            runSpacing: 2,
                            spacing: 2,
                            children: [
                              ...recipeIngredients.map(
                                (ingredient) {
                                  final category = categories.firstWhere(
                                    (element) =>
                                        element.id == ingredient.category,
                                    orElse: () => const Category(),
                                  );
                                  return RawChip(
                                    onPressed: () {
                                      /// show ingredient details
                                      showCupertinoModalPopup(
                                        context: context,
                                        builder: (context) => Scaffold(
                                          appBar: AppBar(
                                            title: Text(
                                              ingredient.name ?? '',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelLarge
                                                  ?.copyWith(
                                                    letterSpacing: 2.4,
                                                    wordSpacing: 2.4,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                          body: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ListTile(
                                                  title: Text(
                                                    'Ingredient Details',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelLarge
                                                        ?.copyWith(
                                                          letterSpacing: 2.4,
                                                          wordSpacing: 2.4,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                ),
                                                ListTile(
                                                  leading: Container(
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
                                                      margin:
                                                          const EdgeInsets.all(
                                                              2),
                                                      padding:
                                                          const EdgeInsets.all(
                                                              2),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: ingredient
                                                                    .isVegan ==
                                                                true
                                                            ? Colors.green
                                                            : ingredient.isVeg ==
                                                                    true
                                                                ? Colors.green
                                                                : Colors.red,
                                                      ),
                                                    ),
                                                  ),
                                                  title: Text(
                                                    '#${ingredient.name ?? ''}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelLarge
                                                        ?.copyWith(
                                                          letterSpacing: 2.4,
                                                          wordSpacing: 2.4,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                  dense: true,
                                                ),
                                                if (ingredient
                                                        .synonyms?.isNotEmpty ==
                                                    true)
                                                  ListTile(
                                                    title: Text(
                                                      'Synonyms',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelLarge
                                                          ?.copyWith(
                                                            letterSpacing: 2.4,
                                                            wordSpacing: 2.4,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    ),
                                                  ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Wrap(
                                                    spacing: 8,
                                                    runSpacing: 8,
                                                    alignment:
                                                        WrapAlignment.start,
                                                    crossAxisAlignment:
                                                        WrapCrossAlignment
                                                            .start,
                                                    runAlignment:
                                                        WrapAlignment.start,
                                                    children: [
                                                      ...ingredient.synonyms
                                                              ?.map(
                                                                (e) => Chip(
                                                                  backgroundColor: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .surface,
                                                                  label: Text(
                                                                    e,
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .labelSmall
                                                                        ?.copyWith(
                                                                          letterSpacing:
                                                                              2.4,
                                                                          wordSpacing:
                                                                              2.4,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color: Theme.of(context)
                                                                              .colorScheme
                                                                              .tertiary,
                                                                        ),
                                                                  ),
                                                                ),
                                                              )
                                                              .toList() ??
                                                          [],
                                                    ],
                                                  ),
                                                ),
                                                if (ingredient.compounds
                                                        ?.isNotEmpty ==
                                                    true)
                                                  ListTile(
                                                    title: Text(
                                                      'Compounds',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelLarge
                                                          ?.copyWith(
                                                            letterSpacing: 2.4,
                                                            wordSpacing: 2.4,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    ),
                                                  ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Wrap(
                                                    spacing: 8,
                                                    runSpacing: 8,
                                                    alignment:
                                                        WrapAlignment.start,
                                                    crossAxisAlignment:
                                                        WrapCrossAlignment
                                                            .start,
                                                    runAlignment:
                                                        WrapAlignment.start,
                                                    children: [
                                                      ...ingredient.compounds
                                                              ?.map(
                                                                (e) => Chip(
                                                                  backgroundColor: Theme.of(
                                                                          context)
                                                                      .colorScheme
                                                                      .surface,
                                                                  label: Text(
                                                                    e,
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .labelSmall
                                                                        ?.copyWith(
                                                                          letterSpacing:
                                                                              2.4,
                                                                          wordSpacing:
                                                                              2.4,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                          color: Theme.of(context)
                                                                              .colorScheme
                                                                              .tertiary,
                                                                        ),
                                                                  ),
                                                                ),
                                                              )
                                                              .toList() ??
                                                          [],
                                                    ],
                                                  ),
                                                ),
                                                ListTile(
                                                  title: Text(
                                                    'Type',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelLarge
                                                        ?.copyWith(
                                                          letterSpacing: 2.4,
                                                          wordSpacing: 2.4,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                  subtitle: Text(
                                                    ingredient.type ?? '',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelLarge
                                                        ?.copyWith(
                                                          letterSpacing: 2.4,
                                                          wordSpacing: 2.4,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                ),
                                                ExpansionTile(
                                                  initiallyExpanded: true,
                                                  title: Text(
                                                    'Categoriy Details',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelLarge
                                                        ?.copyWith(
                                                          letterSpacing: 2.4,
                                                          wordSpacing: 2.4,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                  children: [
                                                    ListTile(
                                                      title: Text(
                                                        'Category #${category.name ?? ''}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelLarge
                                                            ?.copyWith(
                                                              letterSpacing:
                                                                  2.4,
                                                              wordSpacing: 2.4,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                      ),
                                                      leading: Container(
                                                        width: 16,
                                                        height: 16,
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                            width: 1,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .onSurface,
                                                          ),
                                                        ),
                                                        child: Container(
                                                          width: 8,
                                                          height: 8,
                                                          margin:
                                                              const EdgeInsets
                                                                  .all(2),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(2),
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: category
                                                                        .isVegan ==
                                                                    true
                                                                ? Colors.green
                                                                : category.isVeg ==
                                                                        true
                                                                    ? Colors
                                                                        .green
                                                                    : Colors
                                                                        .red,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    ListTile(
                                                      title: Text(
                                                        'Description',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelLarge
                                                            ?.copyWith(
                                                              letterSpacing:
                                                                  2.4,
                                                              wordSpacing: 2.4,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                      ),
                                                      subtitle: Text(
                                                        category.description ??
                                                            '',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelLarge
                                                            ?.copyWith(
                                                              letterSpacing:
                                                                  2.4,
                                                              wordSpacing: 2.4,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                      ),
                                                    ),
                                                    ListTile(
                                                      title: Text(
                                                        'Is Vegan',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelLarge
                                                            ?.copyWith(
                                                              letterSpacing:
                                                                  2.4,
                                                              wordSpacing: 2.4,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                      ),
                                                      subtitle: Text(
                                                        category.isVegan == true
                                                            ? 'Yes'
                                                            : 'No',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelLarge
                                                            ?.copyWith(
                                                              letterSpacing:
                                                                  2.4,
                                                              wordSpacing: 2.4,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                      ),
                                                    ),
                                                    ListTile(
                                                      title: Text(
                                                        'Is Veg',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelLarge
                                                            ?.copyWith(
                                                              letterSpacing:
                                                                  2.4,
                                                              wordSpacing: 2.4,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                      ),
                                                      subtitle: Text(
                                                        category.isVeg == true
                                                            ? 'Yes'
                                                            : 'No',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelLarge
                                                            ?.copyWith(
                                                              letterSpacing:
                                                                  2.4,
                                                              wordSpacing: 2.4,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                      ),
                                                    ),

                                                    /// culinaryUses
                                                    ListTile(
                                                      title: Text(
                                                        'Culinary Uses',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelLarge
                                                            ?.copyWith(
                                                              letterSpacing:
                                                                  2.4,
                                                              wordSpacing: 2.4,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                      ),
                                                      subtitle: Text(
                                                        category.culinaryUses ??
                                                            '',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelLarge
                                                            ?.copyWith(
                                                              letterSpacing:
                                                                  2.4,
                                                              wordSpacing: 2.4,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                      ),
                                                    ),

                                                    /// safetyConsiderations
                                                    ListTile(
                                                      title: Text(
                                                        'Safety Considerations',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelLarge
                                                            ?.copyWith(
                                                              letterSpacing:
                                                                  2.4,
                                                              wordSpacing: 2.4,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                      ),
                                                      subtitle: Text(
                                                        category.safetyConsiderations ??
                                                            '',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .labelLarge
                                                            ?.copyWith(
                                                              letterSpacing:
                                                                  2.4,
                                                              wordSpacing: 2.4,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    backgroundColor:
                                        Theme.of(context).colorScheme.onSurface,
                                    label: Text(
                                      ingredient.name ?? '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            letterSpacing: 2.4,
                                            wordSpacing: 2.4,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onError,
                                          ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                );
              },
            ),

            /// Regions
            Text(
              'Regions : ${regions.length} based cuisines',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),

            ...regions.map(
              (region) {
                final regionCountries = countries
                    .where((country) =>
                        region.countries?.map((e) => e.toLowerCase()).any((e) =>
                                e.contains(
                                    country.name?.toLowerCase() ?? '')) ==
                            true ||
                        country.name?.toLowerCase().contains(
                                  region.name?.toLowerCase() ?? '',
                                ) ==
                            true)
                    .toList();

                /// 5 random recipes from the region
                final regionRecipes = recipes
                    .where((recipe) => recipe.region == region.id)
                    .take(5)
                    .toList()
                  ..shuffle();

                return ExpansionTile(
                  title: Text(
                    region.name ?? '',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  subtitle: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ...regionCountries.map(
                        (e) => Chip(
                          backgroundColor:
                              Theme.of(context).colorScheme.surface,
                          label: Text(
                            '${e.name ?? ''}[${e.emoji ?? ''}${e.code ?? ''}]',
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(
                                  letterSpacing: 2.4,
                                  wordSpacing: 2.4,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  children: [
                    ...regionRecipes.map(
                      (recipe) {
                        final recipeIngredients = ingredients
                            .where((ingredient) =>
                                recipe.ingredients?.contains(ingredient.id) ==
                                true)
                            .toList();
                        final ingredientsCategories = recipeIngredients
                            .map((ingredient) => categories.firstWhere(
                                  (element) =>
                                      element.id == ingredient.category,
                                  orElse: () => const Category(),
                                ))
                            .toList();
                        return ListTile(
                          onTap: () {
                            context.pushNamed(kRecipeRoute, pathParameters: {
                              'recipe': recipe.id ?? '',
                            });
                          },
                          title: Text(
                            recipe.name?.capitalizeAll ?? '',
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                          leading: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            child: Container(
                              width: 8,
                              height: 8,
                              padding: const EdgeInsets.all(2),
                              margin: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: ingredientsCategories.every(
                                        (element) => element.isVegan == true)
                                    ? Colors.green
                                    : ingredientsCategories.every(
                                            (element) => element.isVeg == true)
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
                                    .labelSmall
                                    ?.copyWith(
                                      letterSpacing: 2.4,
                                      wordSpacing: 2.4,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),

                              /// ingredients
                              ExpansionTile(
                                title: Text(
                                  'Ingredients',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelLarge
                                      ?.copyWith(
                                        letterSpacing: 2.4,
                                        wordSpacing: 2.4,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                trailing: const Icon(Icons.arrow_forward_ios),
                                childrenPadding: EdgeInsets.zero,
                                tilePadding: EdgeInsets.zero,
                                children: [
                                  Wrap(
                                    runSpacing: 2,
                                    spacing: 2,
                                    children: [
                                      ...recipeIngredients.map(
                                        (ingredient) {
                                          final category =
                                              categories.firstWhere(
                                            (element) =>
                                                element.id ==
                                                ingredient.category,
                                            orElse: () => const Category(),
                                          );
                                          return RawChip(
                                            onPressed: () {
                                              /// show ingredient details
                                              showCupertinoModalPopup(
                                                context: context,
                                                builder: (context) => Scaffold(
                                                  appBar: AppBar(
                                                    title: Text(
                                                      ingredient.name ?? '',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .labelLarge
                                                          ?.copyWith(
                                                            letterSpacing: 2.4,
                                                            wordSpacing: 2.4,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                    ),
                                                  ),
                                                  body: SingleChildScrollView(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        ListTile(
                                                          title: Text(
                                                            'Ingredient Details',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .labelLarge
                                                                ?.copyWith(
                                                                  letterSpacing:
                                                                      2.4,
                                                                  wordSpacing:
                                                                      2.4,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                          ),
                                                        ),
                                                        ListTile(
                                                          leading: Container(
                                                            width: 16,
                                                            height: 16,
                                                            decoration:
                                                                BoxDecoration(
                                                              border:
                                                                  Border.all(
                                                                width: 1,
                                                                color: Theme.of(
                                                                        context)
                                                                    .colorScheme
                                                                    .onSurface,
                                                              ),
                                                            ),
                                                            child: Container(
                                                              width: 8,
                                                              height: 8,
                                                              margin:
                                                                  const EdgeInsets
                                                                      .all(2),
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(2),
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: ingredient
                                                                            .isVegan ==
                                                                        true
                                                                    ? Colors
                                                                        .green
                                                                    : ingredient.isVeg ==
                                                                            true
                                                                        ? Colors
                                                                            .green
                                                                        : Colors
                                                                            .red,
                                                              ),
                                                            ),
                                                          ),
                                                          title: Text(
                                                            '#${ingredient.name ?? ''}',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .labelLarge
                                                                ?.copyWith(
                                                                  letterSpacing:
                                                                      2.4,
                                                                  wordSpacing:
                                                                      2.4,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                          ),
                                                          dense: true,
                                                        ),
                                                        if (ingredient.synonyms
                                                                ?.isNotEmpty ==
                                                            true)
                                                          ListTile(
                                                            title: Text(
                                                              'Synonyms',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .labelLarge
                                                                  ?.copyWith(
                                                                    letterSpacing:
                                                                        2.4,
                                                                    wordSpacing:
                                                                        2.4,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                            ),
                                                          ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Wrap(
                                                            spacing: 8,
                                                            runSpacing: 8,
                                                            alignment:
                                                                WrapAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                WrapCrossAlignment
                                                                    .start,
                                                            runAlignment:
                                                                WrapAlignment
                                                                    .start,
                                                            children: [
                                                              ...ingredient
                                                                      .synonyms
                                                                      ?.map(
                                                                        (e) =>
                                                                            Chip(
                                                                          backgroundColor: Theme.of(context)
                                                                              .colorScheme
                                                                              .surface,
                                                                          label:
                                                                              Text(
                                                                            e,
                                                                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                                                                  letterSpacing: 2.4,
                                                                                  wordSpacing: 2.4,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color: Theme.of(context).colorScheme.tertiary,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                      )
                                                                      .toList() ??
                                                                  [],
                                                            ],
                                                          ),
                                                        ),
                                                        if (ingredient.compounds
                                                                ?.isNotEmpty ==
                                                            true)
                                                          ListTile(
                                                            title: Text(
                                                              'Compounds',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .labelLarge
                                                                  ?.copyWith(
                                                                    letterSpacing:
                                                                        2.4,
                                                                    wordSpacing:
                                                                        2.4,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                            ),
                                                          ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Wrap(
                                                            spacing: 8,
                                                            runSpacing: 8,
                                                            alignment:
                                                                WrapAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                WrapCrossAlignment
                                                                    .start,
                                                            runAlignment:
                                                                WrapAlignment
                                                                    .start,
                                                            children: [
                                                              ...ingredient
                                                                      .compounds
                                                                      ?.map(
                                                                        (e) =>
                                                                            Chip(
                                                                          backgroundColor: Theme.of(context)
                                                                              .colorScheme
                                                                              .surface,
                                                                          label:
                                                                              Text(
                                                                            e,
                                                                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                                                                  letterSpacing: 2.4,
                                                                                  wordSpacing: 2.4,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  color: Theme.of(context).colorScheme.tertiary,
                                                                                ),
                                                                          ),
                                                                        ),
                                                                      )
                                                                      .toList() ??
                                                                  [],
                                                            ],
                                                          ),
                                                        ),
                                                        ListTile(
                                                          title: Text(
                                                            'Type',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .labelLarge
                                                                ?.copyWith(
                                                                  letterSpacing:
                                                                      2.4,
                                                                  wordSpacing:
                                                                      2.4,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                          ),
                                                          subtitle: Text(
                                                            ingredient.type ??
                                                                '',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .labelLarge
                                                                ?.copyWith(
                                                                  letterSpacing:
                                                                      2.4,
                                                                  wordSpacing:
                                                                      2.4,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                          ),
                                                        ),
                                                        ExpansionTile(
                                                          initiallyExpanded:
                                                              true,
                                                          title: Text(
                                                            'Categoriy Details',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .labelLarge
                                                                ?.copyWith(
                                                                  letterSpacing:
                                                                      2.4,
                                                                  wordSpacing:
                                                                      2.4,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                          ),
                                                          children: [
                                                            ListTile(
                                                              title: Text(
                                                                'Category #${category.name ?? ''}',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .labelLarge
                                                                    ?.copyWith(
                                                                      letterSpacing:
                                                                          2.4,
                                                                      wordSpacing:
                                                                          2.4,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                              ),
                                                              leading:
                                                                  Container(
                                                                width: 16,
                                                                height: 16,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  border: Border
                                                                      .all(
                                                                    width: 1,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .colorScheme
                                                                        .onSurface,
                                                                  ),
                                                                ),
                                                                child:
                                                                    Container(
                                                                  width: 8,
                                                                  height: 8,
                                                                  margin:
                                                                      const EdgeInsets
                                                                          .all(2),
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(2),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    shape: BoxShape
                                                                        .circle,
                                                                    color: category.isVegan ==
                                                                            true
                                                                        ? Colors
                                                                            .green
                                                                        : category.isVeg ==
                                                                                true
                                                                            ? Colors.green
                                                                            : Colors.red,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            ListTile(
                                                              title: Text(
                                                                'Description',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .labelLarge
                                                                    ?.copyWith(
                                                                      letterSpacing:
                                                                          2.4,
                                                                      wordSpacing:
                                                                          2.4,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                              ),
                                                              subtitle: Text(
                                                                category.description ??
                                                                    '',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .labelLarge
                                                                    ?.copyWith(
                                                                      letterSpacing:
                                                                          2.4,
                                                                      wordSpacing:
                                                                          2.4,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                              ),
                                                            ),
                                                            ListTile(
                                                              title: Text(
                                                                'Is Vegan',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .labelLarge
                                                                    ?.copyWith(
                                                                      letterSpacing:
                                                                          2.4,
                                                                      wordSpacing:
                                                                          2.4,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                              ),
                                                              subtitle: Text(
                                                                category.isVegan ==
                                                                        true
                                                                    ? 'Yes'
                                                                    : 'No',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .labelLarge
                                                                    ?.copyWith(
                                                                      letterSpacing:
                                                                          2.4,
                                                                      wordSpacing:
                                                                          2.4,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                              ),
                                                            ),
                                                            ListTile(
                                                              title: Text(
                                                                'Is Veg',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .labelLarge
                                                                    ?.copyWith(
                                                                      letterSpacing:
                                                                          2.4,
                                                                      wordSpacing:
                                                                          2.4,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                              ),
                                                              subtitle: Text(
                                                                category.isVeg ==
                                                                        true
                                                                    ? 'Yes'
                                                                    : 'No',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .labelLarge
                                                                    ?.copyWith(
                                                                      letterSpacing:
                                                                          2.4,
                                                                      wordSpacing:
                                                                          2.4,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                              ),
                                                            ),

                                                            /// culinaryUses
                                                            ListTile(
                                                              title: Text(
                                                                'Culinary Uses',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .labelLarge
                                                                    ?.copyWith(
                                                                      letterSpacing:
                                                                          2.4,
                                                                      wordSpacing:
                                                                          2.4,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                              ),
                                                              subtitle: Text(
                                                                category.culinaryUses ??
                                                                    '',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .labelLarge
                                                                    ?.copyWith(
                                                                      letterSpacing:
                                                                          2.4,
                                                                      wordSpacing:
                                                                          2.4,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                              ),
                                                            ),

                                                            /// safetyConsiderations
                                                            ListTile(
                                                              title: Text(
                                                                'Safety Considerations',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .labelLarge
                                                                    ?.copyWith(
                                                                      letterSpacing:
                                                                          2.4,
                                                                      wordSpacing:
                                                                          2.4,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                              ),
                                                              subtitle: Text(
                                                                category.safetyConsiderations ??
                                                                    '',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .labelLarge
                                                                    ?.copyWith(
                                                                      letterSpacing:
                                                                          2.4,
                                                                      wordSpacing:
                                                                          2.4,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            label: Text(
                                              ingredient.name ?? '',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall
                                                  ?.copyWith(
                                                    letterSpacing: 2.4,
                                                    wordSpacing: 2.4,
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onError,
                                                  ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),

                              Divider(
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
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
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.error,
                    ),
                children: [
                  TextSpan(
                    text: 'Report Issues',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        final uri = Uri.parse(
                          'mailto:ravikumar2710999@gmail.com?subject=Issue%20in%20RecipeX&body=Hey%20There!%0A%3CPlease%20write%20issue%20here%3E',
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
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
