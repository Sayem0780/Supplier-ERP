import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:supplier_erp/model/stockIn.dart';
import '../model/ledger.dart';
import 'package:http/http.dart' as http;

class Accounts with ChangeNotifier{
  List<Ledger> _account = [];
  List<StockIn> _stockIn = [];
  List<StockIn>  get stockIn{
    return _stockIn;
}
  Map<String, List<Ledger>> map1 = {};

  Map<String,List<Ledger>> getAccountsByDate(){
    map1.clear();
    _account.forEach((element) {
      String date = element.issueDate;

      if(!map1.containsKey(date)){
        map1[date] = [element];
      }else{
        map1[date]!.add(element);
      }
    });
    return map1;
  }

  List<Ledger> parseAccounts(String responseBody) {
    final Map<String, dynamic> parsed = jsonDecode(responseBody);
    _account.clear();
    parsed.forEach((key, value) {
      _account.add(Ledger.fromJson(value));
    });
    notifyListeners();
    return _account;
  }

  Future<List<Ledger>> fetchAccounts() async {
    final response = await http.get(Uri.parse('https://ustad-f34a1-default-rtdb.firebaseio.com/Accounts.json'));

    if (response.statusCode == 200) {
      return parseAccounts(response.body);
    } else {
      throw Exception('Failed to fetch accounts');
    }
  }

  List<StockIn> parseStockIn(String responseBody) {
    final Map<String, dynamic> parsed = jsonDecode(responseBody);
    _stockIn.clear();
    parsed.forEach((key, value) {
      _stockIn.add(StockIn.fromJson(value));
    });
    notifyListeners();
    return _stockIn;
  }

  Future<List<StockIn>> fetchStockIn() async {
    final response = await http.get(Uri.parse('https://ustad-f34a1-default-rtdb.firebaseio.com/Accounts.json'));

    if (response.statusCode == 200) {
      return parseStockIn(response.body);
    } else {
      throw Exception('Failed to fetch accounts');
    }
  }

}