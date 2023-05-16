
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supplier_erp/model/report.dart';
import 'package:supplier_erp/screens/accounts/cash_memo_print.dart';
import '../../widget/round_button.dart';
import 'package:flutter/services.dart';

class CashMemo extends StatefulWidget {
  static const routeName = '/cash memo';
  const CashMemo({Key? key}) : super(key: key);

  @override
  State<CashMemo> createState() => _CashMemoState();
}

class _CashMemoState extends State<CashMemo> {
  bool spin = false;
  @override
  Widget build(BuildContext context) {

    final _formKey = GlobalKey<FormState>();

    String memoNo = UniqueKey().toString();
    String currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    String CheckNo="",billNo="",name='',date='',code='',address='',prpo='',phone='',root='';

    double RecivedAmount = 0,totalPrice = 0,Due=0,due = 0;
    int totalQuantity = 0;
    List<Item> qitems =[];

    TextEditingController billController = TextEditingController();
    TextEditingController checkController = TextEditingController();
    TextEditingController reciveController = TextEditingController();

    final billcode = ModalRoute.of(context)!.settings.arguments as dynamic;
    final ledgerreference = FirebaseDatabase.instance.ref.call("Accounts");
    final _postref = FirebaseDatabase.instance.ref.call("Bill");

    Future<List<dynamic>> retrieveItemList(String qcode) async {
      // Get a reference to the Firebase Realtime Database
      final reference = FirebaseDatabase.instance.ref.call("Bill");

      // Use a query to search for the node that has the matching qCode value
      Query query = reference.orderByChild('details/qcode').equalTo(qcode);
      DatabaseEvent event = await query.once();
      DataSnapshot snapshot = event.snapshot;

      // Get the value of the dataSnapshot
      dynamic value = snapshot.value;

      // If the query does not return any data, return an empty list
      if (value == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Center(child: Text('No Bill Details found'))),);
        setState(() {
          spin=false;
        });
        return [];
      }

      // Get the itemList from the first node in the dataSnapshot
      List<dynamic>  itemList = value.values.first['itemList'];
      // print(itemList);

