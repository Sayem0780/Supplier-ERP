import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplier_erp/model/register.dart';

import '../../../provider/cart.dart';
import '../../../widget/round_button.dart';
import '../sale_selection_page.dart';

class CalanRegister extends StatelessWidget {
  static const routeName ='\calan register';
  const CalanRegister({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController stockController = TextEditingController();
    TextEditingController prpoController = TextEditingController();

    final _formKey = GlobalKey<FormState>();

    String name="",address ="",phone ="",prpo="";

    final cart = Provider.of<Cart>(context);


    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
        centerTitle: true,
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
                            hintText: "Enter Customer Name",
                            labelText: "Name",
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (String value){
                            name = value;
                          },
                          validator: ((value) {
                            return value!.isEmpty?'Enter Customer Name':null;
                          }),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: TextFormField(
                            controller: priceController,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              hintText: "Enter Coustomer Address",
                              labelText: "Address",
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (String value){
                              address = value;
                            },
                            validator: ((value) {
                              return value!.isEmpty?'Set Address':null;
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
                              hintText: "Customer Phone Number",
                              labelText: "Phone Number",
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (String value){
                              phone = value;
                            },
                            validator: ((value) {
                              return value!.isEmpty?'Phone number is required':null;
                            }),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child: TextFormField(
                            controller: prpoController,
                            keyboardType: TextInputType.phone,
                            maxLines: 1,
                            decoration: InputDecoration(
                              hintText: "Enter PR/PO",
                              labelText: "PR/PO",
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (String value){
                              prpo = value;
                            },
                            validator: ((value) {
                              return value!.isEmpty?'PR/PO is required':null;
                            }),
                          ),
                        ),
                        RoundButton(title: "Next", onpress: ()async{
                          if(_formKey.currentState!.validate()){
                            cart.register.add(
                                Register(
                                    name: name,
                                    address: address,
                                    phone: phone,
                                    prpo: prpo,
                                  condition: '',
                                  code: '',
                                )
                            );
                            Navigator.pushNamed(context, SaleSelectionPage.routeName,arguments: 'c');
                          }
                        })
                      ],
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
