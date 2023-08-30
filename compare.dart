import 'dart:convert';
import 'dart:io';

void main(List<String> args) {
  /// read recpices/x.json and recpices/countries.json

  final current = Directory.current;

  final x = File('${current.path}/recipes/x.json');
  final countries = File('${current.path}/recipes/countries.json');

  final recipesContent = x.readAsStringSync();
  final countriesContent = countries.readAsStringSync();

  final y = [];

  /// decode json
  final xJson = jsonDecode(recipesContent) as List<dynamic>;
  final countriesJson = jsonDecode(countriesContent) as List<dynamic>;

  for (var i = 0; i < countriesJson.length; i++) {
    var country = countriesJson[i];
    var code = country['code']?.toString();
    final xJsonFiltered = xJson.firstWhere((element) => element?['code'] == code,
        orElse: () => null);
    print(xJsonFiltered?['dial_code']);
    countriesJson[i]['dial'] = xJsonFiltered?['dial_code'];
    y.add(countriesJson[i]);
  }

  /// encode json
  final decoded = jsonEncode(y);

  /// write recpices/y.json
  final recipesY = File('${current.path}/recipes/y.json');
  recipesY.writeAsStringSync(decoded);
}
