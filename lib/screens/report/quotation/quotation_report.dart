import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supplier_erp/provider/report.dart';
import 'package:supplier_erp/screens/report/quotation/quotation_details.dart';
import 'package:supplier_erp/screens/report/quotation/quotation_search.dart';

class QuotationReport extends StatelessWidget {
  static const routeName='\quotation report';
  const QuotationReport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<Report>(context, listen: false);

    var register = store.qdetails;


    return Scaffold(
      appBar: AppBar(
        title: Text('Quotation History'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(

        child: Column(
          children: [
            GestureDetector(
              onTap: (){
                Navigator.of(context).pushNamed(QSearch.routeName);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
        child: Container(
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Search',
                  suffixIcon: Icon(Icons.search),
                )
              ),
        ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height*.8,
              child: FutureBuilder(
                  future: store.fetchQD(),
                  builder: (context, snapshot) {
                    if(!snapshot.hasData){
                      return Center(child: CircularProgressIndicator());
                    }else{
                      return ListView.builder(
                          itemCount: store.qdetails.length,
                          itemBuilder: (ctx,i){
                            return GestureDetector(
                              onTap: (){
                                Navigator.of(context).pushNamed(
                                  QuotationDetails.routeName,
                                  arguments: {
                                    'root': register[i].root as String,
                                    'data1': register[i].name as String,
                                    'data2': register[i].address as String,
                                    'data3': register[i].phone as String,
                                    'data4': register[i].Conditions as String,
                                    'data5': register[i].code as String,
                                    'data6': register[i].date as String,
                                  },
                                );
                              },
                              child: Card(
                                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                elevation: 2,
                                child: ListTile(
                                  leading: Text((i + 1).toString(),style: TextStyle(fontSize: 20),),
                                  title: Text(register[i].name),
                                  subtitle: Text('QN:'+register[i].code),
                                  trailing: Text(register[i].date),
                                ),
                              ),
                            );
                          });}
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}


