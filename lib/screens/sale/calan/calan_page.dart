import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:supplier_erp/screens/sale/bill/bill_register.dart';
import '../../../methods.dart';
import '../../../provider/cart.dart';
import 'cprint.dart';

class CalanPage extends StatefulWidget {
  static const routeName = '/calan entry';
  const CalanPage({Key? key}) : super(key: key);

  @override
  State<CalanPage> createState() => _CalanPageState();
}

class _CalanPageState extends State<CalanPage> {
  bool showsipnner = false;
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    FirebaseAuth _auth = FirebaseAuth.instance;
    final _calanref = FirebaseDatabase.instance.ref.call("Calan");
    final qcode = UniqueKey().toString();
    final _stockref = FirebaseDatabase.instance.ref.call("Stock Register");

    return Scaffold(
      appBar: AppBar(
        title: Text("Calan Entry"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              setState(() {
                showsipnner = true;
              });
              try {
                final int date = DateTime.now().millisecondsSinceEpoch;
                String currentDate =
                    DateFormat('dd/MM/yyyy').format(DateTime.now());
                User? user = _auth.currentUser;

                _calanref.child(date.toString()).child('details').set({
                  'qcode': qcode.toString(),
                  'quserName': cart.register[0].name.toString(),
                  'quserPhone': cart.register[0].phone.toString(),
                  'quserAddress': cart.register[0].address.toString(),
                  'quserCondition': cart.register[0].condition.toString(),
                  'qdate': currentDate.toString(),
                  'qPrpo': cart.register[0].prpo.toString(),
                  'qRoot': date.toString(),
                  'qTotal': cart.totalItem.toString(),
                }).onError((error, stackTrace) {
                  toastMassage(error.toString());
                  setState(() {
                    showsipnner = false;
                    Navigator.of(context).pushNamed(CalanPage.routeName);
                  });
                });

                for (int i = 0; i < cart.selectedItems.length; i++) {
                  int q = int.parse(cart.selectedItems.values
                          .toList()[i]
                          .stock
                          .toString()) -
                      int.parse(cart.selectedItems.values
                          .toList()[i]
                          .quantity
                          .toString());
                  print(q);

                  _stockref
                      .child(
                          cart.selectedItems.values.toList()[i].id.toString())
                      .update({
                    'pStock': q.toString(),
                  });

                  _calanref
                      .child(date.toString())
                      .child('itemList')
                      .child(i.toString())
                      .set(
                    {
                      'qitemId':
                          cart.selectedItems.values.toList()[i].id.toString(),
                      'qitemUom':
                          cart.selectedItems.values.toList()[i].uom.toString(),
                      'qitemTitle': cart.selectedItems.values
                          .toList()[i]
                          .title
                          .toString(),
                      'qitemPrice': cart.selectedItems.values
                          .toList()[i]
                          .price
                          .toString(),
                      'qitemStock': cart.selectedItems.values
                          .toList()[i]
                          .stock
                          .toString(),
                      'qitemQuantity': cart.selectedItems.values
                          .toList()[i]
                          .quantity
                          .toString(),
                      'qitemTotalPrice': cart.selectedItems.values
                          .toList()[i]
                          .totalprice
                          .toString(),
                      // 'uId': user!.uid.toString(),
                      // 'uEmail':user.email.toString()
                    },
                  ).then((value) {
                    setState(() {
                      showsipnner = false;
                      Navigator.of(context)
                          .pushNamed(CPrint.routeName, arguments: '$qcode');
                    });
                    toastMassage("Calan Successfully Registered");
                  }).onError((error, stackTrace) {
                    print('erooooor');
                    print(error);
                    toastMassage(error.toString());
                    setState(() {
                      showsipnner = false;
                      Timer(Duration(seconds: 1), () {
                        Navigator.of(context).pushNamed(CalanPage.routeName);
                      });
                    });
                  });
                }
              } catch (e) {
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
      body: showsipnner
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Scrollable(
                axisDirection: AxisDirection.right,
                controller: ScrollController(),
                viewportBuilder: (BuildContext context, ViewportOffset offset) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        DataTable(
                          columns: [
                            DataColumn(label: Text('No')),
                            DataColumn(label: Text('Name')),
                            DataColumn(label: Text('Quantity')),
                            DataColumn(label: Text('UOM')),
                          ],
                          rows: cart.selectedItems.values.map((item) {
                            int index = cart.selectedItems.values
                                .toList()
                                .indexOf(item);
                            return DataRow(
                              cells: [
                                DataCell(Text((index + 1).toString())),
                                DataCell(Text(item.title)),
                                DataCell(
                                  TextField(
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      int quantity =
                                          int.parse(value.toString());
                                      cart.addItem(
                                        item.id.toString(),
                                        item.title.toString(),
                                        item.uom.toString(),
                                        item.price,
                                        item.stock,
                                        quantity,
                                        item.totalprice,
                                      );
                                    },
                                    decoration: InputDecoration(
                                      hintText: item.quantity.toString(),
                                      contentPadding: EdgeInsets.all(8),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  TextField(
                                    onChanged: (value) {
                                      String uom = value.toString();
                                      cart.addItem(
                                        item.id.toString(),
                                        item.title.toString(),
                                        uom,
                                        item.price,
                                        item.stock,
                                        item.quantity,
                                        item.totalprice,
                                      );
                                    },
                                    decoration: InputDecoration(
                                      hintText: item.uom.toString(),
                                      contentPadding: EdgeInsets.all(8),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  );
                },
              ),
            ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            showsipnner = true;
          });
          try {
            final int date = DateTime.now().millisecondsSinceEpoch;
            String currentDate =
                DateFormat('dd/MM/yyyy').format(DateTime.now());
            User? user = _auth.currentUser;

            _calanref.child(date.toString()).child('details').set({
              'qcode': qcode.toString(),
              'quserName': cart.register[0].name.toString(),
              'quserPhone': cart.register[0].phone.toString(),
              'quserAddress': cart.register[0].address.toString(),
              'quserCondition': cart.register[0].condition.toString(),
              'qdate': currentDate.toString(),
              'qPrpo': cart.register[0].prpo.toString(),
              'qRoot': date.toString(),
              'qTotal': cart.totalItem.toString(),
            }).onError((error, stackTrace) {
              toastMassage(error.toString());
              setState(() {
                showsipnner = false;
                Navigator.of(context).pushNamed(CalanPage.routeName);
              });
            });

            for (int i = 0; i < cart.selectedItems.length; i++) {
              int q = int.parse(
                      cart.selectedItems.values.toList()[i].stock.toString()) -
                  int.parse(cart.selectedItems.values
                      .toList()[i]
                      .quantity
                      .toString());
              print(q);

              _stockref
                  .child(cart.selectedItems.values.toList()[i].id.toString())
                  .update({
                'pStock': q.toString(),
              });

              _calanref
                  .child(date.toString())
                  .child('itemList')
                  .child(i.toString())
                  .set(
                {
                  'qitemId':
                      cart.selectedItems.values.toList()[i].id.toString(),
                  'qitemUom':
                      cart.selectedItems.values.toList()[i].uom.toString(),
                  'qitemTitle':
                      cart.selectedItems.values.toList()[i].title.toString(),
                  'qitemPrice':
                      cart.selectedItems.values.toList()[i].price.toString(),
                  'qitemStock':
                      cart.selectedItems.values.toList()[i].stock.toString(),
                  'qitemQuantity':
                      cart.selectedItems.values.toList()[i].quantity.toString(),
                  'qitemTotalPrice': cart.selectedItems.values
                      .toList()[i]
                      .totalprice
                      .toString(),
                  // 'uId': user!.uid.toString(),
                  // 'uEmail':user.email.toString()
                },
              ).then((value) {
                setState(() {
                  showsipnner = false;
                  Navigator.of(context)
                      .pushNamed(BillRegister.routeName, arguments: '$qcode');
                });
                toastMassage("Calan Successfully Registered");
              }).onError((error, stackTrace) {
                print('erooooor');
                print(error);
                toastMassage(error.toString());
                setState(() {
                  showsipnner = false;
                  Timer(Duration(seconds: 1), () {
                    Navigator.of(context).pushNamed(CalanPage.routeName);
                  });
                });
              });
            }
          } catch (e) {
            print(e.toString());
            toastMassage(e.toString());
            setState(() {
              showsipnner = false;
            });
          }
        },
        tooltip: 'Bill',
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
        backgroundColor: Colors.amber,
      ),
    );
  }
}
