import 'dart:async';

import 'package:recipe_x/app/app.dart';
import 'package:recipe_x/app/start.dart';

Future<void> main() async => await startApplication(() => const Application());
