import 'dart:typed_data';

class HeadOfficeDetails {
  String id;
  String userId;
  String businessIcon;
  Uint8List businessIconBlob;
  String businessName;
  String businessType;
  String address;
  String tin;
  String contactNo;
  String rHeader;
  String rFooter;
  int vatEnable;
  String vatPercentages;
  dynamic accreditedNum;
  String dateIssued;
  dynamic validUntil;
  dynamic finalPermitUsed;
  String createdAt;
  String updatedAt;

  HeadOfficeDetails(
      {this.id,
        this.userId,
        this.businessIcon,
        this.businessIconBlob,
        this.businessName,
        this.businessType,
        this.address,
        this.tin,
        this.contactNo,
        this.rHeader,
        this.rFooter,
        this.vatEnable,
        this.vatPercentages,
        this.accreditedNum,
        this.dateIssued,
        this.validUntil,
        this.finalPermitUsed,
        this.createdAt,
        this.updatedAt});

  HeadOfficeDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    businessIcon = json['bthumbnail'];
    businessIconBlob = json['bthumbnailBlob'];
    businessName = json['business_name'];
    businessType = json['business_type'];
    address = json['address'];
    tin = json['tin'];
    contactNo = json['contact_no'];
    rHeader = json['r_header'];
    rFooter = json['r_footer'];
    vatEnable = json['vat_enable'];
    vatPercentages = json['vat_percentages'];
    accreditedNum = json['acred_num'];
    dateIssued = json['date_issued'];
    validUntil = json['valid_until'];
    finalPermitUsed = json['final_permit_used'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['bthumbnail'] = this.businessIcon;
    data['bthumbnailBlob'] = this.businessIconBlob;
    data['business_name'] = this.businessName;
    data['business_type'] = this.businessType;
    data['address'] = this.address;
    data['tin'] = this.tin;
    data['contact_no'] = this.contactNo;
    data['r_header'] = this.rHeader;
    data['r_footer'] = this.rFooter;
    data['vat_enable'] = this.vatEnable;
    data['vat_percentages'] = this.vatPercentages;
    data['acred_num'] = this.accreditedNum;
    data['date_issued'] = this.dateIssued;
    data['valid_until'] = this.validUntil;
    data['final_permit_used'] = this.finalPermitUsed;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
