import 'package:outerboxadmin/src/models/headoffice_details.dart';
import 'package:outerboxadmin/src/models/staff_details.dart';
import 'package:outerboxadmin/src/models/store_details.dart';
import 'package:outerboxadmin/src/models/store_merchant_details.dart';

class Resource {

  HeadOfficeDetails headOfficeDetails;
  StoreDetails storeDetails;
  StaffDetails staffDetails;

  Resource({
    this.headOfficeDetails,
    this.storeDetails,
    this.staffDetails
  });

  Resource.fromJson(Map<String, dynamic> json) {
    headOfficeDetails = json['hoffice_details'] != null ? new HeadOfficeDetails.fromJson(json['hoffice_details']) : null;
    storeDetails = json['store_details'] != null ? new StoreDetails.fromJson(json['store_details']) : null;
    staffDetails = json['user'] != null ? new StaffDetails.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.headOfficeDetails != null) {
      data['hoffice_details'] = this.headOfficeDetails.toJson();
    }

    if (this.storeDetails != null) {
      data['store_details'] = this.storeDetails.toJson();
    }

    if (this.staffDetails != null) {
      data['user'] = this.staffDetails.toJson();
    }

    return data;
  }

}