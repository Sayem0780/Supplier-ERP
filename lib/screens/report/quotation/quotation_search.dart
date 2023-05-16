import 'package:flutter/material.dart';
import 'package:supplier_erp/model/details.dart';
import 'package:provider/provider.dart';
import 'package:supplier_erp/screens/report/quotation/quotation_details.dart';

import '../../../provider/report.dart';

class QSearch extends StatefulWidget {
  static const routeName = '/quotation search page';

  const QSearch({Key? key}) : super(key: key);

  @override
  State<QSearch> createState() => _QSearchState();
}

class _QSearchState extends State<QSearch> {
  final List<String> _options = ['Quotation No', 'Company Name', 'Phone', 'Date'];
  String _selectedOption = 'Quotation No';
  List<Details> _foundRes = [];

  void _runFilter(String enteredKeyword) {
    final allUsers = Provider.of<Report>(context, listen: false).qdetails;
    setState(() {
      if (_selectedOption == 'Company Name') {
        _foundRes = allUsers.where((user) =>
            user.name.toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
      } else if (_selectedOption == 'Phone') {
        _foundRes = allUsers.where((user) =>
            user.phone.toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
      } else if (_selectedOption == 'Date') {
        _foundRes = allUsers.where((user) =>
            user.date.toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
      } else {
        _foundRes = allUsers.where((user) =>
            user.code.toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<Report>(context, listen: false);

    var register = store.qdetails;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Filter',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 200,
                    child: TextField(
                      onChanged: (value) {
                        _runFilter(value);
                      },
                      decoration: const InputDecoration(
                        labelText: 'Search',
                        suffixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                ),
                DropdownButton<String>(
                  value: _selectedOption,
                  items: _options.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedOption = newValue!;
                    });
                  },
                ),
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height*.8,
              width: 950,
              child: ListView.builder(
                itemCount: _foundRes.length,
                itemBuilder: (ctx, i) {
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
                          }
                          );
                    },
                    child: Card(
                      margin:
                      EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      elevation: 2,
                      child: ListTile(
                        leading: Text((i + 1).toString(),style: TextStyle(fontSize: 20),),
                        title: Text(_foundRes[i].name.toString()),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  // List<Details> _foundRes = [];
}
