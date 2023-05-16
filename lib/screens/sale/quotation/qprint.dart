import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:supplier_erp/screens/home_page.dart';

import '../../../provider/cart.dart';

class QPrint extends StatefulWidget {
  static const routeName = '/print pdf page';
  const QPrint(this.title, {Key? key}) : super(key: key);

  final String title;

  @override
  State<QPrint> createState() => _QPrintState();
}

class _QPrintState extends State<QPrint> {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final name = cart.register[0].name;
    final phone = cart.register[0].phone;
    final address = cart.register[0].address;
    final condition = cart.register[0].condition;
    final int condittionLength = int.parse(condition.length.toString());
    final total = cart.totalAmount;
    int itemsPerPage = 10;
    final qcode = ModalRoute.of(context)!.settings.arguments as String;
    if(condittionLength>50){
      setState(() {
        itemsPerPage = 9;
      });
    }

    return WillPopScope(
      onWillPop: () async {
        cart.selectedItems.clear();
        Navigator.pushNamedAndRemoveUntil(
          context,
          HomePage.routeName,
              (Route<dynamic> route) => false,
        );
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          centerTitle: true,
          leading: IconButton(icon: Icon(Icons.arrow_back_ios),onPressed: (){
            cart.selectedItems.clear();
            Navigator.pushNamedAndRemoveUntil(
              context,
              HomePage.routeName,
                  (Route<dynamic> route) => false,
            );
          },),
        ),
        body: PdfPreview(
          build: (formate) => createPDF(cart.selectedItems, itemsPerPage,name,phone,address,condition,qcode,total),
        ),


      ),
    );
  }

  Future<Uint8List> createPDF(
      Map<String, CartItem> items, int itemsPerPage,name,phone,address,condition,quotationNumber,total) async {


    final image = await imageFromAssetBundle('assests/th.jpg');
    String currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    final pdf = pw.Document();
    final itemData = items.values
        .map((item) => [
              item.id,
              item.title,
              item.quantity.toString(),
              item.uom,
              item.price.toString(),
              item.stock.toString(),
              item.totalprice.toString()
            ])
        .toList();
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
                    child: pw.Text(item[1]),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(item[2]),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(item[3]),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(item[4].toString()),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(item[6].toString()),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(item[5].toString()),
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
                                        child: pw.Text(''),
                                      ),
                                      pw.Padding(
                                        padding: const pw.EdgeInsets.all(4),
                                        child: pw.Text(''),
                                      ),
                                      pw.Padding(
                                        padding: const pw.EdgeInsets.all(4),
                                        child: pw.Text(''),
                                      ),
                                      pw.Padding(
                                        padding: const pw.EdgeInsets.all(4),
                                        child: pw.Text(total.toString()),
                                      ),
                                    ]
                                ),
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
                                              child: pw.Text(''),
                                            ),
                                            pw.Padding(
                                              padding: const pw.EdgeInsets.all(4),
                                              child: pw.Text(''),
                                            ),
                                            pw.Padding(
                                              padding: const pw.EdgeInsets.all(4),
                                              child: pw.Text(''),
                                            ),
                                            pw.Padding(
                                              padding: const pw.EdgeInsets.all(4),
                                              child: pw.Text(total.toString()),
                                            ),
                                          ]
                                      ),
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
    return pdf.save();
  }
}

