import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:supplier_erp/screens/accounts/cash_memo.dart';
import '../../../methods.dart';
import '../../../provider/cart.dart';
import 'bprint.dart';

class BillPage extends StatefulWidget {
  static const routeName = '/bill entry';
  const BillPage({Key? key}) : super(key: key);

  @override
  State<BillPage> createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> {
  bool showsipnner = false;
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    FirebaseAuth _auth = FirebaseAuth.instance;
    final _postref = FirebaseDatabase.instance.ref.call("Bill");
    final ledgerreference = FirebaseDatabase.instance.ref.call("Accounts");
    final qcode = UniqueKey().toString();
    double due = 0;

    return Scaffold(
      appBar: AppBar(
        title: Text("Bill Entry"),
        centerTitle: true,

        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                showsipnner = true;
                print('showsipner = '+ showsipnner.toString());
              }
              );

              try{
                final int date = DateTime.now().millisecondsSinceEpoch;
                String currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
                User? user = _auth.currentUser;
                for (int i = 0; i<cart.selectedItems.length;i++) {
                  due = due + double.parse(cart.selectedItems.values.toList()[i].totalprice.toString());
                  _postref.child(date.toString()).child('itemList').child(i.toString()).set(
                    {
                      'qitemId':  cart.selectedItems.values.toList()[i].id.toString(),
                      'qitemUom':  cart.selectedItems.values.toList()[i].uom.toString(),
                      'qitemTitle':  cart.selectedItems.values.toList()[i].title.toString(),
                      'qitemPrice':  cart.selectedItems.values.toList()[i].totalprice.toString(),
                      'qitemQuantity':  cart.selectedItems.values.toList()[i].quantity.toString(),
                      'qitemTotalPrice':  cart.selectedItems.values.toList()[i].totalprice.toString(),
                      // 'uId': user!.uid.toString(),
                      // 'uEmail':user.email.toString()
                    },
                  ).then((value) {
                    setState(() {
                      showsipnner = false;
                    });
                    Navigator.of(context).pushNamed(BPrint.routeName,arguments: qcode);
                    ledgerreference.child(DateTime.now().microsecondsSinceEpoch.toString().toString()).set({
                      'memoNo': '',
                      'billNo': qcode.toString(),
                      'cashRecive': '',
                      'due': due.toString(),
                      'companyName': '',
                      'issueDate': '',
                      'cashRecive': '',
                    });
                    toastMassage("Item Successfully Added");
                  }).onError((error, stackTrace) {
                    print('erooooor');
                    print(error);
                    toastMassage(error.toString());
                    setState(() {
                      showsipnner = false;
                      Navigator.of(context).pushNamed(BillPage.routeName);
                    });
                  });
                }
                _postref.child(date.toString()).child('details').set({
                  'qcode': qcode.toString(),
                  'quserName': cart.register[0].name.toString(),
                  'quserPhone': cart.register[0].phone.toString(),
                  'quserAddress': cart.register[0].address.toString(),
                  'qdate': currentDate.toString(),
                  'qPrpo': cart.register[0].prpo.toString(),
                  'qRoot': date.toString(),
                  'due': due.toString(),
                }).
                onError((error, stackTrace) {
                      toastMassage(error.toString());
                      setState(() {
                        showsipnner = false;
                        Navigator.of(context).pushNamed(BillPage.routeName);
                      });
                    });

              }catch(e){
                print(e.toString());
                toastMassage(e.toString());
                setState(() {
                  showsipnner = false;
                });
              }
            },
            icon: Icon(Icons.save),
          ),
        ],
      ),
      body: showsipnner?Center(child: CircularProgressIndicator(),):
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Scrollable(
          axisDirection: AxisDirection.right,
          controller: ScrollController(),
          viewportBuilder: (BuildContext context, ViewportOffset offset) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        width: 150,
                        child: DataTable(
                          columns: [
                            DataColumn(label: Row(
                              children: [
                                Text('SL '),

                                Text(' Name')
                              ],
                            ),),
                          ],
                          rows: cart.selectedItems.values
                              .map((item) {
                            int index = cart.selectedItems.values.toList().indexOf(item) +1 ;
                            return DataRow(
                              cells: [
                                // DataCell(Text((index+1).toString())),//Serial
                                DataCell(
                                    Container(
                                  width: 140,
                                  child: Row(
                                    children: [
                                      Text('$index.  '),
                                      Container(
                                        width: 100,
                                          child: Text(item.title))
                                    ],
                                  ),
                                )),//title
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                      Container(
                        width: 200,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: [
                              DataColumn(label: Text('Quantity')),
                              DataColumn(label: Text('UOM')),
                              DataColumn(label: Text('Rate')),
                              DataColumn(label: Text('Total ')),
                            ],
                            rows: cart.selectedItems.values
                                .map((item) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Text(item.quantity.toString()),
                                  ),//Quantity
                                  DataCell(
                                      Text(item.uom)
                                  ),//UOM
                                  DataCell(
                                    TextField(
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        double rate = double.parse(value.toString());
                                        cart.addItem(
                                          item.id.toString(),
                                          item.title.toString(),
                                          item.uom.toString(),
                                          rate,
                                          item.stock,
                                          item.quantity,
                                          rate * item.quantity,
                                        );
                                      },
                                      decoration: InputDecoration(
                                        hintText: item.price.toString(),
                                        contentPadding: EdgeInsets.all(8),
                                      ),
                                    ),
                                  ),//Rate
                                  DataCell(Text(item.totalprice.toString())),//Total
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            showsipnner = true;
            print('showsipner = '+ showsipnner.toString());
          }
          );

          try{
            final int date = DateTime.now().millisecondsSinceEpoch;
            String currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
            User? user = _auth.currentUser;
            for (int i = 0; i<cart.selectedItems.length;i++) {
              due = due + double.parse(cart.selectedItems.values.toList()[i].totalprice.toString());
              _postref.child(date.toString()).child('itemList').child(i.toString()).set(
                {
                  'qitemId':  cart.selectedItems.values.toList()[i].id.toString(),
                  'qitemUom':  cart.selectedItems.values.toList()[i].uom.toString(),
                  'qitemTitle':  cart.selectedItems.values.toList()[i].title.toString(),
                  'qitemPrice':  cart.selectedItems.values.toList()[i].totalprice.toString(),
                  'qitemQuantity':  cart.selectedItems.values.toList()[i].quantity.toString(),
                  'qitemTotalPrice':  cart.selectedItems.values.toList()[i].totalprice.toString(),
                  // 'uId': user!.uid.toString(),
                  // 'uEmail':user.email.toString()
                },
              ).then((value) {
                setState(() {
                  showsipnner = false;
                });
                Navigator.of(context).pushNamed(CashMemo.routeName,arguments: qcode);
                toastMassage("Bill Successfully Added");
              }).onError((error, stackTrace) {
                print('erooooor');
                print(error);
                toastMassage(error.toString());
                setState(() {
                  showsipnner = false;
                  Navigator.of(context).pushNamed(BillPage.routeName);
                });
              });
            }
            _postref.child(date.toString()).child('details').set({
              'qcode': qcode.toString(),
              'quserName': cart.register[0].name.toString(),
              'quserPhone': cart.register[0].phone.toString(),
              'quserAddress': cart.register[0].address.toString(),
              'qdate': currentDate.toString(),
              'qPrpo': cart.register[0].prpo.toString(),
              'qRoot': date.toString(),
              'due': due.toString(),
            }).onError(
                    (error, stackTrace) {
                  toastMassage(error.toString());
                  setState(() {
                    showsipnner = false;
                    Navigator.of(context).pushNamed(BillPage.routeName);
                  });
                });
          }catch(e){
            print(e.toString());
            toastMassage(e.toString());
            setState(() {
              showsipnner = false;
            });
          }
        },
        tooltip: 'Cash Memo',
        child: const Icon(Icons.add,color: Colors.black,),
        backgroundColor: Colors.amber,
      ),
    );

  }
}
