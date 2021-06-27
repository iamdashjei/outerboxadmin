class StaffDetails {
  String id;
  String hOfficeId;
  String merchantId;
  String commissaryId;
  String clusterId;
  String fName;
  String lName;
  String email;
  String role;
  String createdAt;
  String accountType;

  StaffDetails({
    this.id,
    this.hOfficeId,
    this.merchantId,
    this.commissaryId,
    this.clusterId,
    this.fName,
    this.lName,
    this.email,
    this.role,
    this.createdAt,
    this.accountType
  });

  StaffDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    hOfficeId = json['hoffice_id'];
    merchantId = json['merchant_id'];
    commissaryId = json['commissary_id'];
    clusterId = json['cluster_id'];
    fName = json['fname'];
    lName = json['lname'];
    email = json['email'];
    role = json['role'];
    createdAt = json['created_at'];
    accountType = json['account_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['hoffice_id'] = hOfficeId;
    data['merchant_id'] = merchantId;
    data['commissary_id'] = commissaryId;
    data['cluster_id'] = clusterId;
    data['fname'] = fName;
    data['lname'] = lName;
    data['email'] = email;
    data['role'] = role;
    data['created_at'] = createdAt;
    data['account_type'] = accountType;
    return data;
  }

}