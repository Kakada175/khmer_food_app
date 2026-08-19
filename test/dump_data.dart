import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import '../lib/app/data/providers/mock_data_provider.dart';

void main() {
  test('dump mock data to json', () {
    print('Extracting categories...');
    final categoriesJson = MockDataProvider.categories.map((c) => c.toJson()).toList();

    print('Extracting provinces...');
    final provincesJson = MockDataProvider.provinces.map((p) => p.toJson()).toList();

    print('Extracting foods...');
    final foodsJson = MockDataProvider.foods.map((f) => f.toJson()).toList();

    final dir = Directory('backend_seed_data');
    if (!dir.existsSync()) {
      dir.createSync();
    }

    print('Writing categories.json...');
    File('backend_seed_data/categories.json').writeAsStringSync(jsonEncode(categoriesJson));

    print('Writing provinces.json...');
    File('backend_seed_data/provinces.json').writeAsStringSync(jsonEncode(provincesJson));

    print('Writing foods.json...');
    File('backend_seed_data/foods.json').writeAsStringSync(jsonEncode(foodsJson));

    print('Successfully dumped seed data to backend_seed_data/ directory!');
  });
}
