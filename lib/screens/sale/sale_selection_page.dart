import 'package:flutter/material.dart';
import 'package:supplier_erp/model/product.dart';
import 'package:provider/provider.dart';
import 'package:supplier_erp/provider/cart.dart';
import 'package:supplier_erp/provider/sale.dart';
import 'package:supplier_erp/screens/sale/bill/bill_page.dart';
import 'package:supplier_erp/screens/sale/quotation/qutation_page.dart';

import 'calan/calan_page.dart';

class SaleSelectionPage extends StatefulWidget {

  static const routeName = '/salepage';

  const SaleSelectionPage({Key? key}) : super(key: key);

  @override
  State<SaleSelectionPage> createState() => _SaleSelectionPageState();
}

class _SaleSelectionPageState extends State<SaleSelectionPage> {
  @override
  Widget build(BuildContext context) {
    print('Sale Selection');
    final store = Provider.of<Sale>(context, listen: false);
    store.fetchProducts();
    final cart = Provider.of<Cart>(context);
    final String argument = ModalRoute.of(context)!.settings.arguments as String;

    void _runFilter(String enteredKeyword) {
      setState(() {
        final allUsers = store.items;
        if (enteredKeyword.isEmpty) {
          _foundRes = allUsers;
        } else {
          _foundRes = allUsers
              .where((user) =>
              user.title
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()))
              .toList();
        }
      });
    }

    return Scaffold(
      appBar: cart.selectedItems.isNotEmpty?AppBar(
        leading: IconButton(onPressed: (){
          cart.clear();
        }, icon: Icon(Icons.clear)),
        title: ListTile(
          title: Text('Selected Item'+' ( '+ cart.selectedItems.length.toString() +' )',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,),),
          trailing: IconButton(onPressed: (){
            if(argument == 'q'){Navigator.of(context).pushNamed(QutationPage.routeName);}else if(argument=='c'){Navigator.of(context).pushNamed(CalanPage.routeName);}else{
              Navigator.of(context).pushNamed(BillPage.routeName);
            }

          },icon: Icon(Icons.navigate_next_sharp,size: 35,color: Colors.white,),),
        ),
        centerTitle: true,
      ):AppBar(
       title: Text(
          'Sale',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  _runFilter(value);
                },
                decoration: const InputDecoration(
                  labelText: 'Search',
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height*.8,
              width: 950,
              child: ListView.builder(
                itemCount: _foundRes.length,
                itemBuilder: (ctx, i) {
                  return GestureDetector(
                    onTap: (){
                      cart.addItem(_foundRes[i].id, _foundRes[i].title,_foundRes[i].uom, _foundRes[i].price,_foundRes[i].stock,1,_foundRes[i].price);
                    },
                    child: cart.selectedItems[_foundRes[i].id]?.quantity == 1?Card(
                      color: Colors.purpleAccent,
                      margin: EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 5,
                      ),
                      elevation: 2,
                      child: ListTile(
                        leading: Text((i + 1).toString(),style: TextStyle(fontSize: 20),),
                        title: Text(_foundRes[i].title.toString()),
                        trailing: GestureDetector(
                            onTap: (){
                              cart.removeSingleItem(_foundRes[i].id.toString());
                            },
                            child: Icon(Icons.check_box_outlined,color: Colors.white70,size: 25,)),
                      ),
                    ):
                    Card(
                      margin:
                      EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      elevation: 2,
                      child: ListTile(
                        leading: Text((i + 1).toString(),style: TextStyle(fontSize: 20),),
                        title: Text(_foundRes[i].title.toString()),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Product> _foundRes = [];
}
