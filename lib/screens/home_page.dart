import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplier_erp/screens/inventory/inventory_register.dart';
import 'package:supplier_erp/screens/inventory/inventory_entry.dart';
import 'package:supplier_erp/screens/report/quotation/quotation_report.dart';
import 'package:supplier_erp/screens/sale/qurte_clan_bill.dart';
import 'package:supplier_erp/widget/round_button.dart';
import '../provider/sale.dart';

class HomePage extends StatefulWidget {
  static const routeName ='/home page';
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        title: Text('Dash Board'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height*.5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RoundButton(title: 'Sale', onpress: (){
                Navigator.pushNamed(context, QuteCalanBillPage.routeName);
              }),
              RoundButton(title: 'Report', onpress: (){
                Navigator.of(context).pushNamed(QuteCalanBillPage.routeName,arguments: 'r');
              }),
              RoundButton(title: 'Accounts', onpress: (){
                Navigator.of(context).pushNamed(QuteCalanBillPage.routeName,arguments: 'a');
              }),
              RoundButton(title: 'Inventory', onpress: (){
                Navigator.pushNamed(context, InventoryRegister.routeName);
              }),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.restorablePushNamed(context, InventoryEntry.routeName);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add,color: Colors.black,),
        backgroundColor: Colors.amber,
      ),
    );
  }
}
