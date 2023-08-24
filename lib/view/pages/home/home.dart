import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RecipeX'),
        actions: [
          /// search
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      body: Container(
        color: Theme.of(context).colorScheme.primary,
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
              'A collection of 47,000+ recipes from around the world. along with their ingredients, country of origin, and region.',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
      
            /// Lottie Animation
            /// assets\lotties\dinner.json
      
          
      
            Text(
              'It\'s free and open source. you can find the source code on GitHub.',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
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
