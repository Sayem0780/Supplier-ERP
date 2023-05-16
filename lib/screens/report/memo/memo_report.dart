import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supplier_erp/provider/report.dart';
import 'package:supplier_erp/screens/report/memo/memo_details.dart';

import 'memo_search.dart';

class MemoReport extends StatelessWidget {
  static const routeName='\memo report';
  const MemoReport({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<Report>(context, listen: false);
    var memo = store.mdetails;

    return Scaffold(
      appBar: AppBar(
        title: Text('Cash Memo History'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(

        child: Column(
          children: [
            GestureDetector(
              onTap: (){
                Navigator.of(context).pushNamed(MSearch.routeName);
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
                  future: store.fetchMD(),
                  builder: (context, snapshot) {
                    if(!snapshot.hasData){
                      return Center(child: CircularProgressIndicator());
                    }else{
                      return ListView.builder(
                          itemCount: store.mdetails.length,
                          itemBuilder: (ctx,i){
                            return GestureDetector(
                              onTap: (){
                                Navigator.of(context).pushNamed(
                                  MemoDetails.routeName,
                                  arguments: {
                                    'root': memo[i].billNo as String,
                                    'data6': memo[i].date as String,
                                    'data7': memo[i].checkNo as String,
                                    'data8': memo[i].memoNo as String,
                                    'data9': memo[i].recieved as String,
                                    'data10': memo[i].due as String,
                                    'data11': memo[i].totalPrice as String,
                                    'data12': memo[i].totalQuantity as String,
                                  },
                                );
                              },
                              child: Card(
                                margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                elevation: 2,
                                child: ListTile(
                                  leading: Text((i + 1).toString(),style: TextStyle(fontSize: 20),),
                                  title: Text(memo[i].name),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Text('BN:'+memo[i].billNo),
                                      Text('MN:'+memo[i].memoNo),
                                      Text(memo[i].date),
                                    ],
                                  ),
                                  trailing: GestureDetector(
                                    onTap: () {
                                      Clipboard.setData(ClipboardData(text: memo[i].billNo));
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('MN copied to clipboard')),
                                      );
                                    },
                                    child: Icon(Icons.content_copy),
                                  ),
                                ),
                              )
                              ,
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


