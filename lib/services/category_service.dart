import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';

class CategoryService {
  static const String baseUrl = 'http://192.168.1.118:5000/api';
  static const String endpoint = '/categories';

  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Future<List<Category>> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      print('Error fetching categories: $e');
      return [];
    }
  }

  static Future<Category> addCategory(Category category) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: json.encode(category.toJson()),
      );

      if (response.statusCode == 201) {
        return Category.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to add category');
      }
    } catch (e) {
      print('Error adding category: $e');
      throw Exception('Failed to add category: $e');
    }
  }
}
