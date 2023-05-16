class Ledger {
  String billNo;
  String cashReceive;
  String companyName;
  String due;
  String issueDate;
  String memoNo;

  Ledger({
    required this.billNo,
    required this.cashReceive,
    required this.companyName,
    required this.due,
    required this.issueDate,
    required this.memoNo,
  });

  factory Ledger.fromJson(Map<String, dynamic> json) {
    return Ledger(
      billNo: json['billNo'].toString(),
      cashReceive: json['cashRecive'].toString(),
      companyName: json['companyName'].toString(),
      due: json['due'].toString(),
      issueDate: json['issueDate'].toString(),
      memoNo: json['memoNo'].toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'billNo': billNo,
    'cashReceive': cashReceive,
    'companyName': companyName,
    'due': due,
    'issueDate': issueDate,
    'memoNo': memoNo,
  };
}
