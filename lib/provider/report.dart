import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:supplier_erp/model/details.dart';
import 'package:supplier_erp/model/memo.dart';
import '../model/report.dart';

class Report with ChangeNotifier {

  List<Details> _qdetails = [];

  List<Details> get qdetails => _qdetails;

  List<Item> _qitems = [];

  List<Item> get qitems => _qitems;

  List<Details> _bdetails = [];

  List<Details> get bdetails => _bdetails;

  List<Item> _bitems = [];

  List<Item> get bitems => _bitems;

  List<Details> _cdetails = [];

  List<Details> get cdetails => _cdetails;

  List<Item> _citems = [];

  List<Item> get citems => _citems;

  List<Memo> _mdetails = [];

  List<Memo> get mdetails => _mdetails;

  Future<List<Details>> fetchCD() async {
    final response = await http.get(Uri.parse('https://ustad-f34a1-default-rtdb.firebaseio.com/Calan.json'));
    if (response.statusCode == 200) {
      _cdetails.clear();
      final data = json.decode(response.body);
      for(var i in data.values){
        _cdetails.add(
            Details(
                date: i['details']['qdate'].toString(),
                name: i['details']['quserName'].toString(),
                address: i['details']['quserAddress'].toString(),
                Conditions:i['details']['quserCondition'].toString(),
                phone: i['details']['quserPhone'].toString(),
                code: i['details']['qcode'].toString(),
                prpo: i['details']['qPrpo'].toString(),
                root: i['details']['qRoot'].toString(),
              due: '',
            ));
      }
      notifyListeners();
      return _cdetails;
    } else {
      throw Exception('Failed to fetch order');
    }

  }

  Future<List<Item>> fetchCI() async {
    final response = await http.get(Uri.parse('https://ustad-f34a1-default-rtdb.firebaseio.com/Calan.json'));
    print('Quotation');
    if (response.statusCode == 200) {
      print(response.statusCode.toString());
      _citems.clear();
      final data = json.decode(response.body);
      for(var order in data.values){
        for(var i in order['itemList']){
          print('hhdd');
          print(i['qitemTitle'].toString());

          _citems.add(
              Item(
                  qitemId: i['qitemId'].toString(),
                  qitemPrice: i['qitemPrice'].toString(),
                  qitemQuantity: i['qitemQuantity'].toString(),
                  qitemStock: i['qitemStock'].toString(),
                  qitemTitle: i['qitemTitle'].toString(),
                  qitemTotalPrice: i['qitemTotalPrice'].toString(),
                  qitemUom: i['qitemUom'].toString()
              )
          );
        }
      }
      notifyListeners();
      return _citems;
    } else {
      throw Exception('Failed to fetch order');
    }

  }

  Future<List<Details>> fetchBD() async {
    final response = await http.get(Uri.parse('https://ustad-f34a1-default-rtdb.firebaseio.com/Bill.json'));
    if (response.statusCode == 200) {
      _bdetails.clear();
      final data = json.decode(response.body);
      for(var i in data.values){
        _bdetails.add(
            Details(
                date: i['details']['qdate'].toString(),
                name: i['details']['quserName'].toString(),
                address: i['details']['quserAddress'].toString(),
                Conditions:i['details']['quserCondition'].toString(),
                phone: i['details']['quserPhone'].toString(),
                code: i['details']['qcode'].toString(),
                prpo: i['details']['qPrpo'].toString(),
                root: i['details']['qRoot'].toString(),
              due: i['details']['due'].toString()
            ));
      }
      notifyListeners();
      return _bdetails;
    } else {
      throw Exception('Failed to fetch order');
    }

  }

  Future<List<Item>> fetchBI() async {
    final response = await http.get(Uri.parse('https://ustad-f34a1-default-rtdb.firebaseio.com/Bill.json'));
    print('Quotation');
    if (response.statusCode == 200) {
      print(response.statusCode.toString());
      _bitems.clear();
      final data = json.decode(response.body);
      for(var order in data.values){
        for(var i in order['itemList']){
          print('hhdd');
          print(i['qitemTitle'].toString());

          _bitems.add(
              Item(
                  qitemId: i['qitemId'].toString(),
                  qitemPrice: i['qitemPrice'].toString(),
                  qitemQuantity: i['qitemQuantity'].toString(),
                  qitemStock: i['qitemStock'].toString(),
                  qitemTitle: i['qitemTitle'].toString(),
                  qitemTotalPrice: i['qitemTotalPrice'].toString(),
                  qitemUom: i['qitemUom'].toString()
              )
          );
        }
      }
      notifyListeners();
      return _bitems;
    } else {
      throw Exception('Failed to fetch order');
    }

  }

  Future<List<Details>> fetchQD() async {
    final response = await http.get(Uri.parse('https://ustad-f34a1-default-rtdb.firebaseio.com/Quotation.json'));
    if (response.statusCode == 200) {
       _qdetails.clear();
       final data = json.decode(response.body);
       for(var i in data.values){
         _qdetails.add(
             Details(
                 date: i['details']['qdate'].toString(),
                 name: i['details']['quserName'].toString(),
                 address: i['details']['quserAddress'].toString(),
                 Conditions:i['details']['quserCondition'].toString(),
                 phone: i['details']['quserPhone'].toString(),
                 code: i['details']['qcode'].toString(),
                 prpo: i['details']['qPrpo'].toString(),
                 root: i['details']['qRoot'].toString(),
               due: '',
             ));
       }
       notifyListeners();
      return _qdetails;
    } else {
      throw Exception('Failed to fetch order');
    }

  }

  Future<List<Item>> fetchQI() async {
    final response = await http.get(Uri.parse('https://ustad-f34a1-default-rtdb.firebaseio.com/Quotation.json'));
    print('Quotation');
    if (response.statusCode == 200) {
      print(response.statusCode.toString());
      _qitems.clear();
      final data = json.decode(response.body);
      for(var order in data.values){
        for(var i in order['itemList']){
          print('hhdd');
          print(i['qitemTitle'].toString());

          _qitems.add(
              Item(
                  qitemId: i['qitemId'].toString(),
                  qitemPrice: i['qitemPrice'].toString(),
                  qitemQuantity: i['qitemQuantity'].toString(),
                  qitemStock: i['qitemStock'].toString(),
                  qitemTitle: i['qitemTitle'].toString(),
                  qitemTotalPrice: i['qitemTotalPrice'].toString(),
                  qitemUom: i['qitemUom'].toString()
              )
          );
        }
      }
      notifyListeners();
      return _qitems;
    } else {
      throw Exception('Failed to fetch order');
    }

  }
  Future<List<Memo>> fetchMD() async {
    final response = await http.get(Uri.parse('https://ustad-f34a1-default-rtdb.firebaseio.com/Accounts.json'));
    if (response.statusCode == 200) {
      _mdetails.clear();
      final data = json.decode(response.body);
      for(var i in data.values){
        _mdetails.add(
          Memo(date: i['issueDate'].toString(), name: i['companyName'].toString(), billNo: i['billNo'].toString(), memoNo: i['memoNo'].toString(), recieved: i['cashRecive'].toString(), due: i['due'].toString(),checkNo: i['checkNo'],totalPrice: i['totalPrice'],totalQuantity: i['totalQuantity'] )
        );
      }
      notifyListeners();
      return _mdetails;
    } else {
      throw Exception('Failed to fetch Cash Memo');
    }

  }

}
