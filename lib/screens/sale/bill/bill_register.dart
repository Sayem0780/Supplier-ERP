import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplier_erp/screens/sale/bill/bill_page.dart';
import '../../../model/register.dart';
import '../../../provider/cart.dart';
import '../../../widget/round_button.dart';

class BillRegister extends StatefulWidget {
  static const routeName ='\bill register';
  const BillRegister({Key? key}) : super(key: key);

  @override
  State<BillRegister> createState() => _BillRegisterState();
}

class _BillRegisterState extends State<BillRegister> {
  bool spin = false;
  late dynamic code;
  var cart;

  @override
  bool _detailsFetched = false;

  void didChangeDependencies() {
    super.didChangeDependencies();
    code = ModalRoute.of(context)!.settings.arguments as dynamic;
    cart = Provider.of<Cart>(context,listen: false);
    if (code != null && !_detailsFetched) {
      _getDetailsAndItemList(code.toString());
      _detailsFetched = true;
    }
  }


  Future<List<dynamic>> retrieveItemList(String qcode) async {
    // Get a reference to the Firebase Realtime Database
    final reference = FirebaseDatabase.instance.ref.call("Calan");


    // Use a query to search for the node that has the matching qCode value
    Query query = reference.orderByChild('details/qcode').equalTo(qcode);
    DatabaseEvent event = await query.once();
    DataSnapshot snapshot = event.snapshot;

    // Get the value of the dataSnapshot
    dynamic value = snapshot.value;

    // If the query does not return any data, return an empty list
    if (value == null) {
      return [];
    }

    // Get the itemList from the first node in the dataSnapshot
    List<dynamic>  itemList = value.values.first['itemList'];
    // Return the itemList
    return itemList;
  }

  Future<Map<Object?, Object?>> retrieveDetails(String qcode) async {
    // Get a reference to the Firebase Realtime Database
    final reference = FirebaseDatabase.instance.ref.call("Calan");

    // Use a query to search for the node that has the matching qCode value
    Query query = reference.orderByChild('details/qcode').equalTo(qcode);
    DatabaseEvent event = await query.once();
    DataSnapshot snapshot = event.snapshot;

    // Get the value of the dataSnapshot
    dynamic value = snapshot.value;

    // If the query does not return any data, return an empty list
    if (value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Center(child: Text('No Calan found'))),
      );
    }


    // Get the itemList from the first node in the dataSnapshot

    Map<Object?, Object?>  details = value.values.first['details'];
    return details;
  }

  Future _getDetailsAndItemList(String qcode) async {

    // Retrieve details and item list
    await retrieveDetails(qcode).then((details) {
      if (details == null) {
        return const Text("Invalid Code to back Details");
      }
      else {
        cart.register.add(
            Register(
              name: details['quserName'].toString(),
              address: details['quserAddress'].toString(),
              phone: details['quserPhone'].toString(),
              prpo: details['qPrpo'].toString(),
              condition: '',
              code: '',
            )
        );
      }
    });
    await retrieveItemList(qcode).then((itemList) {
      if (itemList == null) {
        return Text("Invalid Code");
      } else {
        for (var i in itemList) {
          cart.addItem(
              i['qitemId'].toString(),
              i['qitemTitle'].toString(),
              i['qitemUom'].toString(),
              double.parse(i['qitemPrice']),
              int.parse(i['qitemStock'].toString()),
              int.parse(i['qitemQuantity'].toString()),
              double.parse(i['qitemTotalPrice'].toString())
          );
        }
      }
    });
    if (cart.selectedItems.length != null) {
      setState(() {
        spin = false;
      });
      Navigator.of(context).pushReplacementNamed(
        BillPage.routeName,
      );
    }
  }


  @override
  Widget build(BuildContext context) {


    TextEditingController calanController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    String CalanNo="";
    final cart = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Bill'),
        centerTitle: true,
      ),
      body: code!=null?Center(child: CircularProgressIndicator(),):SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: calanController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "Enter Calan No",
                            labelText: "Calan No",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (String value){
                            CalanNo = value;
                          },
                          validator: ((value) {
                            return value!.isEmpty?'Enter Calan No':null;
                          }),
                        ),
                        SizedBox(height: 20,),
                        RoundButton(title: "Next", onpress: ()async{
                          setState(() {
                            spin = true;
                          });
                          await retrieveDetails(CalanNo).then((details) {
                            if (details == null) {
                              return const Text("Invalid Code to back Details");
                            }
                            else {
                              cart.register.add(
                                  Register(
                                    name: details['quserName'].toString(),
                                    address: details['quserAddress'].toString(),
                                    phone: details['quserPhone'].toString(),
                                    prpo: details['qPrpo'].toString(),
                                    condition: '',
                                    code: '',
                                  )
                              );
                            }
                          });
                          await retrieveItemList(CalanNo).then((itemList) {
                            if (itemList == null) {
                              return Text("Invalid Code");
                            } else {
                              for (var i in itemList) {
                                cart.addItem(
                                    i['qitemId'].toString(),
                                    i['qitemTitle'].toString(),
                                    i['qitemUom'].toString(),
                                    double.parse(i['qitemPrice']),
                                    int.parse(i['qitemStock'].toString()),
                                    int.parse(i['qitemQuantity'].toString()),
                                    double.parse(i['qitemTotalPrice'].toString())
                                );
                              }
                            }
                          });
                          if (cart.selectedItems.length != null) {
                            setState(() {
                              spin = false;
                            });
                            Navigator.of(context).pushReplacementNamed(
                              BillPage.routeName,
                            );
                          }
                        })
                      ],
                    )),
              ),
              spin?CircularProgressIndicator():Container()
            ],
          ),
        ),
      ),
    );
  }
}
