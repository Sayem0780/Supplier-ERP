import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:supplier_erp/screens/home_page.dart';
import '../../../model/report.dart';
import '../../methods.dart';


class CashMemoPrint extends StatefulWidget {
  static const routeName = '/cash memo print';
  const CashMemoPrint({Key? key}) : super(key: key);

  @override
  State<CashMemoPrint> createState() => _CashMemoPrintState();
}

class _CashMemoPrintState extends State<CashMemoPrint> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final qitems = args['qitems'] as List<Item>;
    final name = args['name'] as String;
    final memoNo = args['MemoNo'] as String;
    final phone = args['phone'] as String;
    final address = args['address'] as String;
    final billNo = args['code'] as String;
    final prpo = args['prpo'] as String;
    final totalPrice = args['totalPrice'] as double;
    final totalQuantity = args['totalQuantity'] as int;
    final checkNo = args['CheckNo'] as String;
    final recivedAmount = args['RecivedAmount'] as double;
    final due = args['due'] as double;
    int itemsPerPage = 10;

    return WillPopScope(
      onWillPop: ()async{
        // Navigate to the new page

        // Navigate to a new page and clear the navigation stack
        Navigator.pushNamedAndRemoveUntil(
          context,
          HomePage.routeName,
              (Route<dynamic> route) => false,
        );


        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Cash Memo"),
          centerTitle: true,
        ),
        body: PdfPreview(
          build: (format) => createCashMemoPdf(qitems, itemsPerPage,name,phone,address,billNo,prpo,totalPrice,totalQuantity,checkNo,memoNo,recivedAmount,due),),
      ),
    );
  }


}
