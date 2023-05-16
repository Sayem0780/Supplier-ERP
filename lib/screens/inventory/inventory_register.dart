import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplier_erp/model/product.dart';

import '../../provider/sale.dart';

class InventoryRegister extends StatefulWidget {
  static const routeName = 'inventory register';
  const InventoryRegister({Key? key}) : super(key: key);

  @override
  State<InventoryRegister> createState() => _InventoryRegisterState();
}

class _InventoryRegisterState extends State<InventoryRegister> {
  bool _isLoading = true;
  List<Product> _allProducts = [];
  List<Product> _foundProducts = [];
  int _selectedIndex = 0;
  static const List<String> _titles = ['Stock', 'Stock Out'];
  String _searchKeyword = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadProducts();
  }

  void _loadProducts() async {
    final store = Provider.of<Sale>(context, listen: true);
    _allProducts = await store.fetchProducts();
    _runFilter(_searchKeyword); // Apply the filter after loading products
    setState(() {
      _isLoading = false;
    });
  }

  void _runFilter(String enteredKeyword) {
    setState(() {
      _searchKeyword = enteredKeyword; // Store the entered keyword
      if (enteredKeyword.isEmpty) {
        if (_selectedIndex == 0) {
          _foundProducts = _allProducts;
        } else if (_selectedIndex == 1) {
          _foundProducts =
              _allProducts.where((product) => product.stock < 1).toList();
        }
      } else {
        if (_selectedIndex == 0) {
          _foundProducts = _allProducts
              .where((product) =>
              product.title.toLowerCase().contains(enteredKeyword.toLowerCase()))
              .toList();
        } else if (_selectedIndex == 1) {
          _foundProducts = _allProducts
              .where((product) =>
          product.stock < 1 &&
              product.title.toLowerCase().contains(enteredKeyword.toLowerCase()))
              .toList();
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory Register'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight / 1.25),
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Container(
                margin: EdgeInsets.only(left: 8),
                height: (MediaQuery.of(context).size.height / 20),
                width: (MediaQuery.of(context).size.width -
                    (MediaQuery.of(context).size.width / 50)),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: (value) {
                      _runFilter(value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Search',
                      suffixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding:
                      EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _foundProducts.isEmpty
          ? Center(
        child: Text('No Product Found'),
      )
          : SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: Text(('NO').toString(),
                  style: TextStyle(fontSize: 20)),
              title: Text('Name', style: TextStyle(fontSize: 20)),
              trailing: Text('Stock', style: TextStyle(fontSize: 20)),
            ),
            Container(
              height: MediaQuery.of(context).size.height * .8,
              child: ListView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                children: _foundProducts.asMap().entries.map((entry) {
                  final index = entry.key;
                  final product = entry.value;
                  final id = entry.value.id;
                  return ProductListItem(
                    serialNumber: index + 1,
                    product: product,
                    id: id,
                    index: _selectedIndex,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: _titles[0],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: _titles[1],
          ),
        ],
      ),
    );
  }
}

class ProductListItem extends StatefulWidget {
  final int serialNumber;
  final Product product;
  final String id;
  final int index;

  const ProductListItem(
      {required this.serialNumber, required this.product, required this.id,required this.index});

  @override
  _ProductListItemState createState() => _ProductListItemState();
}

class _ProductListItemState extends State<ProductListItem> {
  int? newStock;
  double? newPrice;


  Future<void> _updateProduct() async {
    if (newStock != null && newPrice != null) {
      // TODO: update the product with newStock and newPrice
      // ..
      String stock = widget.id.toString() + '/pStock';
      String price = widget.id.toString() + '/pPrice';
      final _postref = FirebaseDatabase.instance.ref.call("Stock Register");
      _postref.child(stock.toString()).set(
        newStock,
      );
      _postref.child(price.toString()).set(
        newPrice,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product updated'),
        ),
      );
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter new stock and price'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      elevation: 2,
      child: ListTile(
        leading: Text(
          widget.serialNumber.toString(),
          style: TextStyle(fontSize: 20),
        ),
        title: Text(widget.product.title.toString()),
        subtitle: GestureDetector(
          onTap: () {
            setState(() {
              newStock = widget.product.stock;
              newPrice = widget.product.price;
            });
          },
          child: newStock != null && newPrice != null
              ? Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 100,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'New stock',
                        hintText: widget.product.stock.toString(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          newStock = int.tryParse(value);
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: 100,
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'New price',
                        hintText: widget.product.price.toString(),
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          newPrice = double.tryParse(value);
                        });
                      },
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  _updateProduct().then((value) {
                    setState(() {
                      newStock = null;
                      newPrice = null;
                    });
                  });
                },
                child: Text('Update'),
              ),
            ],
          )
              : Text(
            'Update',
            style: TextStyle(color: Theme.of(context).primaryColorDark),
          ),
        ),
        trailing: Text(widget.product.stock.toString()),
      ),
    );
  }
}
