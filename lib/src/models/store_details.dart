class StoreDetails {
  String id;
  String userId;
  String deviceId;
  String businessName;
  String address;
  String tin;
  String birNum;
  String transactionNo;
  String contactNo;
  String accountType;
  String createdAt;
  String updatedAt;

  StoreDetails(
      {this.id,
        this.userId,
        this.deviceId,
        this.businessName,
        this.address,
        this.tin,
        this.birNum,
        this.transactionNo,
        this.contactNo,
        this.accountType,
        this.createdAt,
        this.updatedAt});

  StoreDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    deviceId = json['device_id'];
    businessName = json['business_name'];
    address = json['address'];
    birNum = json['bir_num'];
    transactionNo = json['transaction_no'];
    tin = json['tin'];
    contactNo = json['contact_no'];
    accountType = json['account_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['device_id'] = this.deviceId;
    data['business_name'] = this.businessName;
    data['address'] = this.address;
    data['tin'] = this.tin;
    data['bir_num'] = this.birNum;
    data['transaction_no'] = this.transactionNo;
    data['transaction_no'] = this.transactionNo;
    data['account_type'] = this.accountType;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
