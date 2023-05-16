import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../../../model/report.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/widgets.dart' as pw;
class CalanlDetails extends StatefulWidget {

  static const routeName ='\calan Details';
  const CalanlDetails({Key? key}) : super(key: key);

  @override
  State<CalanlDetails> createState() => _CalanlDetailsState();
}

class _CalanlDetailsState extends State<CalanlDetails> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final root = args['root'] as String;
    final name = args['data1'] as String;
    final address = args['data2'] as String;
    final phone = args['data3'] as String;
    final calanNo = args['data4'] as String;
    final prpo = args['data5'] as String;
    final date = args['data6'] as String;
    int itemsPerPage = 14;
    int total = 0;

    List<Item> qitems = [];
    Future<List<Item>> fetchQI() async {
      final response = await http.get(Uri.parse('https://ustad-f34a1-default-rtdb.firebaseio.com/Calan/$root.json'));
      print('Calan');
      if (response.statusCode == 200) {
        print(response.statusCode.toString());
        qitems.clear();
        final data = json.decode(response.body);

        for(var i in data['itemList']){
          qitems.add(
              Item(
                  qitemId: i['qitemId'].toString(),
                  qitemPrice: i['qitemPrice'].toString(),
                  qitemQuantity: i['qitemQuantity'].toString(),
                  qitemStock: i['qitemStock'].toString(),
                  qitemTitle: i['qitemTitle'].toString(),
                  qitemTotalPrice: i['qitemTotalPrice'].toString(),
                  qitemUom: i['qitemUom'].toString()
              ),
          );
          total = total + int.parse(i['qitemQuantity'].toString());
      }
        return qitems;
      } else {
        throw Exception('Failed to fetch order');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Calan Details"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () async {
            final pdf = await createPDF(qitems, itemsPerPage,name,phone,address,prpo,date,total);
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => PdfPreview(
                build: (format) => pdf,
              )),
            );
          }, icon: Icon(Icons.save))

        ],
      ),
      body: FutureBuilder(
          future: fetchQI(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              print(!snapshot.hasData);
              return Center(child: CircularProgressIndicator());
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text('PR/PO: $prpo'),
                                Text('$name',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
                                Text('$date'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text('Phone: $phone'),
                              ],
                            ),
                            Center(child: Text('Calan No: $calanNo')),
                            Center(child: Text('Address: $address')),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height*.7,
                    child: ListView.builder(
                        itemCount: qitems.length,
                        itemBuilder: (ctx, i) {
                          print(qitems.length);
                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                            elevation: 2,
                            child: ListTile(
                              leading: Text(
                                (i + 1).toString(),
                                style: TextStyle(fontSize: 20),
                              ),
                              title: Text(qitems[i].qitemTitle),
                              trailing: Text('Total: '+qitems[i].qitemQuantity),
                            ),
                          );
                        }),
                  ),
                ],
              );
            }
          }),
    );
  }

  Future<Uint8List> createPDF(List<Item> items, int itemsPerPage,name,phone,address,prpo,date,total) async {


    final image = await imageFromAssetBundle('assests/th.jpg');
    String currentDat = DateFormat('dd/MM/yyyy').format(DateTime.now());
    var quotationNumber = UniqueKey();
    final pdf = pw.Document();
    final itemData = items;
    final pageCount = (itemData.length / itemsPerPage).ceil();

    var i = 0;
    for (var pageNum = 0; pageNum < pageCount; pageNum++) {
      pdf.addPage(
        pw.Page(
          build: (context) {
            final rows = <pw.TableRow>[];
            for (var j = 0; j < itemsPerPage; j++) {
              final index = i * itemsPerPage + j;
              if (index >= itemData.length) {
                break;
              }
              final item = itemData[index];
              rows.add(pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text((index+1).toString()),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(item.qitemTitle),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(item.qitemQuantity),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(item.qitemUom),
                  ),
                ],
              ));
            }
            i++;
            if (pageNum == 0 && pageCount-1>pageNum) {
              return pw.Stack(
                  children: [
                    pw.Center(
                      child: pw.Image(image),
                    ),
                    pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Container(
                                alignment: pw.Alignment.center,
                                child: pw.Text(
                                  'Real It Solution',
                                  style: pw.TextStyle(
                                    fontSize: 20,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                              ),
                              pw.SizedBox(height: 10),
                              pw.Container(
                                alignment: pw.Alignment.center,
                                child: pw.Column(
                                  children: [
                                    pw.Text('09216 Rolfson Fort, Suite 294, 45011, Pacochaberg, South Dakota, United States'),
                                    pw.Text('9517 Piper Pines, Suite 094, 93053-2180, South Neva, Delaware, United States'),
                                  ],
                                ),
                              ),
                              pw.SizedBox(height: 20),
                              pw.Center(child: pw.Text('Calan',style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                              pw.SizedBox(height: 20),
                              pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                children: [
                                  pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text('Name: '+ name.toString()),
                                      pw.Text('Phone: ' + phone.toString()),
                                      pw.Text('Address: '+ address.toString()),
                                      pw.Text('PR/PO No: '+ prpo.toString()),
                                    ],
                                  ),
                                  pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                                    children: [
                                      pw.Text('Calan No: $quotationNumber'),
                                      pw.Text('Date: $date'),
                                    ],
                                  ),
                                ],
                              ),
                              pw.SizedBox(height: 30),
                              pw.Center(
                                  child: pw.Table(
                                    border: pw.TableBorder.all(),
                                    children: [
                                      pw.TableRow(
                                        decoration: pw.BoxDecoration(
                                          color: PdfColors.blue50,
                                        ),
                                        children: [
                                          pw.Padding(
                                            padding: const pw.EdgeInsets.all(4),
                                            child: pw.Text('SL'),
                                          ),
                                          pw.Padding(
                                            padding: const pw.EdgeInsets.all(4),
                                            child: pw.Text('Name'),
                                          ),
                                          pw.Padding(
                                            padding: const pw.EdgeInsets.all(4),
                                            child: pw.Text('Unit'),
                                          ),
                                        ],
                                      ),
                                      ...rows,
                                    ],
                                  )),
                            ],
                          ),
                          pw.Positioned(
                            bottom: 20,
                            left: 0,
                            right: 0,
                            child: pw.Center(
                                child: pw.Text('Page: '+(pageNum+1).toString(),)
                            ),),
                        ]
                    ),
                  ]
              );
            }//For first page of multiple page

            if(pageNum==0 && pageCount-1==0 ){
              return pw.Stack(
                  children: [
                    pw.Center(
                      child: pw.Image(image),
                    ),
                    pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Container(
                                alignment: pw.Alignment.center,
                                child: pw.Text(
                                  'Real IT Solution',
                                  style: pw.TextStyle(
                                    fontSize: 20,
                                    fontWeight: pw.FontWeight.bold,
                                  ),
                                ),
                              ),
                              pw.SizedBox(height: 10),
                              pw.Container(
                                alignment: pw.Alignment.center,
                                child: pw.Column(
                                  children: [
                                    pw.Text('9517 Piper Pines, Suite 094, 93053-2180, South Neva, Delaware, United States'),
                                    pw.Text('09216 Rolfson Fort, Suite 294, 45011, Pacochaberg, South Dakota, United States'),
                                  ],
                                ),
                              ),
                              pw.SizedBox(height: 20),
                              pw.Center(child: pw.Text('Calan',style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                              pw.SizedBox(height: 20),
                              pw.Row(
                                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                children: [
                                  pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                                    children: [
                                      pw.Text('Name: '+ name.toString()),
                                      pw.Text('Phone: '+ phone.toString()),
                                      pw.Text('Address: '+ address.toString()),
                                      pw.Text('PR/PO No: '+ prpo.toString()),
                                    ],
                                  ),
                                  pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                                    children: [
                                      pw.Text('Calan No: '+quotationNumber.toString()),
                                      pw.Text('Date: $date'),
                                    ],
                                  ),
                                ],
                              ),
                              pw.SizedBox(height: 30),
                              pw.Center(
                                  child: pw.Table(
                                    border: pw.TableBorder.all(),
                                    children: [
                                      pw.TableRow(
                                        decoration: pw.BoxDecoration(
                                          color: PdfColors.blue50,
                                        ),
                                        children: [
                                          pw.Padding(
                                            padding: const pw.EdgeInsets.all(4),
                                            child: pw.Text('SL'),
                                          ),
                                          pw.Padding(
                                            padding: const pw.EdgeInsets.all(4),
                                            child: pw.Text('Name'),
                                          ),
                                          pw.Padding(
                                            padding: const pw.EdgeInsets.all(4),
                                            child: pw.Text('Unit'),
                                          ),
                                          pw.Padding(
                                            padding: const pw.EdgeInsets.all(4),
                                            child: pw.Text('UOM'),
                                          ),
                                        ],
                                      ),
                                      ...rows,
                                      pw.TableRow(
                                          decoration: pw.BoxDecoration(color: PdfColors.blue100,),
                                          children: [
                                            pw.Padding(
                                              padding: const pw.EdgeInsets.all(4),
                                              child: pw.Text(''),
                                            ),
                                            pw.Padding(
                                              padding: const pw.EdgeInsets.all(4),
                                              child: pw.Text('Total'),
                                            ),
                                            pw.Padding(
                                              padding: const pw.EdgeInsets.all(4),
                                              child: pw.Text(total.toString()),
                                            ),
                                          ]
                                      ),
                                    ],
                                  )),
                              pw.SizedBox(height: 50),
                              pw.Row(
                                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                  children: [
                                    pw.Text('Reciver\'s Signature',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                                    pw.Text('Real Time IT Solution',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                                  ]
                              ),
                            ],
                          ),
                          pw.Positioned(
                            bottom: 20,
                            left: 0,
                            right: 0,
                            child: pw.Center(
                                child: pw.Text('Page: '+(pageNum+1).toString(),)
                            ),
                          ),
                        ]
                    ),
                  ]
              );
            }//For one & only page
            if(pageNum==pageCount-1){
              return pw.Stack(
                  children: [
                    pw.Center(
                      child: pw.Image(image),
                    ),
                    pw.Column(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Column(
                              children: [
                                pw.Center(
                                    child: pw.Table(
                                      border: pw.TableBorder.all(),
                                      children: [
                                        pw.TableRow(
                                          decoration: pw.BoxDecoration(
                                            color: PdfColors.blue50,
                                          ),
                                          children: [
                                            pw.Padding(
                                              padding: const pw.EdgeInsets.all(4),
                                              child: pw.Text('SL'),
                                            ),
                                            pw.Padding(
                                              padding: const pw.EdgeInsets.all(4),
                                              child: pw.Text('Name'),
                                            ),
                                            pw.Padding(
                                              padding: const pw.EdgeInsets.all(4),
                                              child: pw.Text('Unit'),
                                            ),
                                            pw.Padding(
                                              padding: const pw.EdgeInsets.all(4),
                                              child: pw.Text('UOM'),
                                            ),
                                          ],
                                        ),
                                        ...rows,
                                        pw.TableRow(
                                            decoration: pw.BoxDecoration(color: PdfColors.blue100,),
                                            children: [
                                              pw.Padding(
                                                padding: const pw.EdgeInsets.all(4),
                                                child: pw.Text(''),
                                              ),
                                              pw.Padding(
                                                padding: const pw.EdgeInsets.all(4),
                                                child: pw.Text('Total'),
                                              ),
                                              pw.Padding(
                                                padding: const pw.EdgeInsets.all(4),
                                                child: pw.Text(total.toString()),
                                              ),
                                            ]
                                        ),
                                      ],
                                    )),
                                pw.SizedBox(height: 50),
                                pw.Row(
                                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                                    children: [
                                      pw.Text('Reciver\'s Signature',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                                      pw.Text('Real Time IT Solution',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                                    ]
                                ),
                              ]
                          ),
                          pw.Positioned(
                            bottom: 20,
                            left: 0,
                            right: 0,
                            child: pw.Center(
                                child: pw.Text('Page: '+(pageNum+1).toString(),)
                            ),
                          ),
                        ]
                    )
                  ]
              ) ;
            }//For Last Page
            return pw.Stack(
                children: [
                  pw.Center(
                    child: pw.Image(image),
                  ),
                  pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Table(
                          border: pw.TableBorder.all(),
                          children: [
                            pw.TableRow(
                              decoration: pw.BoxDecoration(
                                color: PdfColors.blue50,
                              ),
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(4),
                                  child: pw.Text('SL'),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(4),
                                  child: pw.Text('Name'),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(4),
                                  child: pw.Text('Unit'),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(4),
                                  child: pw.Text('UOM'),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(4),
                                  child: pw.Text('Rate'),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(4),
                                  child: pw.Text('Total Price'),
                                ),
                              ],
                            ),
                            ...rows,
                          ],
                        ),
                        pw.Positioned(
                          bottom: 20,
                          left: 0,
                          right: 0,
                          child: pw.Center(
                              child: pw.Text('Page: '+(pageNum+1).toString(),)
                          ),
                        ),
                      ]
                  )
                ]
            );//For all page between first and last page
          },
        ),
      );
    }

    return pdf.save();
  }
}
