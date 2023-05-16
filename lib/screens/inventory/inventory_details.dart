import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:supplier_erp/model/stockIn.dart';
import 'package:supplier_erp/provider/accounts.dart';
class InventoryDetails extends StatefulWidget {
  static const routeName = '/inventory';

  const InventoryDetails({Key? key}) : super(key: key);

  @override
  State<InventoryDetails> createState() => _InventoryDetailsState();
}

class _InventoryDetailsState extends State<InventoryDetails> {

  late final Accounts details;
  late final Future<List<StockIn>> detailsFuture;
  late final List<StockIn> store;

  @override
  void initState() {
    super.initState();
    details = Provider.of<Accounts>(context, listen: false);
    detailsFuture = details.fetchStockIn();
    store = details.stockIn;
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Transaction Details"),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: detailsFuture,
          builder: (BuildContext context, AsyncSnapshot<List<StockIn>> snapshot) {;
            return  Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: store.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Scrollable(
                      axisDirection: AxisDirection.right,
                      controller: ScrollController(),
                      viewportBuilder: (BuildContext context, ViewportOffset offset) {
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Container(
                                    width: 100,
                                    child: DataTable(
                                      columnSpacing: 8,
                                      columns: [
                                        DataColumn(label: Text('SL'),),
                                        DataColumn(label: Text('Date'),),
                                      ],
                                      rows: store.map((item) {
                                        int index = store.indexOf(item) +1 ;
                                        final StockIn stock = item;
                                        return DataRow(
                                          cells: [
                                            // DataCell(Text((index+1).toString())),//Serial
                                            DataCell(Text('$index.'),),//title
                                            DataCell(Text(stock.date.toString()),)
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
                                          DataColumn(label: Text('Company')),
                                          DataColumn(label: Text('GRN/Calan')),
                                          DataColumn(label: Text('In')),
                                          DataColumn(label: Text('Out')),
                                          DataColumn(label: Text('Rate')),
                                          DataColumn(label: Text('Total')),
                                        ],
                                        rows: store.map((item) {
                                          final StockIn stock = item;
                                          return DataRow(
                                            cells: [
                                              DataCell(
                                                Text(stock.company.toString()),
                                              ),//Company Name
                                              DataCell(
                                                Text(stock.id.toString()),
                                              ),//GRN/Calan
                                              DataCell(
                                                  Text(stock.stockIn.toString())
                                              ), //In
                                              DataCell(
                                                  Text('-'),
                                              ),//Out
                                              DataCell(
                                                Text(stock.price.toString()),
                                              ),//Rate
                                              DataCell(Text((double.parse(stock.stockIn.toString())*double.parse(stock.price.toString())).toString())),//Total
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

