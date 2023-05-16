class Order {
 late Map<String, dynamic> details;
 late List<Item> itemList;

  Order({required this.details, required this.itemList});

  Order.fromJson(Map<String, dynamic> json) {
    details = json['details'];
    if (json['itemList'] != null) {
      itemList = [];
      json['itemList'].forEach((v) {
        itemList.add(Item.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['details'] = this.details;
    if (this.itemList != null) {
      data['itemList'] = this.itemList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Item {
 late String qitemId;
 late String qitemPrice;
 late String qitemQuantity;
 late String qitemStock;
 late String qitemTitle;
 late String qitemTotalPrice;
 late String qitemUom;

  Item({
    required this.qitemId,
    required this.qitemPrice,
    required this.qitemQuantity,
    required this.qitemStock,
    required this.qitemTitle,
    required this.qitemTotalPrice,
    required this.qitemUom,
  });

  Item.fromJson(Map<String, dynamic> json) {
    qitemId = json['qitemId'];
    qitemPrice = json['qitemPrice'];
    qitemQuantity = json['qitemQuantity'];
    qitemStock = json['qitemStock'];
    qitemTitle = json['qitemTitle'];
    qitemTotalPrice = json['qitemTotalPrice'];
    qitemUom = json['qitemUom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['qitemId'] = this.qitemId;
    data['qitemPrice'] = this.qitemPrice;
    data['qitemQuantity'] = this.qitemQuantity;
    data['qitemStock'] = this.qitemStock;
    data['qitemTitle'] = this.qitemTitle;
    data['qitemTotalPrice'] = this.qitemTotalPrice;
    data['qitemUom'] = this.qitemUom;
    return data;
  }
}
