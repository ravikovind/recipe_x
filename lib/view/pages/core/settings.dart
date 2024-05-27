import 'package:adaptive_screen_utils/adaptive_screen_utils.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_x/bloc/theme/theme_bloc.dart';
import 'package:recipe_x/core/utils/extenstions.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final mobile = compact(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        children: [
          ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: Text(
              'Theme',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            leading: Icon(
              Icons.color_lens,
              color: Theme.of(context).colorScheme.primary,
            ),
            childrenPadding: EdgeInsets.zero,
            children: ThemeMode.values
                .map(
                  (mode) => RadioListTile<ThemeMode>(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      mode.name.capitalize,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    value: mode,
                    groupValue: context.read<ThemeBloc>().state,
                    onChanged: (value) {
                      if (value == null) return;
                      context.read<ThemeBloc>().add(SetTheme(themeMode: value));
                    },
                  ),
                )
                .toList(),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              Icons.info,
              color: Theme.of(context).colorScheme.primary,
            ),
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
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              Icons.privacy_tip,
              color: Theme.of(context).colorScheme.primary,
            ),
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
              Icons.mail,
              color: Theme.of(context).colorScheme.primary,
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            onTap: () async {
              final uri = Uri.parse(
                'https://ravikovind.github.io/recipe_x/',
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Link Copied to Clipboard:\n$uri'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
              await Clipboard.setData(ClipboardData(text: '$uri'));
            },
            title: Text(
              'Share RecipeX',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            leading: Icon(
              Icons.share,
              color: Theme.of(context).colorScheme.primary,
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
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
          if (!kIsWeb)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.language,
                color: Theme.of(context).colorScheme.error,
              ),
              onTap: () async {
                final uri = Uri.parse('https://ravikovind.github.io/recipe_x/');
                try {
                  await launchUrl(uri);
                } catch (_) {
                  throw 'Something went wrong!';
                }
              },
              title: Text(
                'https://ravikovind.github.io/recipe_x/',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.error,
                    ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
          const SizedBox(
            height: 16,
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
            subtitle: RichText(
              text: TextSpan(
                text:
                    'Legal & Open Source Licenses: RecipeX is based on data from CulinaryDB, which is licensed under Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License. RecipeX is licensed under MIT License.',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                children: [
                  const TextSpan(
                    text: '\nYou can find the source code here: ',
                  ),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: IconButton(
                      onPressed: () async {
                        final uri = Uri.parse(
                          'https://github.com/ravikovind/recipe_x/',
                        );
                        try {
                          await launchUrl(uri);
                        } catch (_) {
                          throw 'Something went wrong!';
                        }
                      },
                      icon: Icon(
                        Icons.launch_rounded,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: RichText(
              textAlign: mobile ? TextAlign.start : TextAlign.center,
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
                          color: Theme.of(context).colorScheme.error,
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
                  const TextSpan(
                    text: '.\n',
                  ),
                  TextSpan(
                    text: 'For any queries, you can contact ',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                    children: [
                      TextSpan(
                        text: 'Dr. Ganesh Bagler',
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            final uri = Uri.parse(
                              'mailto:bagler+CulinaryDB@iiitd.ac.in'
                              '?subject=Query%20Regarding%20CulinaryDB&body=Hey%20There!%0A%3CPlease%20write%20your%20query%20here%3E',
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
                      const TextSpan(
                        text: '.\n',
                      ),
                      TextSpan(
                        text:
                            'Center for Computational Biology\nIndraprastha Institute of Information Technology Delhi (IIIT Delhi),\nOkhla Phase III, Near Govindpuri Metro Station,\nNew Delhi, India 110020.\nEmail: bagler+CulinaryDB@iiitd.ac.in',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                      const TextSpan(
                        text: '.\n',
                      ),
                      TextSpan(
                        text: 'Tel: +91-11-26907-443 (Work)',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          RichText(
            textAlign: mobile ? TextAlign.start : TextAlign.center,
            text: TextSpan(
              text:
                  'Some of ingredients data is taken from AI, it may not be accurate. based on that, the app may not be accurate as well. if you find any mistakes, please report it.\ndeciding the recipe is going to be vegan or vegetarian is based on the ingredients, not the recipe itself. so, it may not be accurate. please check before cooking.\n\n',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                    fontWeight: FontWeight.w200,
                  ),
              children: [
                TextSpan(
                  text:
                      'Illustrations are just for showcase, they don\'t represent the actual recipe, ingredients etc.',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                        fontWeight: FontWeight.w200,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32.0),
          Text(
            'RecipeX v2.0.0',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: '© 2024 ',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
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
          const SizedBox(
            height: 64,
          ),
        ],
      ),
    );
  }
}
