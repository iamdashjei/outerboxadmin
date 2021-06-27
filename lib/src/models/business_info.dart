class BusinessInfo {
  String businessName;
  String businessLogo;
  String cashierName;
  String merchantId;
  String commissaryId;
  String clusterId;
  String salesId;
  String headOfficeId;
  String accountType;
  String uid;

  BusinessInfo({
    this.businessName,
    this.businessLogo,
    this.cashierName,
    this.merchantId,
    this.commissaryId,
    this.clusterId,
    this.salesId,
    this.accountType,
    this.uid,
    this.headOfficeId
  });

  BusinessInfo.fromJson(Map<String, dynamic> json) {
    businessName = json['businessName'];
    businessLogo = json['businessLogo'];
    cashierName = json['cashierName'];
    merchantId = json['merchantId'];
    commissaryId = json['commissaryId'];
    clusterId = json['clusterId'];
    salesId = json['salesId'];
    headOfficeId = json['headOfficeId'];
  }

  Map<String,dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['businessName'] = businessName;
    data['businessLogo'] = businessLogo;
    data['cashierName'] = cashierName;
    data['merchantId'] = merchantId;
    data['commissaryId'] = commissaryId;
    data['clusterId'] = clusterId;
    data['salesId'] = salesId;
    data['headOfficeId'] = headOfficeId;
    return data;
  }
}