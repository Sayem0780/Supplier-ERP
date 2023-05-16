import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/product.dart';

class Sale with ChangeNotifier {
  late final dynamic userId;
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }
  List<Product> parseProducts(String responseBody) {
    final Map<String, dynamic> parsed = jsonDecode(responseBody);
    // List<Product> products = [];
    _items.clear();
    parsed.forEach((key, value) {
      _items.add(Product.fromJson(value));
    });
    notifyListeners();
    return _items;
  }


  Future<List<Product>> fetchProducts() async {
    final response = await http.get(Uri.parse('https://ustad-f34a1-default-rtdb.firebaseio.com/Stock%20Register.json'));

    if (response.statusCode == 200) {
      return parseProducts(response.body);
    } else {
      throw Exception('Failed to fetch products');
    }
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }
}
