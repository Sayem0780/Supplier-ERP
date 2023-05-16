import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplier_erp/provider/accounts.dart';
import 'package:supplier_erp/provider/cart.dart';
import 'package:supplier_erp/provider/report.dart';
import 'package:supplier_erp/provider/sale.dart';
import 'package:supplier_erp/screens/accounts/accounts_ledge.dart';
import 'package:supplier_erp/screens/accounts/cash_memo.dart';
import 'package:supplier_erp/screens/accounts/cash_memo_print.dart';
import 'package:supplier_erp/screens/home_page.dart';
import 'package:supplier_erp/screens/inventory/inventory_register.dart';
import 'package:supplier_erp/screens/inventory/inventory_details.dart';
import 'package:supplier_erp/screens/inventory/inventory_entry.dart';
import 'package:supplier_erp/screens/report/bill/bill_details.dart';
import 'package:supplier_erp/screens/report/bill/bill_report.dart';
import 'package:supplier_erp/screens/report/bill/bill_search_page.dart';
import 'package:supplier_erp/screens/report/calan/calan_details.dart';
import 'package:supplier_erp/screens/report/calan/calan_report.dart';
import 'package:supplier_erp/screens/report/calan/calan_search.dart';
import 'package:supplier_erp/screens/report/memo/memo_details.dart';
import 'package:supplier_erp/screens/report/memo/memo_report.dart';
import 'package:supplier_erp/screens/report/memo/memo_search.dart';
import 'package:supplier_erp/screens/report/quotation/quotation_details.dart';
import 'package:supplier_erp/screens/report/quotation/quotation_report.dart';
import 'package:supplier_erp/screens/report/quotation/quotation_search.dart';
import 'package:supplier_erp/screens/sale/bill/bill_page.dart';
import 'package:supplier_erp/screens/sale/bill/bill_register.dart';
import 'package:supplier_erp/screens/sale/bill/bprint.dart';
import 'package:supplier_erp/screens/sale/calan/calan_page.dart';
import 'package:supplier_erp/screens/sale/calan/calan_register.dart';
import 'package:supplier_erp/screens/sale/calan/cprint.dart';
import 'package:supplier_erp/screens/sale/quotation/qprint.dart';
import 'package:supplier_erp/screens/sale/quotation/quotation_register.dart';
import 'package:supplier_erp/screens/sale/qurte_clan_bill.dart';
import 'package:supplier_erp/screens/sale/quotation/qutation_page.dart';
import 'package:supplier_erp/screens/sale/sale_selection_page.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: [

      ChangeNotifierProvider(
    create: (context)=> Sale(),
    ),
      ChangeNotifierProvider(
        create: (context)=> Accounts(),
      ),
      ChangeNotifierProvider(
        create: (context)=> Report(),
      ),
      ChangeNotifierProvider(create: (context)=>Cart()),
    ],
    child: MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        primaryColor: Colors.purpleAccent,
      ),

      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName:(context)=> HomePage(),
        InventoryEntry.routeName:(context)=> InventoryEntry(),
        SaleSelectionPage.routeName:(context)=> SaleSelectionPage(),
        QutationPage.routeName:(context)=> QutationPage(),
        BillPage.routeName:(context)=> BillPage(),
        CalanPage.routeName:(context)=>CalanPage(),
        QuteCalanBillPage.routeName:(context)=> QuteCalanBillPage(),
        QPrint.routeName:(context)=> QPrint('Real IT Solution'),
        InventoryRegister.routeName:(context)=> InventoryRegister(),
        QuotationRegister.routeName:(context)=> QuotationRegister(),
        BillRegister.routeName:(context)=> BillRegister(),
        CalanRegister.routeName:(context)=> CalanRegister(),
        CPrint.routeName:(context)=> CPrint('Real IT Solution'),
        BPrint.routeName:(context)=> BPrint('Real IT Solution'),
        QuotationReport.routeName:(context)=> QuotationReport(),
        QuotationDetails.routeName:(context)=> QuotationDetails(),
        QSearch.routeName:(context)=> QSearch(),
        BillReport.routeName:(context)=> BillReport(),
        BillDetails.routeName:(context)=> BillDetails(),
        BSearch.routeName:(context)=> BSearch(),
        CalanlReport.routeName:(context)=>CalanlReport(),
        CalanlDetails.routeName:(context)=>CalanlDetails(),
        CSearch.routeName:(context)=>CSearch(),
        CashMemoPrint.routeName:(context)=>CashMemoPrint(),
        CashMemo.routeName:(context)=>CashMemo(),
        AccountLedger.routeName:(context)=> AccountLedger(),
        MemoReport.routeName:(context)=> MemoReport(),
        MemoDetails.routeName:(context)=> MemoDetails(),
        MSearch.routeName:(context)=> MSearch(),
        InventoryDetails.routeName:(context)=>InventoryDetails(),
      },
    ));
  }
}
