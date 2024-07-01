import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_x/bloc/category/category_bloc.dart';
import 'package:recipe_x/bloc/country/country_bloc.dart';
import 'package:recipe_x/bloc/ingredient/ingredient_bloc.dart';
import 'package:recipe_x/bloc/recipe/recipe_bloc.dart';
import 'package:recipe_x/bloc/region/region_bloc.dart';
import 'package:recipe_x/data/entities/category.dart';
import 'package:recipe_x/data/entities/recipe.dart';

import 'package:recipe_x/core/utils/extenstions.dart';
import 'package:recipe_x/data/entities/region.dart';
import 'package:url_launcher/url_launcher.dart';

class RecipePage extends StatelessWidget {
  const RecipePage({super.key, required this.recipe});
  final String recipe;

  @override
  Widget build(BuildContext context) {
    final recipeOf = context.select<RecipeBloc, Recipe>(
      (recipeBloc) => recipeBloc.state.recipes.firstWhere(
        (element) => element.id == recipe,
        orElse: () => const Recipe(),
      ),
    );

    final regions = context.watch<RegionBloc>().state.regions;
    final countries = context.watch<CountryBloc>().state.countries;
    final ingredients = context.watch<IngredientBloc>().state.ingredients;
    final categories = context.watch<CategoryBloc>().state.categories;
    final recipeIngredients = ingredients
        .where((ingredient) =>
            recipeOf.ingredients?.contains(ingredient.id) == true)
        .toList();
    final recipeRegion = regions.firstWhere(
      (element) => element.id == recipeOf.region,
      orElse: () => const Region(),
    );

    final regionCountries = countries
        .where((country) =>
            recipeRegion.countries?.map((e) => e.toLowerCase()).any(
                    (e) => e.contains(country.name?.toLowerCase() ?? '')) ==
                true ||
            country.name?.toLowerCase().contains(
                      recipeRegion.name?.toLowerCase() ?? '',
                    ) ==
                true)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          recipeOf.name?.capitalize ?? 'Recipe',
          maxLines: 2,
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final source = recipeOf.source?.replaceAll(' ', '+') ?? 'recipe';
              final name = recipeOf.name?.replaceAll(' ', '+') ?? 'recipe';
              final query = '$name+by+$source';
              final url = 'https://www.youtube.com/results?search_query=$query';
              final uri = Uri.parse(url);
              try {
                await launchUrl(
                  uri,
                  mode: LaunchMode.externalApplication,
                );
              } catch (_) {}
            },
            icon: Icon(
              Icons.play_arrow_rounded,
              color: Theme.of(context).colorScheme.error,
              size: 32,
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            trailing: Container(
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
                              recipeOf.ingredients?.contains(ingredient.id) ==
                              true)
                          .every((element) => element.isVegan == true)
                      ? Colors.green
                      : ingredients
                              .where((ingredient) =>
                                  recipeOf.ingredients
                                      ?.contains(ingredient.id) ==
                                  true)
                              .every((element) => element.isVeg == true)
                          ? Colors.green
                          : Colors.red,
                ),
              ),
            ),
            title: Text(
              recipeOf.name?.capitalizeAll ?? '',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            subtitle: Wrap(
              children: [
                Text(
                  recipeOf.description?.capitalizeAll ?? '',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        letterSpacing: 2.4,
                        wordSpacing: 2.4,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text(
              'It is a ${recipeRegion.name?.capitalizeAll ?? ''} recipe.',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    letterSpacing: 2.4,
                    wordSpacing: 2.4,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            subtitle: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Countries recipe is popular in : ',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          letterSpacing: 2.4,
                          wordSpacing: 2.4,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                ...regionCountries.map(
                  (e) => Chip(
                    backgroundColor: Theme.of(context).colorScheme.surface,
                    label: Text(
                      '${e.name ?? ''}[${e.emoji ?? ''}${e.code ?? ''}]',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
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
          ),
          ExpansionTile(
            title: Text(
              'Ingredients',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    letterSpacing: 2.4,
                    wordSpacing: 2.4,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            initiallyExpanded: true,
            children: [
              Wrap(
                runSpacing: 2,
                spacing: 2,
                children: [
                  ...recipeIngredients.map(
                    (ingredient) {
                      final category = categories.firstWhere(
                        (element) => element.id == ingredient.category,
                        orElse: () => const Category(),
                      );
                      return ExpansionTile(
                        title: Text(
                          ingredient.name ?? '',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    letterSpacing: 2.4,
                                    wordSpacing: 2.4,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                        ),
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                title: Text(
                                  'Ingredient Details : #${ingredient.name ?? ''}',
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
                                    margin: const EdgeInsets.all(2),
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: ingredient.isVegan == true
                                          ? Colors.green
                                          : ingredient.isVeg == true
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
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                dense: true,
                              ),
                              if (ingredient.synonyms?.isNotEmpty == true)
                                ListTile(
                                  title: Text(
                                    'Synonyms',
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  alignment: WrapAlignment.start,
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  runAlignment: WrapAlignment.start,
                                  children: [
                                    ...ingredient.synonyms
                                            ?.map(
                                              (e) => Chip(
                                                backgroundColor: Theme.of(
                                                        context)
                                                    .colorScheme
                                                    .surfaceContainerHighest,
                                                label: Text(
                                                  e,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelSmall
                                                      ?.copyWith(
                                                        letterSpacing: 2.4,
                                                        wordSpacing: 2.4,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ),
                                            )
                                            .toList() ??
                                        [],
                                  ],
                                ),
                              ),
                              if (ingredient.compounds?.isNotEmpty == true)
                                ListTile(
                                  title: Text(
                                    'Compounds',
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  alignment: WrapAlignment.start,
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  runAlignment: WrapAlignment.start,
                                  children: [
                                    ...ingredient.compounds
                                            ?.map(
                                              (e) => Chip(
                                                backgroundColor: Theme.of(
                                                        context)
                                                    .colorScheme
                                                    .surfaceContainerHighest,
                                                label: Text(
                                                  e,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .labelSmall
                                                      ?.copyWith(
                                                        letterSpacing: 2.4,
                                                        wordSpacing: 2.4,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .error,
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
                                        fontWeight: FontWeight.bold,
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
                                        fontWeight: FontWeight.bold,
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
                                        fontWeight: FontWeight.bold,
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
                                            letterSpacing: 2.4,
                                            wordSpacing: 2.4,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
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
                                        margin: const EdgeInsets.all(2),
                                        padding: const EdgeInsets.all(2),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: category.isVegan == true
                                              ? Colors.green
                                              : category.isVeg == true
                                                  ? Colors.green
                                                  : Colors.red,
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
                                            letterSpacing: 2.4,
                                            wordSpacing: 2.4,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    subtitle: Text(
                                      category.description ?? '',
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
                                  ListTile(
                                    title: Text(
                                      'Is Vegan',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(
                                            letterSpacing: 2.4,
                                            wordSpacing: 2.4,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    subtitle: Text(
                                      category.isVegan == true ? 'Yes' : 'No',
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
                                  ListTile(
                                    title: Text(
                                      'Is Veg',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(
                                            letterSpacing: 2.4,
                                            wordSpacing: 2.4,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    subtitle: Text(
                                      category.isVeg == true ? 'Yes' : 'No',
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
                                  ListTile(
                                    title: Text(
                                      'Culinary Uses',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(
                                            letterSpacing: 2.4,
                                            wordSpacing: 2.4,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    subtitle: Text(
                                      category.culinaryUses ?? '',
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
                                  ListTile(
                                    title: Text(
                                      'Safety Considerations',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(
                                            letterSpacing: 2.4,
                                            wordSpacing: 2.4,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    subtitle: Text(
                                      category.safetyConsiderations ?? '',
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
                                ],
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 16),
          if (recipeOf.source?.isNotEmpty == true)
            ListTile(
              title: Text(
                'Source: ',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      letterSpacing: 2.4,
                      wordSpacing: 2.4,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              subtitle: Wrap(
                children: [
                  Text(
                    recipeOf.source ?? 'No Source Found',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          letterSpacing: 2.4,
                          wordSpacing: 2.4,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                ],
              ),
              trailing: IconButton(
                onPressed: () async {
                  if (recipeOf.source?.isEmpty == true) return;
                  final uri = Uri.parse(
                    'https://google.com/search?q=${recipeOf.source}',
                  );
                  try {
                    await launchUrl(
                      uri,
                      mode: LaunchMode.externalApplication,
                    );
                  } catch (_) {}
                },
                icon: Icon(
                  Icons.open_in_new_rounded,
                  color: Theme.of(context).colorScheme.error,
                  size: 32,
                ),
              ),
            ),

        ],
      ),
    );
  }
}
