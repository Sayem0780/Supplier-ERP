import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:supplier_erp/provider/accounts.dart';
import '../../model/ledger.dart';

class AccountLedger extends StatefulWidget {
  static const routeName = '/account ledger';

  const AccountLedger({Key? key}) : super(key: key);

  @override
  State<AccountLedger> createState() => _AccountLedgerState();
}

class _AccountLedgerState extends State<AccountLedger> {
  late final Accounts ledger;
  late final Future<List<Ledger>> accountsFuture;

  @override
  void initState() {
    super.initState();
    ledger = Provider.of<Accounts>(context, listen: false);
    accountsFuture = ledger.fetchAccounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ledger'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: accountsFuture,
        builder: (BuildContext context, AsyncSnapshot<List<Ledger>> snapshot) {
          final accountsMap = ledger.getAccountsByDate();
          return  Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: accountsMap.length,
                  itemBuilder: (BuildContext context, int index) {
                    final String date = accountsMap.keys.elementAt(index);
                    final List<Ledger> accounts = accountsMap[date]!;
                    return Scrollable(
                      axisDirection: AxisDirection.right,
                      controller: ScrollController(),
                      viewportBuilder: (BuildContext context, ViewportOffset offset) {
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: 20),
                              Text(
                                'Date: $date',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Container(
                                    width: 100,
                                    child: DataTable(
                                      columnSpacing: 8,
                                      columns: [
                                        DataColumn(label: Text('SL'),),
                                        DataColumn(label: Text('Name'),),
                                      ],
                                      rows: accounts.map((item) {
                                        int index = accounts.indexOf(item) +1 ;
                                        final Ledger account = item;
                                        return DataRow(
                                          cells: [
                                            // DataCell(Text((index+1).toString())),//Serial
                                            DataCell(Text('$index.'),),//title
                                            DataCell(Text(account.companyName.toString()),)
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width*.72,
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: DataTable(
                                        columnSpacing: 8,
                                        dividerThickness: 1,
                                        columns: [
                                          DataColumn(label: Text('Recieve')),
                                          DataColumn(label: Text('Due')),
                                          DataColumn(label: Text('Bill No')),
                                          DataColumn(label: Text('Memo No')),
                                        ],
                                        rows: accounts.map((item) {
                                          final Ledger account = item;
                                          return DataRow(
                                            cells: [
                                              DataCell(
                                                Text(account.cashReceive.toString()),
                                              ),//Quantity
                                              DataCell(
                                                  Text(account.due.toString())
                                              ),//UOM
                                              DataCell(
                                                Text(account.billNo.toString()),
                                              ),//Rate
                                              DataCell(Text('  '+account.memoNo.toString())),//Total
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            );
        },
      ),
    );
  }
}

