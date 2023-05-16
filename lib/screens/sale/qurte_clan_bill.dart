import 'package:flutter/material.dart';
import 'package:supplier_erp/screens/accounts/accounts_ledge.dart';
import 'package:supplier_erp/screens/accounts/cash_memo.dart';
import 'package:supplier_erp/screens/inventory/inventory_details.dart';
import 'package:supplier_erp/screens/report/bill/bill_report.dart';
import 'package:supplier_erp/screens/report/calan/calan_report.dart';
import 'package:supplier_erp/screens/report/quotation/quotation_report.dart';
import 'package:supplier_erp/screens/sale/bill/bill_register.dart';
import 'package:supplier_erp/screens/sale/quotation/quotation_register.dart';
import 'package:supplier_erp/widget/round_button.dart';

import '../inventory/inventory_register.dart';
import '../report/memo/memo_report.dart';
import 'calan/calan_register.dart';

class QuteCalanBillPage extends StatefulWidget {
  static const routeName ='/qute calan bill page';
  const QuteCalanBillPage({Key? key}) : super(key: key);

  @override
  State<QuteCalanBillPage> createState() => _QuteCalanBillPageState();
}

class _QuteCalanBillPageState extends State<QuteCalanBillPage> {

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as dynamic;
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Type'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height*.5,
          child: arguments=='r'?Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RoundButton(title: 'Qutation Report', onpress: (){
                Navigator.pushNamed(context, QuotationReport.routeName);
              }),
              RoundButton(title: 'Calan Report', onpress: (){
                 Navigator.pushNamed(context, CalanlReport.routeName);
              }),
              RoundButton(title: 'Bill Report', onpress: (){
                Navigator.pushNamed(context, BillReport.routeName);
              }),
              RoundButton(title: 'Cash Report', onpress: (){
                Navigator.pushNamed(context, MemoReport.routeName);
              }),
            ],
          ):
          arguments=='i'?Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RoundButton(title: 'Inventory', onpress: (){
                Navigator.pushNamed(context, InventoryRegister.routeName);
              }),
              RoundButton(title: 'Stock In', onpress: (){
                Navigator.pushNamed(context, InventoryDetails.routeName);
              }),
            ],
          ):
          arguments=='a'?Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RoundButton(title: 'Accounts Ledger', onpress: (){
                Navigator.pushNamed(context, AccountLedger.routeName);
              }),
              RoundButton(title: 'Cash Memo', onpress: (){
                Navigator.pushNamed(context, CashMemo.routeName);
              }),
            ],
          )
              : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RoundButton(title: 'Qutation', onpress: (){
                Navigator.pushNamed(context, QuotationRegister.routeName);
              }),
              RoundButton(title: 'Calan', onpress: (){
                Navigator.pushNamed(context, CalanRegister.routeName);
              }),
              RoundButton(title: 'Bill', onpress: (){
                Navigator.pushNamed(context, BillRegister.routeName);
              }),
            ],
          ),
        ),
      ),
    );
  }
}
