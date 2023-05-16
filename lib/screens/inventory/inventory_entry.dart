import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:firebase_database/firebase_database.dart';
import '../../methods.dart';
import '../../widget/round_button.dart';
import '../home_page.dart';
class InventoryEntry extends StatefulWidget {
  static const routeName ='/inventory register';
  const InventoryEntry({Key? key}) : super(key: key);

  @override
  _InventoryEntryState createState() => _InventoryEntryState();
}

class _InventoryEntryState extends State<InventoryEntry> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final _postref = FirebaseDatabase.instance.ref.call("Stock Register");
  bool showsipnner = false;
  final _formKey = GlobalKey<FormState>();
  String title="",uom ="";
  late double price,stock;
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController stockController = TextEditingController();
  TextEditingController uomController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showsipnner,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Add Your Product"),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Navigate back to the previous screen
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SingleChildScrollView(
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
                            controller: titleController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: "Enter Product Title",
                              labelText: "Product Name",
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (String value){
                              title = value;
                            },
                            validator: ((value) {
                              return value!.isEmpty?'Enter Product Name':null;
                            }),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: TextFormField(
                              controller: priceController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                hintText: "Enter Product price",
                                labelText: "Price",
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (String value){
                                price = double.parse(value);
                              },
                              validator: ((value) {
                                return value!.isEmpty?'Set Price':null;
                              }),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: TextFormField(
                              controller: stockController,
                              keyboardType: TextInputType.phone,
                              maxLines: 1,
                              decoration: InputDecoration(
                                hintText: "How many Product you have in stock ",
                                labelText: "Stock",
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (String value){
                                stock = double.parse(value);
                              },
                              validator: ((value) {
                                return value!.isEmpty?'Stock is required':null;
                              }),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            child: TextFormField(
                              controller: uomController,
                              maxLines: 1,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: "Enter the unit of material",
                                labelText: "Product UOM",
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (String value){
                                uom = value;
                              },
                              validator: ((value) {
                                return value!.isEmpty?'Product UOM is Required':null;
                              }),
                            ),
                          ),
                          RoundButton(title: "Add Item", onpress: ()async{
                            if(_formKey.currentState!.validate()){
                              setState(() {
                                showsipnner = true;
                              });
                              try{
                                int date = DateTime.now().millisecondsSinceEpoch;
                                User? user = _auth.currentUser;
                                _postref.child(date.toString()).set({
                                  'pId': date.toString(),
                                  'pUom':  uomController.text.toString(),
                                  'pTitle': titleController.text.toString(),
                                  'pPrice': priceController.text.toString(),
                                  'pStock': stockController.text.toString(),
                                  // 'uId': user!.uid.toString(),
                                  // 'uEmail':user.email.toString()
                                }).then((value) {
                                  setState(() {
                                    showsipnner = false;
                                    Navigator.of(context).pushNamed(HomePage.routeName);

                                  });
                                  toastMassage("Item Successfully Added");
                                }).onError(
                                        (error, stackTrace) {
                                      toastMassage(error.toString());
                                      setState(() {
                                        showsipnner = false;
                                      });
                                    });
                              }catch(e){
                                print(e.toString());
                                toastMassage(e.toString());
                                setState(() {
                                  showsipnner = false;
                                });
                              }
                            }
                          })
                        ],
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}
