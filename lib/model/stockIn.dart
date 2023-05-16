class StockIn {
  final String id;
  final String title;
  final String stockIn;
  final String price;
  final String date;
  final String company;

  StockIn({
    required this.id,
    required this.title,
    required this.stockIn,
    required this.price,
    required this.date,
    required this.company,
  });

  factory StockIn.fromJson(Map<String,dynamic>json){
    return StockIn(
        id: json['id'].toString(),
        title: json['title'].toString(),
        stockIn: json['stockIn'].toString(),
        price: json['price'].toString(),
        date: json['date'].toString(),
        company: json['company'].toString()
    );
  }
   Map<String,dynamic> toJson() =>{
        id: id.toString(),
        title: title.toString(),
        stockIn: stockIn.toString(),
        price: price.toString(),
        date: date.toString(),
        company:company.toString()

  };
}
