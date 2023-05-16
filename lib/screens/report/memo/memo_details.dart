import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'package:supplier_erp/methods.dart';
import '../../../model/report.dart';

class MemoDetails extends StatefulWidget {

  static const routeName ='\Memo Details';
  const MemoDetails({Key? key}) : super(key: key);

  @override
  State<MemoDetails> createState() => _MemoDetailsState();
}

class _MemoDetailsState extends State<MemoDetails> {
  @override
  Widget build(BuildContext context) {


    Future<List<dynamic>> retrieveItemList(String billNumber) async {
      // Get a reference to the Firebase Realtime Database
      final reference = FirebaseDatabase.instance.ref.call("Bill");

      // Use a query to search for the node that has the matching qCode value
      Query query = reference.orderByChild('details/qcode').equalTo(billNumber);
      DatabaseEvent event = await query.once();
      DataSnapshot snapshot = event.snapshot;
      // Get the value of the dataSnapshot
      dynamic value = snapshot.value;

      // If the query does not return any data, return an empty list

      // Get the itemList from the first node in the dataSnapshot
      List<dynamic>  itemList = value.values.first['itemList'];
      // print(itemList);

      // Return the itemList
      return itemList;
    }

    Future<Map<Object?, Object?>> retrieveDetails(String billNumber) async {
      // Get a reference to the Firebase Realtime Database
      final reference = FirebaseDatabase.instance.ref.call("Bill");
      // Use a query to search for the node that has the matching qCode value
      Query query = reference.orderByChild('details/qcode').equalTo(billNumber);
      DatabaseEvent event = await query.once();
      DataSnapshot snapshot = event.snapshot;
      // Get the value of the dataSnapshot
      dynamic value = snapshot.value;


      // Get the details from the first node in the dataSnapshot

      Map<Object?, Object?>  details = value.values.first['details'];

      return details;
    }


    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final root = args['root'] as String;

    String name ='', address = '', phone = '', prpo = '';
    final date = args['data6'] as String;
    final CheckNo = args['data7'] as String;
    final MemoNo = args['data8'] as String;
    final recieved = args['data9'] as String;
    final due = args['data10'] as String;
    final totalPrice = args['data11'] as String;
    final totalQuantiity = args['data12'] as String;
    int itemsPerPage = 10;
    double recived = double.parse(recieved);

    List<Item> qitems = [];
    Future<List<Item>> fetchQI() async {
      await retrieveDetails(root).then((details) {
        name = details['quserName'].toString();
        address = details['quserAddress'].toString();
        prpo = details['qPrpo'].toString();
        phone = details['quserPhone'].toString();
      });
      await retrieveItemList(root).then((itemList) {
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
        }
      });
      return qitems;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Cash Memo Details"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () async {
            final pdf = await createCashMemoPdf(qitems, itemsPerPage, name, phone, address, root, prpo, totalPrice, totalQuantiity, CheckNo, MemoNo, recived, due);
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => PdfPreview(
                build: (format) => pdf,
              )),
            );
          }, icon: Icon(Icons.save))

        ],
      ),
      body: FutureBuilder(
          future: fetchQI(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text('PR/PO: $prpo'),
                                  Text('$name',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
                                  Text('$date'),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text('Phone: $phone'),
                                ],
                              ),
                              Center(child: Text('Bill No: $root')),
                              Center(child: Text('Memo No: $MemoNo')),
                              Center(child: Text('Address: $address')),
                              Center(child: Text('Due: $due tk '+' Recieved: $totalPrice tk')),


                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height*.7,
                      child: ListView.builder(
                          itemCount: qitems.length,
                          itemBuilder: (ctx, i) {
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                              elevation: 2,
                              child: ListTile(
                                leading: Text(
                                  (i + 1).toString(),
                                  style: TextStyle(fontSize: 20),
                                ),
                                title: Text(qitems[i].qitemTitle),
                                subtitle:  Text('Rate:' + qitems[i].qitemPrice),
                                trailing: Text('Quantity: '+qitems[i].qitemQuantity),
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
