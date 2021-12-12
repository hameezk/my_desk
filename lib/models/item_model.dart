class ItemModel {
  String? itemId;
  String? itemName;
  String? qty;

  ItemModel({
    this.itemId,
    this.itemName,
    this.qty,
  });

  ItemModel.fromMap(Map<String, dynamic> map) {
    itemId = map["itemId"];
    itemName = map["itemName"];
    qty = map["qty"];
  }

  Map<String, dynamic> toMap() {
    return {
      "itemId": itemId,
      "itemName": itemName,
      "qty": qty,
    };
  }
}
