import 'package:flutter/material.dart';
import 'package:supplier_erp/model/register.dart';

class CartItem {
  final String id;
  final String uom;
  final String title;
  final double price;
  final int stock;
  final int quantity;
  double totalprice;

  CartItem({
    required this.id,
    required this.uom,
    required this.title,
    required this.price,
    required this.stock,
    required this.quantity,
    required this.totalprice,
  }
  );
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _selectedItems = {};
  Map<String, CartItem> get selectedItems {
    return _selectedItems;
  }
  List<Register> register =[];


  int get totalAmount{
    int total = 0;
    _selectedItems.forEach((key, CartItem) {
      total = (total+ CartItem.totalprice!).ceil();
    });
   return total;
  }


  int get totalItem{
    int total = 0;
    _selectedItems.forEach((key, CartItem) {
      total = (total+ CartItem.quantity);
    });
    return total;
  }

  addItem(
      String pid,
      String ptitle,
      String puom,
      double pprice,
      int pstock,
      int pquantity,
      double totalprice,
  ) {
    if (_selectedItems.containsKey(pid)) {
      _selectedItems.update(pid, (value) {
        return CartItem(
            id: value.id,
            uom: puom,
            title: value.title,
            price: pprice,
            stock: pstock,
            quantity: pquantity,
          totalprice: pprice*pquantity,
        );
      });
    }else{

      _selectedItems.putIfAbsent(pid, () => CartItem(id: pid,uom: puom, title: ptitle, price: pprice,stock: pstock, quantity: pquantity,totalprice: pprice*pquantity));
    }
    notifyListeners();
  }
  removeSingleItem(String id){
    _selectedItems.remove(id);
    notifyListeners();
  }
  void clear(){
    _selectedItems = {};
    notifyListeners();
  }
}
