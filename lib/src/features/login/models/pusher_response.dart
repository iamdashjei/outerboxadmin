class PusherResponse {
  Message message;

  PusherResponse({this.message});

  PusherResponse.fromJson(Map<String, dynamic> json) {
    message =
    json['message'] != null ? new Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.message != null) {
      data['message'] = this.message.toJson();
    }
    return data;
  }
}

class Message {
  String status;
  List<PusherOrders> orders;
  String tableId;
  int type;

  Message({this.status, this.orders, this.tableId, this.type});

  Message.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['orders'] != null) {
      orders = new List<PusherOrders>();
      json['orders'].forEach((v) {
        orders.add(new PusherOrders.fromJson(v));
      });
    }
    tableId = json['table_id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.orders != null) {
      data['orders'] = this.orders.map((v) => v.toJson()).toList();
    }
    data['table_id'] = this.tableId;
    data['type'] = this.type;
    return data;
  }
}

class PusherOrders {
  String quantity;
  String id;
  bool isComplete;
  bool dineIn;
  String transactionItem;
  String price;

  PusherOrders(
      {this.quantity,
        this.id,
        this.isComplete,
        this.transactionItem,
        this.dineIn,
        this.price});

  PusherOrders.fromJson(Map<String, dynamic> json) {
    quantity = json['quantity'];
    id = json['id'];
    isComplete = json['isComplete'];
    transactionItem = json['transaction_item'];
    dineIn = json['dine_in'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['quantity'] = this.quantity;
    data['id'] = this.id;
    data['isComplete'] = this.isComplete;
    data['dine_in'] = this.dineIn;
    data['transaction_item'] = this.transactionItem;
    data['price'] = this.price;
    return data;
  }
}
