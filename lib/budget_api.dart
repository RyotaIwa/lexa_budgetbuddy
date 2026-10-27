import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'budget_model.dart';

class BudgetApi {
  // ==========================================
  // YOUR OWN JSON FILE
  // ==========================================

  static const String jsonPath = 'assets/budgetbuddy.json';

  // ==========================================
  // API GET REQUEST
  // ==========================================

  static const String apiUrl = 'https://dummyjson.com/products?limit=20';

  // ==========================================
  // LOAD YOUR OWN JSON PRODUCTS
  // ==========================================

  static Future<List<BudgetProduct>> getLocalProducts() async {
    try {
      final jsonString = await rootBundle.loadString(jsonPath);

      final data = jsonDecode(jsonString);

      final List<dynamic> products = data['products'] ?? [];

      return products
          .map(
            (product) =>
                BudgetProduct.fromJson(Map<String, dynamic>.from(product)),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to load BudgetBuddy JSON: $e');
    }
  }

  // ==========================================
  // GET PRODUCTS FROM API
  // ==========================================

  static Future<List<BudgetProduct>> getApiProducts() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode != 200) {
        throw Exception(
          'API request failed with status '
          '${response.statusCode}',
        );
      }

      final data = jsonDecode(response.body);

      final List<dynamic> products = data['products'] ?? [];

      return products.map((product) {
        return BudgetProduct(
          id: product['id'] ?? 0,

          name: product['title']?.toString() ?? 'Unknown Product',

          description:
              product['description']?.toString() ?? 'No description available.',

          category: product['category']?.toString() ?? 'General',

          price: product['price'] is num
              ? (product['price'] as num).toDouble()
              : 0.0,

          currency: 'USD',

          image: product['thumbnail']?.toString() ?? '',
        );
      }).toList();
    } catch (e) {
      throw Exception('Unable to connect to API: $e');
    }
  }
}
