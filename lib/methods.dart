import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

import 'model/report.dart';

void toastMassage(String massage){
  Fluttertoast.showToast(
      msg: massage,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.purpleAccent,
      textColor: Colors.white,
      fontSize: 16.0
  );
}

Future<Uint8List> createCashMemoPdf(List<Item> item, int itemsPerPage,name,phone,address,billNo,prpo,totalPrice,totalQuantiity,CheckNo,MemoNo,double recived,due) async {


  final image = await imageFromAssetBundle('assests/th.jpg');
  String currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  var CashMemoNo = MemoNo;
  var BillNo = billNo;
  final pdf = pw.Document();
  final itemData = item
      .map((item) => [
    item.qitemId,
    item.qitemTitle,
    item.qitemQuantity.toString(),
    item.qitemUom,
    item.qitemPrice.toString(),
    item.qitemStock.toString(),
    item.qitemTotalPrice.toString()
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
            rows.add(
                pw.TableRow(
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
                                'Rack Up IT Solution',
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
                            pw.Center(child: pw.Text('Cash Memo',style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
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
                                    CheckNo.toString().length<2? pw.Text('Recive Type Cash'):pw.Text('Check No: '+CheckNo.toString()),
                                  ],
                                ),
                                pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                                  children: [
                                    pw.Text('Memo No: $CashMemoNo'),
                                    pw.Text('Bill No: $BillNo'),
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
                                'Rack Up IT Solution',
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
                            pw.Center(child: pw.Text('Cash Memo',style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
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
                                    CheckNo.toString().length<2? pw.Text('Recive Type Cash'):pw.Text('Check No: '+CheckNo.toString()),
                                  ],
                                ),
                                pw.Column(
                                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                                  children: [
                                    pw.Text('Memo No: $CashMemoNo'),
                                    pw.Text('Bill No: '+BillNo.toString()),
                                    pw.Text('Date: $currentDate'),
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
                                            child: pw.Text(totalQuantiity.toString()),
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
                                            child: pw.Text(totalPrice.toString()),
                                          ),
                                        ]
                                    ),
                                    pw.TableRow(
                                        decoration: pw.BoxDecoration(color: PdfColors.blue100,),
                                        children: [
                                          pw.Padding(
                                            padding: const pw.EdgeInsets.all(4),
                                            child: pw.Text(''),
                                          ),
                                          pw.Padding(
                                            padding: const pw.EdgeInsets.all(4),
                                            child: pw.Text('Recived Amount'),
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
                                            child: pw.Text(recived.toString()),
                                          ),
                                        ]
                                    ),
                                    pw.TableRow(
                                        decoration: pw.BoxDecoration(color: PdfColors.blue100,),
                                        children: [
                                          pw.Padding(
                                            padding: const pw.EdgeInsets.all(4),
                                            child: pw.Text(''),
                                          ),
                                          pw.Padding(
                                            padding: const pw.EdgeInsets.all(4),
                                            child: pw.Text('Due'),
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
                                            child: pw.Text(due.toString()),
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
                                              child: pw.Text(totalQuantiity.toString()),
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
                                              child: pw.Text(totalPrice.toString()),
                                            ),
                                          ]
                                      ),
                                      pw.TableRow(
                                          decoration: pw.BoxDecoration(color: PdfColors.blue100,),
                                          children: [
                                            pw.Padding(
                                              padding: const pw.EdgeInsets.all(4),
                                              child: pw.Text(''),
                                            ),
                                            pw.Padding(
                                              padding: const pw.EdgeInsets.all(4),
                                              child: pw.Text('Recived Amount'),
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
                                              child: pw.Text(recived.toString()),
                                            ),
                                          ]
                                      ),
                                      pw.TableRow(
                                          decoration: pw.BoxDecoration(color: PdfColors.blue100,),
                                          children: [
                                            pw.Padding(
                                              padding: const pw.EdgeInsets.all(4),
                                              child: pw.Text(''),
                                            ),
                                            pw.Padding(
                                              padding: const pw.EdgeInsets.all(4),
                                              child: pw.Text('Due'),
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
                                              child: pw.Text(due.toString()),
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
                                  child: pw.Text(totalPrice.toString()),
                                ),
                              ]
                          ),
                          pw.TableRow(
                              decoration: pw.BoxDecoration(color: PdfColors.blue100,),
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(4),
                                  child: pw.Text(''),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(4),
                                  child: pw.Text('Recived Amount'),
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
                                  child: pw.Text(recived.toString()),
                                ),
                              ]
                          ),
                          pw.TableRow(
                              decoration: pw.BoxDecoration(color: PdfColors.blue100,),
                              children: [
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(4),
                                  child: pw.Text(''),
                                ),
                                pw.Padding(
                                  padding: const pw.EdgeInsets.all(4),
                                  child: pw.Text('Due'),
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
                                  child: pw.Text(due.toString()),
                                ),
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
                )
              ]
          );//For all page between first and last page
        },
      ),
    );
  }

  return pdf.save();
}