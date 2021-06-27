class UserModel {
  bool status;
  User user;

  UserModel({this.status, this.user});

  UserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class User {
  String id;
  String merchantId;
  Null commissaryId;
  String thumbnail;
  String bthumbnail;
  String fname;
  String lname;
  String staff;
  Null businessName;
  Null businessType;
  String address;
  Null tin;
  String contactNo;
  String bdate;
  String email;
  Null emailVerifiedAt;
  String role;
  int loginAccount;
  int active;
  int activeLog;
  String activeLogTime;
  String loads;
  String unlimitedLoad;
  String createdAt;
  String updatedAt;
  Null deletedAt;

  User(
      {this.id,
        this.merchantId,
        this.commissaryId,
        this.thumbnail,
        this.bthumbnail,
        this.fname,
        this.lname,
        this.staff,
        this.businessName,
        this.businessType,
        this.address,
        this.tin,
        this.contactNo,
        this.bdate,
        this.email,
        this.emailVerifiedAt,
        this.role,
        this.loginAccount,
        this.active,
        this.activeLog,
        this.activeLogTime,
        this.loads,
        this.unlimitedLoad,
        this.createdAt,
        this.updatedAt,
        this.deletedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    merchantId = json['merchant_id'];
    commissaryId = json['commissary_id'];
    thumbnail = json['thumbnail'];
    bthumbnail = json['bthumbnail'];
    fname = json['fname'];
    lname = json['lname'];
    staff = json['staff'];
    businessName = json['business_name'];
    businessType = json['business_type'];
    address = json['address'];
    tin = json['tin'];
    contactNo = json['contact_no'];
    bdate = json['bdate'];
    email = json['email'];
    emailVerifiedAt = json['email_verified_at'];
    role = json['role'];
    loginAccount = json['login_account'];
    active = json['active'];
    activeLog = json['active_log'];
    activeLogTime = json['active_log_time'];
    loads = json['loads'];
    unlimitedLoad = json['unlimited_load'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['merchant_id'] = this.merchantId;
    data['commissary_id'] = this.commissaryId;
    data['thumbnail'] = this.thumbnail;
    data['bthumbnail'] = this.bthumbnail;
    data['fname'] = this.fname;
    data['lname'] = this.lname;
    data['staff'] = this.staff;
    data['business_name'] = this.businessName;
    data['business_type'] = this.businessType;
    data['address'] = this.address;
    data['tin'] = this.tin;
    data['contact_no'] = this.contactNo;
    data['bdate'] = this.bdate;
    data['email'] = this.email;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['role'] = this.role;
    data['login_account'] = this.loginAccount;
    data['active'] = this.active;
    data['active_log'] = this.activeLog;
    data['active_log_time'] = this.activeLogTime;
    data['loads'] = this.loads;
    data['unlimited_load'] = this.unlimitedLoad;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
