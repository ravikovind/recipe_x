import 'dart:convert';
import 'package:flutter/foundation.dart';

_parseAndDecode(String response) => jsonDecode(response);

/// [parseJSON] is a function that takes a JSON [String] and parses the JSON string in background.
parseJSON(String text) => compute(_parseAndDecode, text);
