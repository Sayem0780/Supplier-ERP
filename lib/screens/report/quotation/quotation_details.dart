import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../../../model/report.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/widgets.dart' as pw;

class QuotationDetails extends StatefulWidget {

  static const routeName ='\quotation Details';
  const QuotationDetails({Key? key}) : super(key: key);

  @override
  State<QuotationDetails> createState() => _QuotationDetailsState();
}

class _QuotationDetailsState extends State<QuotationDetails> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final root = args['root'] as String;
    final name = args['data1'] as String;
    final address = args['data2'] as String;
    final phone = args['data3'] as String;
    final condition = args['data4'] as String;
    final quotationNumber = args['data5'] as String;
    final date = args['data6'] as String;
    final int condittionLength = int.parse(condition.length.toString());
    int itemsPerPage = 10;
    if(condittionLength>50){
      setState(() {
        itemsPerPage = 9;
      });
    }
    List<Item> qitems = [];
    Future<List<Item>> fetchQI() async {
      final response = await http.get(Uri.parse('https://ustad-f34a1-default-rtdb.firebaseio.com/Quotation/$root.json'));
      print('Quotation');
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
                )
            );
          }
        return qitems;
      } else {
        throw Exception('Failed to fetch order');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Quotation Details"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () async {
            final pdf = await createPDF(qitems, itemsPerPage,name,phone,address,condition,quotationNumber);
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
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text('QN: $quotationNumber'),
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
                              Center(child: Text('Address: $address')),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height*.48,
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
                              subtitle:  Text('Rate:' + qitems[i].qitemPrice),
                              trailing: Text('Quantity: '+qitems[i].qitemQuantity),
                            ),
                          );
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height*.24,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white, // background color
                        border: Border.all(
                          color: Colors.grey, // border color
                          width: 1.0, // border width
                        ),
                        borderRadius: BorderRadius.circular(8.0), // rounded corners
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(child: Text('Conditions',style: Theme.of(context).textTheme.headlineSmall)),
                              SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text('$condition'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                  )
                ],
              );
            }
          }),
    );
  }

  Future<Uint8List> createPDF(
      List<Item> items, int itemsPerPage,name,phone,address,condition,quotationNumber) async {
    print('pdf1');
    final image = await imageFromAssetBundle('assests/th.jpg');
    String currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
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
                    child: pw.Text(index.toString()),
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
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(item.qitemPrice.toString()),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(item.qitemTotalPrice.toString()),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(item.qitemStock.toString()),
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
                              pw.Center(child: pw.Text('Quotation',style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
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
                                    ],
                                  ),
                                  pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                                    children: [
                                      pw.Text('Quotation No: $quotationNumber'),
                                      pw.Text('Date:' + currentDate),
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
                                          pw.Padding(
                                            padding: const pw.EdgeInsets.all(4),
                                            child: pw.Text('Rate'),
                                          ),
                                          pw.Padding(
                                            padding: const pw.EdgeInsets.all(4),
                                            child: pw.Text('Total Price'),
                                          ),
                                          pw.Padding(
                                            padding: const pw.EdgeInsets.all(4),
                                            child: pw.Text('Stock'),
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
                                    pw.Text('09216 Rolfson Fort, Suite 294, 45011, Pacochaberg, South Dakota, United States'),
                                    pw.Text('9517 Piper Pines, Suite 094, 93053-2180, South Neva, Delaware, United States'),
                                  ],
                                ),
                              ),
                              pw.SizedBox(height: 20),
                              pw.Center(child: pw.Text('Quotation',style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
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
                                    ],
                                  ),
                                  pw.Column(
                                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                                    children: [
                                      pw.Text('Quotation No: $quotationNumber'),
                                      pw.Text('Date:' + currentDate),
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
                                          pw.Padding(
                                            padding: const pw.EdgeInsets.all(4),
                                            child: pw.Text('Rate'),
                                          ),
                                          pw.Padding(
                                            padding: const pw.EdgeInsets.all(4),
                                            child: pw.Text('Total Price'),
                                          ),
                                          pw.Padding(
                                            padding: const pw.EdgeInsets.all(4),
                                            child: pw.Text('Stock'),
                                          ),
                                        ],
                                      ),
                                      ...rows,
                                    ],
                                  )),
                              pw.SizedBox(height: 30),
                              pw.Text('Conditions',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(height: 10),
                              pw.Text('1.jrghufhgkebvjkdbvusbvkdsbvksdbvksdbvksdbvksdbvksd\n2.bvksdbvkudsbvksbvkhdbvksbvk\n3.sbvksbvkjsbvksbvksbvsbvksbvksvbks\n4.jbvksdbvksbvkjsbvksdbvksjbvkdbvkdbvkjdbvksbvksbvkjdbvksdbvjsdbvksbvkdfbvkdbvkjdbvkdbvkjdbvkjbvkjbvkjbvkjdbvkd\n5.fbvksbvkjdsbvkjsdbvksdbvkjsb vkdsbvksdvb\n'),
                              pw.Text(condition.toString()),
                              pw.SizedBox(height: 30),
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
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
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
                                            pw.Padding(
                                              padding: const pw.EdgeInsets.all(4),
                                              child: pw.Text('Rate'),
                                            ),
                                            pw.Padding(
                                              padding: const pw.EdgeInsets.all(4),
                                              child: pw.Text('Total Price'),
                                            ),
                                            pw.Padding(
                                              padding: const pw.EdgeInsets.all(4),
                                              child: pw.Text('Stock'),
                                            ),
                                          ],
                                        ),
                                        ...rows,
                                      ],
                                    )),
                                pw.SizedBox(height: 30),
                                pw.Text('Conditions',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                                pw.SizedBox(height: 10),
                                pw.Text('1.jrghufhgkebvjkdbvusbvkdsbvksdbvksdbvksdbvksdbvksd\n2.bvksdbvkudsbvksbvkhdbvksbvk\n3.sbvksbvkjsbvksbvksbvsbvksbvksvbks\n4.jbvksdbvksbvkjsbvksdbvksjbvkdbvkdbvkjdbvksbvksbvkjdbvksdbvjsdbvksbvkdfbvkdbvkjdbvkdbvkjdbvkjbvkjbvkjbvkjdbvkd\n5.fbvksbvkjdsbvkjsdbvksdbvkjsb vkdsbvksdvb\n'),
                                pw.Text(condition.toString()),
                                pw.SizedBox(height: 30),
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
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(4),
                                  child: pw.Text('Stock'),
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
    print('pdf');
    return pdf.save();
  }
}
