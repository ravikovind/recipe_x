import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_x/bloc/category/category_bloc.dart';
// import 'package:recipe_x/bloc/country/country_bloc.dart';
import 'package:recipe_x/bloc/ingredient/ingredient_bloc.dart';
import 'package:recipe_x/bloc/recipe/recipe_bloc.dart';
import 'package:recipe_x/bloc/region/region_bloc.dart';
import 'package:recipe_x/core/routes/routes.dart';

import 'package:recipe_x/core/utils/extenstions.dart';
import 'package:recipe_x/data/entities/category.dart';
// import 'package:recipe_x/data/entities/country.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  final search = TextEditingController();
  final controller = ScrollController();

  final selectedIngredients = <String>[];
  final selectedRegions = <String>[];

  final selectedCategories = <String>[];
  final selectedCountries = <String>[];

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (controller.position.atEdge &&
          controller.position.pixels != 0 &&
          !context.read<RecipeBloc>().state.busy) {
        print(
          'at edge : ${controller.position} page: ${context.read<RecipeBloc>().state.page}',
        );
        context.read<RecipeBloc>().add(
              FilterRecipes(
                query: search.text,
                refresh: false,
                regions: selectedRegions,
                ingredients: selectedIngredients,
              ),
            );
      }
    });
  }

  @override
  void dispose() {
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ingredients = context.watch<IngredientBloc>().state.ingredients;
    final categories = context.watch<CategoryBloc>().state.categories;
    final regions = context.watch<RegionBloc>().state.regions;
    // final countries = context.watch<CountryBloc>().state.countries;
    // final regionCountriesMap = <String, List<Country>>{};
    // for (var region in regions) {
    //   final regionCountries = countries
    //       .where((country) =>
    //           region.countries
    //               ?.map((e) => e.toLowerCase())
    //               .any((e) => e.contains(country.name?.toLowerCase() ?? '')) ==
    //           true)
    //       .toList();
    //   regionCountriesMap[region.id ?? ''] = regionCountries;
    // }
    // final regionCountries = [
    //   ...regionCountriesMap.values.expand((element) => element)
    // ];
    /// veg ingredients only
    final veganIngredients =
        ingredients.where((element) => element.isVegan == true).toList();

    /// veg ingredients only
    final vegIngredients = ingredients
        .where((element) => element.isVeg == true && element.isVegan == false)
        .toList();

    /// non-veg ingredients only
    final nonVegIngredients = ingredients
        .where((element) => element.isVegan == false && element.isVeg == false)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: search,
          onChanged: (value) {
            if (value.isEmpty || context.read<RecipeBloc>().state.busy) {
              return;
            }
            context.read<RecipeBloc>().add(
                  FilterRecipes(
                    query: value,
                    refresh: true,
                    regions: selectedRegions,
                    ingredients: selectedIngredients,
                  ),
                );
          },
          decoration: const InputDecoration(
            hintText: 'Search',
            border: InputBorder.none,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(
                () {
                  search.clear();
                  context.read<RecipeBloc>().add(
                        const FilterRecipes(
                          refresh: true,
                        ),
                      );
                },
              );
            },
            icon: const Icon(Icons.clear),
          ),
          IconButton(
            onPressed: () {
              /// show filter options sheet
              showCupertinoModalPopup(
                context: context,
                builder: (context) => StatefulBuilder(builder: (context, set) {
                  return Scaffold(
                    appBar: AppBar(
                      title: Text(
                        'Filter Options',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              letterSpacing: 2.4,
                              wordSpacing: 2.4,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    body: ListView(
                      children: [
                        /// coutnries
                        // ListTile(
                        //   title: Text(
                        //     'Countries',
                        //     style: Theme.of(context)
                        //         .textTheme
                        //         .labelLarge
                        //         ?.copyWith(
                        //           letterSpacing: 2.4,
                        //           wordSpacing: 2.4,
                        //           fontWeight: FontWeight.bold,
                        //         ),
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 64,
                        //   child: ListView(
                        //     scrollDirection: Axis.horizontal,
                        //     children: [
                        //       ...regionCountries.map(
                        //         (e) => Padding(
                        //           padding: const EdgeInsets.all(4.0),
                        //           child: ChoiceChip(
                        //             selected:
                        //                 selectedCountries.contains(e.name),
                        //             onSelected: (value) {
                        //               set(() {
                        //                 if (selectedCountries
                        //                     .contains(e.name ?? '')) {
                        //                   selectedCountries.remove(e.name);
                        //                 } else {
                        //                   selectedCountries.add(e.name ?? '');
                        //                 }
                        //               });
                        //               context.read<RecipeBloc>().add(
                        //                     FilterRecipes(
                        //                       query: search.text,
                        //                       refresh: true,
                        //                       regions: selectedRegions,
                        //                       ingredients: selectedIngredients,
                        //                     ),
                        //                   );
                        //             },
                        //             backgroundColor:
                        //                 Theme.of(context).colorScheme.surface,
                        //             label: Text(
                        //               '${e.name ?? ''} (${e.code ?? ''} - ${e.emoji ?? ''})',
                        //               style: Theme.of(context)
                        //                   .textTheme
                        //                   .labelSmall
                        //                   ?.copyWith(
                        //                     letterSpacing: 2.4,
                        //                     wordSpacing: 2.4,
                        //                     fontWeight: FontWeight.bold,
                        //                     color: Theme.of(context)
                        //                         .colorScheme
                        //                         .secondary,
                        //                   ),
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),

                        ListTile(
                          title: Text(
                            'Regions',
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(
                                  letterSpacing: 2.4,
                                  wordSpacing: 2.4,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        SizedBox(
                          height: 64,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              ...regions.map(
                                (e) => Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: ChoiceChip(
                                    selected: selectedRegions.contains(e.id),
                                    onSelected: (value) {
                                      set(() {
                                        if (selectedRegions.contains(e.id)) {
                                          selectedRegions.remove(e.id);
                                        } else {
                                          selectedRegions.add(e.id ?? '');
                                        }
                                      });
                                      context.read<RecipeBloc>().add(
                                            FilterRecipes(
                                              query: search.text,
                                              refresh: true,
                                              regions: selectedRegions,
                                              ingredients: selectedIngredients,
                                            ),
                                          );
                                    },
                                    backgroundColor:
                                        Theme.of(context).colorScheme.surface,
                                    label: Text(
                                      e.name ?? '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            letterSpacing: 2.4,
                                            wordSpacing: 2.4,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // ///  ingredients category
                        // ListTile(
                        //   title: Text(
                        //     'Ingredients Category',
                        //     style: Theme.of(context)
                        //         .textTheme
                        //         .labelLarge
                        //         ?.copyWith(
                        //           letterSpacing: 2.4,
                        //           wordSpacing: 2.4,
                        //           fontWeight: FontWeight.bold,
                        //         ),
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: 64,
                        //   child: ListView(
                        //     scrollDirection: Axis.horizontal,
                        //     children: [
                        //       ...categories.map(
                        //         (e) => Padding(
                        //           padding: const EdgeInsets.all(4.0),
                        //           child: ChoiceChip(
                        //             selected: selectedCategories.contains(e.id),
                        //             onSelected: (value) {
                        //               set(() {
                        //                 if (selectedCategories.contains(e.id)) {
                        //                   selectedCategories.remove(e.id);
                        //                 } else {
                        //                   selectedCategories.add(e.id ?? '');
                        //                 }
                        //               });
                        //             },
                        //             backgroundColor:
                        //                 Theme.of(context).colorScheme.surface,
                        //             label: Text(
                        //               e.name ?? '',
                        //               style: Theme.of(context)
                        //                   .textTheme
                        //                   .labelSmall
                        //                   ?.copyWith(
                        //                     letterSpacing: 2.4,
                        //                     wordSpacing: 2.4,
                        //                     fontWeight: FontWeight.bold,
                        //                     color: Theme.of(context)
                        //                         .colorScheme
                        //                         .primary,
                        //                   ),
                        //             ),
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),

                        ListTile(
                          title: Text(
                            'Ingredients',
                            style: Theme.of(context)
                                .textTheme
                                .headlineLarge
                                ?.copyWith(
                                  letterSpacing: 2.4,
                                  wordSpacing: 2.4,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),

                        ///  ingredients vegan only
                        ListTile(
                          title: Text(
                            'Vegan Ingredients',
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
                        SizedBox(
                          height: 64,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              ...veganIngredients.map(
                                (e) => Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: ChoiceChip(
                                    selected: selectedIngredients
                                        .any((element) => element == e.id),
                                    onSelected: (value) {
                                      set(() {
                                        if (selectedIngredients
                                            .contains(e.id)) {
                                          selectedIngredients.remove(e.id);
                                        } else {
                                          selectedIngredients.add(e.id ?? '');
                                        }
                                      });
                                      context.read<RecipeBloc>().add(
                                            FilterRecipes(
                                              query: search.text,
                                              refresh: true,
                                              regions: selectedRegions,
                                              ingredients: selectedIngredients,
                                            ),
                                          );
                                    },
                                    backgroundColor:
                                        Theme.of(context).colorScheme.surface,
                                    label: Text(
                                      e.name ?? '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            letterSpacing: 2.4,
                                            wordSpacing: 2.4,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// ingredients veg only
                        ListTile(
                          title: Text(
                            'Veg Ingredients',
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
                        SizedBox(
                          height: 64,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              ...vegIngredients.map(
                                (e) => Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: ChoiceChip(
                                    selected: selectedIngredients
                                        .any((element) => element == e.id),
                                    onSelected: (value) {
                                      set(() {
                                        if (selectedIngredients
                                            .contains(e.id)) {
                                          selectedIngredients.remove(e.id);
                                        } else {
                                          selectedIngredients.add(e.id ?? '');
                                        }
                                      });
                                      context.read<RecipeBloc>().add(
                                            FilterRecipes(
                                              query: search.text,
                                              refresh: true,
                                              regions: selectedRegions,
                                              ingredients: selectedIngredients,
                                            ),
                                          );
                                    },
                                    backgroundColor:
                                        Theme.of(context).colorScheme.surface,
                                    label: Text(
                                      e.name ?? '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            letterSpacing: 2.4,
                                            wordSpacing: 2.4,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// ingredients non-veg only
                        ListTile(
                          title: Text(
                            'Non-Veg Ingredients',
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

                        SizedBox(
                          height: 64,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              ...nonVegIngredients.map(
                                (e) => Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: ChoiceChip(
                                    selected: selectedIngredients
                                        .any((element) => element == e.id),
                                    onSelected: (value) {
                                      set(() {
                                        if (selectedIngredients
                                            .contains(e.id)) {
                                          selectedIngredients.remove(e.id);
                                        } else {
                                          selectedIngredients.add(e.id ?? '');
                                        }
                                      });
                                      context.read<RecipeBloc>().add(
                                            FilterRecipes(
                                              query: search.text,
                                              refresh: true,
                                              regions: selectedRegions,
                                              ingredients: selectedIngredients,
                                            ),
                                          );
                                    },
                                    backgroundColor:
                                        Theme.of(context).colorScheme.surface,
                                    label: Text(
                                      e.name ?? '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            letterSpacing: 2.4,
                                            wordSpacing: 2.4,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// choosiing one ingredient means it's vegan but recipe can have non-vegan ingredients
                        ListTile(
                          title: Text(
                            'Choosiing one ingredient means it\'s vegan/veg/non-veg but recipe may have non-vegan/non-veg or veg/vegan ingredients, please check recipe details for more info!',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  letterSpacing: 2.4,
                                  wordSpacing: 2.4,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.error,
                                ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              );
            },
            icon: const Icon(Icons.more),
          ),
        ],
      ),
      body: BlocConsumer<RecipeBloc, RecipeState>(
        listenWhen: (previous, current) =>
            previous.error != current.error && current.error.isNotEmpty,
        listener: (context, state) {
          if (state.error.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final recipes = state.filteredRecipes;
          final busy = state.busy;

          if (busy && recipes.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (recipes.isNotEmpty) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: controller,
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];
                      final recipeIngredients = ingredients
                          .where((ingredient) =>
                              recipe.ingredients?.contains(ingredient.id) ==
                              true)
                          .toList();
                      return ListTile(
                        onTap: () {
                          context.pushNamed(kRecipeRoute, pathParameters: {
                            'recipe': recipe.id ?? '',
                          });
                        },
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
                                      .every(
                                          (element) => element.isVegan == true)
                                  ? Colors.green
                                  : ingredients
                                          .where((ingredient) =>
                                              recipe.ingredients
                                                  ?.contains(ingredient.id) ==
                                              true)
                                          .every((element) =>
                                              element.isVeg == true)
                                      ? Colors.green
                                      : Colors.red,
                            ),
                          ),
                        ),
                        title: Text(
                          recipe.name?.capitalizeAll ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        subtitle: Wrap(
                          children: [
                            Text(
                              recipe.description?.capitalizeAll ?? '',
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    letterSpacing: 2.4,
                                    wordSpacing: 2.4,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            ExpansionTile(
                              title: Text(
                                'Ingredients',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      letterSpacing: 2.4,
                                      wordSpacing: 2.4,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
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
                                                          style:
                                                              Theme.of(context)
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
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: ingredient
                                                                          .isVegan ==
                                                                      true
                                                                  ? Colors.green
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
                                                          style:
                                                              Theme.of(context)
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
                                                                            .onSurface,
                                                                        label:
                                                                            Text(
                                                                          e,
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .labelSmall
                                                                              ?.copyWith(
                                                                                letterSpacing: 2.4,
                                                                                wordSpacing: 2.4,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Theme.of(context).colorScheme.onError,
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
                                                                            .onSurface,
                                                                        label:
                                                                            Text(
                                                                          e,
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .labelSmall
                                                                              ?.copyWith(
                                                                                letterSpacing: 2.4,
                                                                                wordSpacing: 2.4,
                                                                                fontWeight: FontWeight.bold,
                                                                                color: Theme.of(context).colorScheme.onError,
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
                                                          style:
                                                              Theme.of(context)
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
                                                          ingredient.type ?? '',
                                                          style:
                                                              Theme.of(context)
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
                                                        initiallyExpanded: true,
                                                        title: Text(
                                                          'Categoriy Details',
                                                          style:
                                                              Theme.of(context)
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
                                                                  color: category
                                                                              .isVegan ==
                                                                          true
                                                                      ? Colors
                                                                          .green
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
                            )
                          ],
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      );
                    },
                  ),
                ),
                if (busy)
                  const SizedBox(
                    height: 64,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            );
          }

          return const Center(
            child: Text('Search amazing recipes here'),
          );
        },
      ),
    );
  }
}