      // Return the itemList
      return itemList;
    }

    Future<Map<Object?, Object?>> retrieveDetails(String qcode) async {
      // Get a reference to the Firebase Realtime Database
      final reference = FirebaseDatabase.instance.ref.call("Bill");
      // Use a query to search for the node that has the matching qCode value
      Query query = reference.orderByChild('details/qcode').equalTo(qcode);
      DatabaseEvent event = await query.once();
      DataSnapshot snapshot = event.snapshot;
      // Get the value of the dataSnapshot
      dynamic value = snapshot.value;

      // If the query does not return any data, return an empty list
      if (value == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Center(child: Text('No Bill found'))),
        );
        setState(() {
          spin=false;
        });
        throw Exception("No bill found with billCode ");
      }

      // Get the itemList from the first node in the dataSnapshot

      Map<Object?, Object?>  details = value.values.first['details'];
      print(details);

      return details;
    }



    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Cash Memo"),
        centerTitle: true,
      ),
      body: Center(
        child: spin==true?Center(child: CircularProgressIndicator(),):Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Form(
                key: _formKey,
                child: Column(

                  children: [
                    billcode!=null?Container(
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(child: Text("Bill No: "+billcode.toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),),
                    ):
                    Container(
                      width: 250,
                      child: TextFormField(
                        controller: billController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          hintText: "Enter Bill No",
                          labelText: "Bill No",
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (String value){
                          billNo = value;
                        },
                        validator: ((value) {
                          return value!.isEmpty?'Enter Bill No':null;
                        }),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      width: 250,
                      child: TextFormField(
                        controller: checkController,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          hintText: "Enter Check No",
                          labelText: "Check No",
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (String value){
                          CheckNo = value;
                        },
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      width: 250,
                      child: TextFormField(
                        controller: reciveController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Enter Recived Amount",
                          labelText: "Recived Amount",
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (String value){
                          RecivedAmount = double.parse(value.toString());
                        },
                      ),
                    ),
                    SizedBox(height: 20,),
                    Container(
                      width: 100,
                      child: RoundButton(
                        title: 'Next',
                        onpress: () async {
                          Map<Object?, Object?> details = billcode!=null?await retrieveDetails(billcode):await retrieveDetails(billNo);
                          double dueAmount = double.parse(details["due"].toString());
                          setState(() {
                            spin = true;
                          });
                          if(dueAmount<=0 || RecivedAmount > dueAmount){
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Center(
                                      child: RecivedAmount > dueAmount?Text('Due amount is $dueAmount'):Text('No Due found'))),
                            );
                            setState(() {
                              spin=false;
                            });
                          }
                          else{

                            if(billcode!=null){

                              await retrieveDetails(billcode.toString()).then((details) {
                                if (details == null) {
                                  return const Text("Invalid Code to back Details");
                                }
                                else {
                                  name = details['quserName'].toString();
                                  date = details['qdate'].toString();
                                  code = details['qcode'].toString();
                                  address = details['quserAddress'].toString();
                                  prpo = details['qPrpo'].toString();
                                  phone = details['quserPhone'].toString();
                                  Due = double.parse(details['due'].toString());
                                  root = details['qRoot'].toString();
                                }
                              });
                              await retrieveItemList(billcode.toString()).then((itemList) {
                                if (itemList == null) {
                                  return Text("Invalid Code");
                                }
                                else {
                                  for (var i in itemList) {
                                    qitems.add(
                                      Item(
                                        qitemId: i['qitemId'].toString(),
                                        qitemPrice: i['qitemPrice'].toString(),
                                        qitemQuantity: i['qitemQuantity'].toString(),
                                        qitemStock: i['qitemStock'].toString(),
                                        qitemTitle: i['qitemTitle'].toString(),
                                        qitemTotalPrice: i['qitemTotalPrice'].toString(),
                                        qitemUom: i['qitemUom'].toString(),
                                      ),
                                    );

                                    totalPrice = totalPrice + double.parse(i['qitemTotalPrice'].toString());
                                    totalQuantity = totalQuantity + int.parse(i['qitemQuantity'].toString());
                                  }
                                  due = Due - RecivedAmount;
                                }
                              });
                              if (qitems != null && name != '') {
                                setState(() {
                                  spin=false;
                                });

                                _postref.child(root).child('details/due').set(due.toString());
                                ledgerreference.child(DateTime.now().microsecondsSinceEpoch.toString().toString()).set({
                                  'memoNo': memoNo.toString(),
                                  'billNo': code.toString(),
                                  'cashRecive':totalPrice.toString(),
                                  'due': due.toString(),
                                  'companyName': name.toString(),
                                  'issueDate': currentDate.toString(),
                                  'cashRecive': RecivedAmount.toString(),
                                  'totalPrice': totalPrice.toString(),
                                  'totalQuantity': totalQuantity.toString(),
                                  'checkNo': CheckNo.toString(),
                                }).then((value) =>
                                    Navigator.of(context).pushReplacementNamed(
                                      CashMemoPrint.routeName,
                                      arguments: {
                                        'qitems': qitems as List<Item>,
                                        'name': name as String,
                                        'MemoNo': memoNo as String,
                                        'date': date as String,
                                        'phone': phone as String,
                                        'address': address as String,
                                        'code': code as String,
                                        'prpo': prpo as String,
                                        'totalPrice': totalPrice as double,
                                        'totalQuantity': totalQuantity as int,
                                        'CheckNo': CheckNo as String,
                                        'MemoNo': memoNo as String,
                                        'RecivedAmount': RecivedAmount as double,
                                        'due': due as double
                                      },) ).onError((error, stackTrace) {
                                  print(error.toString());
                                  ScaffoldMessenger.of(context).showSnackBar(

                                    SnackBar(content: Center(child: Text('Cash Memo isn\'t issued'))),);
                                } );

                              }
                              else {
                                setState(() {
                                  spin=false;
                                });
                                Center(
                                  child: Text('No Bill Found'),
                                );
                              }
                            }




                            else{
                              await retrieveDetails(billNo).then((details) {
                                if (details == null) {
                                  return const Text("Invalid Code to back Details");
                                }
                                else {
                                  name = details['quserName'].toString();
                                  date = details['qdate'].toString();
                                  code = details['qcode'].toString();
                                  address = details['quserAddress'].toString();
                                  prpo = details['qPrpo'].toString();
                                  phone = details['quserPhone'].toString();
                                  root = details['qRoot'].toString();
                                }
                              });
                              await retrieveItemList(billNo).then((itemList) {
                                if (itemList == null) {
                                  return Text("Invalid Code");
                                } else {
                                  for (var i in itemList) {
                                    qitems.add(
                                      Item(
                                        qitemId: i['qitemId'].toString(),
                                        qitemPrice: i['qitemPrice'].toString(),
                                        qitemQuantity: i['qitemQuantity'].toString(),
                                        qitemStock: i['qitemStock'].toString(),
                                        qitemTitle: i['qitemTitle'].toString(),
                                        qitemTotalPrice: i['qitemTotalPrice'].toString(),
                                        qitemUom: i['qitemUom'].toString(),
                                      ),
                                    );

                                    totalPrice = totalPrice + double.parse(i['qitemTotalPrice'].toString());
                                    totalQuantity = totalQuantity + int.parse(i['qitemQuantity'].toString());
                                  }
                                  due = dueAmount - RecivedAmount;
                                }
                              });
                              if (qitems != null && name != '') {
                                setState(() {
                                  spin=false;
                                });
                                print(root);
                                _postref.child(root).child('details/due').set(due.toString());
                                ledgerreference.child(DateTime.now().microsecondsSinceEpoch.toString().toString()).set({
                                  'memoNo': memoNo.toString(),
                                  'billNo': code.toString(),
                                  'cashRecive':totalPrice.toString(),
                                  'due': due.toString(),
                                  'companyName': name.toString(),
                                  'issueDate': currentDate.toString(),
                                  'cashRecive': RecivedAmount.toString(),
                                  'totalPrice': totalPrice.toString(),
                                  'totalQuantity': totalQuantity.toString(),
                                  'checkNo': CheckNo.toString(),
                                }).then((value) =>

                                    Navigator.of(context).pushReplacementNamed(
                                      CashMemoPrint.routeName,
                                      arguments: {
                                        'qitems': qitems as List<Item>,
                                        'name': name as String,
                                        'date': date as String,
                                        'phone': phone as String,
                                        'address': address as String,
                                        'code': code as String,
                                        'prpo': prpo as String,
                                        'totalPrice': totalPrice as double,
                                        'totalQuantity': totalQuantity as int,
                                        'CheckNo': CheckNo as String,
                                        'MemoNo': memoNo as String,
                                        'RecivedAmount': RecivedAmount as double,
                                        'due': due as double,
                                      },) ).onError((error, stackTrace) {
                                  print(error.toString());
                                  ScaffoldMessenger.of(context).showSnackBar(

                                    SnackBar(content: Center(child: Text('Cash Memo isn\'t issued'))),);
                                } );

                              }
                              else {
                                setState(() {
                                  spin=false;
                                });
                                Center(
                                  child: Text('No Bill Found'),
                                );
                              }
                            }
                          }
                        },
                      ),
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
