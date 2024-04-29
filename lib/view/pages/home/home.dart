import 'package:adaptive_screen_utils/adaptive_screen_utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_x/bloc/ingredient/ingredient_bloc.dart';
import 'package:recipe_x/bloc/recipe/recipe_bloc.dart';
import 'package:recipe_x/bloc/region/region_bloc.dart';
import 'package:recipe_x/core/routes/routes.dart';
import 'package:recipe_x/core/utils/extenstions.dart';
import 'package:recipe_x/data/entities/recipe.dart';
import 'package:recipe_x/data/entities/region.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:vector_graphics/vector_graphics.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('RecipeX'),
        actions: [
          IconButton(
            onPressed: () => context.goNamed(kSettingsRoute),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          primary: true,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Cooking Delicious Recipes is now easier than ever.',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          letterSpacing: 0.4,
                          wordSpacing: 0.4,
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
              height: 16,
            ),
            const RandomRecipes(),
            const SizedBox(
              height: 32.0,
            ),
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
                      const TextSpan(
                        text: ' in India🇮🇳 \n',
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
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: '© 2024 ',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                children: [
                  TextSpan(
                    text: 'Ravi Kovind',
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        final uri = Uri.parse(
                          'https://ravikovind.github.io/',
                        );

                        try {
                          launchUrl(uri);
                        } catch (e) {
                          throw 'There was an error trying to launch the URL: $uri';
                        }
                      },
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                          fontWeight: FontWeight.bold,
                        ),
                    children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          Icons.launch_rounded,
                          size: 16,
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 64.0),
          ],
        ),
      ),
    );
  }
}

class RandomRecipes extends StatefulWidget {
  const RandomRecipes({
    super.key,
  });

  @override
  State<RandomRecipes> createState() => _RandomRecipesState();
}

class _RandomRecipesState extends State<RandomRecipes>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 800,
      ),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _animation.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        BlocBuilder<RecipeBloc, RecipeState>(
          builder: (context, recipesState) {
            final tablet = medium(context);
            final desktop = expanded(context);
            final regions = context.watch<RegionBloc>().state.regions;
            final count = recipesState.recipes.length;
            final recipes = recipesState.randomRecipes;
            final busy = recipesState.busy;
            final svgs = recipesState.svgs;
            final ingredients =
                context.watch<IngredientBloc>().state.ingredients;
            final size = MediaQuery.of(context).size;
            final width = size.width;
            final height = size.height;
            final randomRecipe = recipesState.randomRecipe;
            return Column(
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Explore a collection of ${count <= 0 ? 'Counting...' : '$count'} recipes from around the world.',
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
                        (index) => ScaleTransition(
                          scale: _animation,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            width: desktop
                                ? width * 0.3
                                : tablet
                                    ? width * 0.45
                                    : width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: width,
                                  height: height * 0.25,
                                  child: SvgPicture(
                                    AssetBytesLoader(
                                      svgs[index],
                                    ),
                                    fit: BoxFit.fitWidth,
                                    clipBehavior: Clip.antiAlias,
                                  ),
                                ),
                                ListTile(
                                  contentPadding: const EdgeInsets.all(16),
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
                                        'Loading some random recipe for you to explore...',
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
                        ),
                      )
                    else
                      ...recipes.map(
                        (recipe) {
                          final index = recipes.indexOf(recipe);
                          final svg = Container(
                            width: width,
                            height: height * 0.25,
                            alignment: Alignment.center,
                            child: SvgPicture(
                              AssetBytesLoader(
                                svgs[index],
                              ),
                              fit: BoxFit.fitWidth,
                              clipBehavior: Clip.antiAlias,
                            ),
                          );
                          final region = regions.firstWhere(
                            (element) => element.id == recipe.region,
                            orElse: () => const Region(),
                          );

                          return ScaleTransition(
                            scale: _animation,
                            child: Container(
                              width: desktop
                                  ? width * 0.3
                                  : tablet
                                      ? width * 0.45
                                      : width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: randomRecipe.id == recipe.id
                                    ? Theme.of(context)
                                        .colorScheme
                                        .surfaceVariant
                                    : null,
                              ),
                              child: MouseRegion(
                                onHover: (event) {
                                  if (randomRecipe.id == recipe.id) return;
                                  context.read<RecipeBloc>().add(
                                        SelectRandomRecipe(
                                          recipe: recipe,
                                        ),
                                      );
                                },
                                onEnter: (event) {
                                  if (randomRecipe.id == recipe.id) return;
                                  context.read<RecipeBloc>().add(
                                        SelectRandomRecipe(
                                          recipe: recipe,
                                        ),
                                      );
                                },
                                onExit: (event) {
                                  if (randomRecipe.id == recipe.id) return;
                                  context.read<RecipeBloc>().add(
                                        const SelectRandomRecipe(
                                          recipe: Recipe(),
                                        ),
                                      );
                                },
                                child: GestureDetector(
                                  onTap: () => context
                                      .pushNamed(kRecipeRoute, pathParameters: {
                                    'recipe': recipe.id ?? '',
                                  }),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      svg,
                                      ListTile(
                                        contentPadding: const EdgeInsets.all(8),
                                        title: RichText(
                                          textAlign: TextAlign.start,
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: recipe
                                                        .name?.capitalizeAll ??
                                                    'Recipe',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headlineMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      decorationStyle:
                                                          TextDecorationStyle
                                                              .solid,
                                                      wordSpacing: 2.4,
                                                      letterSpacing: 2.4,
                                                    ),
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        ' (${region.name?.capitalizeAll ?? "World"})',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .headlineSmall
                                                        ?.copyWith(
                                                          letterSpacing: 2.4,
                                                          wordSpacing: 2.4,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Theme.of(context)
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
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              color: ingredients
                                                      .where((ingredient) =>
                                                          recipe.ingredients
                                                              ?.contains(
                                                                  ingredient
                                                                      .id) ==
                                                          true)
                                                      .every((element) =>
                                                          element.isVegan ==
                                                          true)
                                                  ? Colors.green
                                                  : ingredients
                                                          .where((ingredient) =>
                                                              recipe.ingredients
                                                                  ?.contains(
                                                                      ingredient
                                                                          .id) ==
                                                              true)
                                                          .every((element) =>
                                                              element.isVeg ==
                                                              true)
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
                                              recipe.description
                                                      ?.capitalizeAll ??
                                                  '',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => false;
}
