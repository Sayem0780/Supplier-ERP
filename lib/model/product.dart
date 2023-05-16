import 'dart:convert';
import 'package:flutter/foundation.dart';
class Product with ChangeNotifier{
  final String id;
  final String title;
  final String uom;
  final int stock;
  final double price;

  Product({
    required this.id,
    required this.title,
    required this.uom,
    required this.stock,
    required this.price,
  });
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['pId'].toString(),
      title: json['pTitle'],
      uom: json['pUom'].toString(),
      price: double.parse((json['pPrice']).toString()),
      stock: int.parse((json['pStock']).toString()),
    );
  }

}
