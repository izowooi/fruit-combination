import 'dart:convert';
import 'package:flutter/services.dart';

class Fruit {
  final int index;
  final String name;
  final String party;
  final String committee;
  final String region;
  final String times;
  final String election;
  final String enName;
  final bool d1207;

  Fruit({
    required this.index,
    required this.name,
    required this.party,
    required this.committee,
    required this.region,
    required this.times,
    required this.election,
    required this.enName,
    required this.d1207,
  });

  factory Fruit.fromJson(Map<String, dynamic> json) {
    return Fruit(
      index: json['index'],
      name: json['name'],
      party: json['party'],
      committee: json['committee'],
      region: json['region'],
      times: json['times'],
      election: json['election'],
      enName: json['en_name'], // JSON 키가 en_name임에 주의
      d1207: json['d1207'],
    );
  }

  @override
  String toString() {
    return 'Fruit{index: $index, name: $name, party: $party, committee: $committee, region: $region, times: $times, election: $election, enName: $enName, d1207: $d1207}';
  }
}

class FruitDataController {
  // Private constructor
  FruitDataController._privateConstructor();

  // The single instance of the class
  static final FruitDataController _instance = FruitDataController._privateConstructor();

  // Factory constructor to return the same instance
  factory FruitDataController() {
    return _instance;
  }

  // Map to hold Fruit objects
  late Map<int, Fruit> fruitMap;

  // Initialization function
  Future<void> initialize() async {
    final List<dynamic> fruitDataList = await _loadJsonFile('assets/fruit_data/fruit.json');
    fruitMap = {
      for (var fruit in fruitDataList)
        fruit['index']: Fruit.fromJson(fruit as Map<String, dynamic>)
    };

    // Debug log to verify the data
    print(fruitMap[1]);
  }

  // Function to load a JSON file
  Future<List<dynamic>> _loadJsonFile(String path) async {
    final String jsonString = await rootBundle.loadString(path);
    return jsonDecode(jsonString);
  }

  String getFruitName(int index) {
    return fruitMap[index]?.name ?? "Unknown";
  }
}