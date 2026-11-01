import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/recipe.dart';

/// Загружает рецепты из assets/recipes.json и проверяет структуру файла.
Future<List<Recipe>> loadRecipes() async {
  const assetPath = 'assets/recipes.json';
  final jsonString = await rootBundle.loadString(assetPath);
  final decoded = jsonDecode(jsonString);

  if (decoded is! List) {
    throw const FormatException(
      'Файл assets/recipes.json должен содержать JSON-массив.',
    );
  }

  final result = <Recipe>[];
  for (var index = 0; index < decoded.length; index++) {
    final item = decoded[index];
    if (item is! Map) {
      throw FormatException('Рецепт №${index + 1} должен быть JSON-объектом.');
    }
    final recipe = Recipe.fromJson(Map<String, dynamic>.from(item));
    if (recipe.title.trim().isEmpty) {
      throw FormatException('У рецепта №${index + 1} не заполнено название.');
    }
    result.add(recipe);
  }

  if (result.isEmpty) {
    throw const FormatException('В файле пока нет ни одного рецепта.');
  }

  return result;
}
