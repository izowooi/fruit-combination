import 'dart:convert';
import 'package:flutter/services.dart';

class FruitDataController {
  // Private constructor
  FruitDataController._privateConstructor();

  // The single instance of the class
  static final FruitDataController _instance = FruitDataController._privateConstructor();

  // Factory constructor to return the same instance
  factory FruitDataController() {
    return _instance;
  }
  
  // Map to hold Major Arcana interpretations
  late Map<String, String> majorArcanaWealth;

  // Map to hold Major Arcana names
  late Map<String, String> majorArcanaNames;

  // List of suits for Minor Arcana
  final List<String> suits = ["Wands", "Cups", "Swords", "Pentacles"];

  // Initialization function
  Future<void> initialize() async {
    // Load JSON files
    // final wealthData = await _loadJsonFile('assets/tarot_data/major_arcana_wealth.json');

    // // Populate maps
    // majorArcanaWealth = Map<String, String>.from(wealthData);
    // majorArcanaNames = Map<String, String>.from(namesData);
  }

  // Function to load a JSON file
  Future<Map<String, dynamic>> _loadJsonFile(String path) async {
    final String jsonString = await rootBundle.loadString(path);
    return jsonDecode(jsonString);
  }

  String getYearlyInterpretation(String cardIndex, int index) {
    return "";
  }
  String getFruitName(String cardIndex) {
    return "";
  }
}