import 'package:flutter/material.dart';
import 'package:outerboxadmin/src/features/database/database_helper.dart';
import 'package:outerboxadmin/src/models/business_info.dart';
import 'package:outerboxadmin/src/models/current_user.dart';
import 'package:outerboxadmin/src/models/headoffice_details.dart';
import 'package:outerboxadmin/src/models/store_details.dart';
import 'package:outerboxadmin/src/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSessions {
  static Future<CurrentUser> getLoggedIn() async {
    SharedPreferences _prefs = await _sharedPreference();
    final status = _prefs.getString(loggedIn);
    final username = _prefs.getString(USERNAME);
    final userAvatar = _prefs.getString(USER_AVATAR);
    CurrentUser user = new CurrentUser();
    user.username = username;
    user.status = status;
    user.userAvatar = userAvatar;

    //print("Current User => " + user.status);
    return user;
  }

  static Future<String> getBearerToken() async {
    SharedPreferences _prefs = await _sharedPreference();
    return _prefs.getString(bearerToken);
  }

  static setBearerToken(String bearer) async {
    SharedPreferences _prefs = await _sharedPreference();
    return _prefs.setString(bearerToken, "Bearer $bearer");
  }

  static setMerchantId(String merchantId) async {
    SharedPreferences _prefs = await _sharedPreference();
    return _prefs.setString(MERCHANT_ID, merchantId);
  }

  static setUsername(String username) async {
    SharedPreferences _prefs = await _sharedPreference();
    return _prefs.setString(USERNAME, username);
  }

  static Future<String> getUsername() async {
    SharedPreferences _prefs = await _sharedPreference();
    return _prefs.getString(USERNAME);
  }

  static setUserAvatar(String avatar) async {
    SharedPreferences _prefs = await _sharedPreference();
    // return _prefs.setString(USER_AVATAR, "https://outerboxpos.com/img/business/$avatar");
    return _prefs.setString(USER_AVATAR, "http://posweb.outerbox.net/img/$avatar");
  }

  static Future<String> getUserAvatar() async {
    SharedPreferences _prefs = await _sharedPreference();
    return _prefs.getString(USER_AVATAR);
  }

  static Future<String> getMerchantId() async {
    SharedPreferences _prefs = await _sharedPreference();
    return _prefs.getString(MERCHANT_ID);
  }

  static setLoggedIn() async {
    SharedPreferences _prefs = await _sharedPreference();
    _prefs.setString(loggedIn, 'Login');
  }

  static setFirstAPICall() async {
    SharedPreferences _prefs = await _sharedPreference();
    _prefs.setBool(firstCall, true);
  }

  static setPrinterConnected() async {
    SharedPreferences _prefs = await _sharedPreference();
    _prefs.setBool("PrinterConnected", true);
  }

  static Future<bool> getPrinterConnected() async {
    SharedPreferences _prefs = await _sharedPreference();
    final status = _prefs.getBool("PrinterConnected");
    return status;
  }

  static Future<bool> getFirstAPICall() async {
    SharedPreferences _prefs = await _sharedPreference();
    final status = _prefs.getBool(firstCall);
    return status;
  }

  // static logout() async {
  //   SharedPreferences _prefs = await _sharedPreference();
  //   _prefs.setBool(loggedIn, false);
  // }

  static setLoggedOut() async {

    SharedPreferences _prefs = await _sharedPreference();

    await _prefs.setString(loggedIn, '');
    await setBearerToken('');
    await setMerchantId('');
    await savePinCode('');
    await DatabaseHelper().deleteDatabaseLogout();
    //await _prefs.clear();
  }

  static setBluetoothDevice(String mac) async {
    SharedPreferences _prefs = await _sharedPreference();
    _prefs.setString("btDevice", mac);
  }

  static Future<String> getBluetoothDevice() async {
    SharedPreferences _prefs = await _sharedPreference();
    final status = _prefs.getString("btDevice");
    return status;
  }

  static Future<SharedPreferences> _sharedPreference() async {
    return SharedPreferences.getInstance();
  }

  static Future<int> getLastLogoutTime() async {
    SharedPreferences _prefs = await _sharedPreference();
    final status = _prefs.getInt(lastLogoutTime);
    return status;
  }

  static savePinCode(String key) async {
    SharedPreferences _prefs = await _sharedPreference();
    _prefs.setString("key", '$key');
  }

  static Future<String> getPinCode() async {
    SharedPreferences _prefs = await _sharedPreference();
    return _prefs.getString("key") ?? '';
  }

  static Future<bool> isCompletedList() async {
    SharedPreferences _prefs = await _sharedPreference();
    final status = _prefs.getBool("completed") ?? false;
    return status;
  }

  static setCompletedList({@required bool isCompleted}) async {
    SharedPreferences _prefs = await _sharedPreference();
    _prefs.setBool("completed", isCompleted);
  }

  static saveRecentUsers(List<String> key) async {
    SharedPreferences _prefs = await _sharedPreference();
    _prefs.setStringList("recentUsers", key);
  }

  static Future<List<String>> getRecentUsers() async {
    SharedPreferences _prefs = await _sharedPreference();
    return _prefs.getStringList("recentUsers") ?? [];
  }

  static saveLastLogin(String key) async {
    SharedPreferences _prefs = await _sharedPreference();
    _prefs.setString("loginDate", '$key');
  }

  static Future<String> getLastLogin() async {
    SharedPreferences _prefs = await _sharedPreference();
    return _prefs.getString("loginDate") ?? '';
  }

  static saveAdminDetails(String kitchenUserName, String merchantId) async {
    SharedPreferences _prefs = await _sharedPreference();
    _prefs.setString("kitchenDetails", '$kitchenUserName,$merchantId');
  }

  static saveAdminUID(String uid) async {
    SharedPreferences _prefs = await _sharedPreference();
    _prefs.setString("adminUID", uid);
  }

  static saveHeadOfficeId(String id) async {
    SharedPreferences _prefs = await _sharedPreference();
    _prefs.setString("headOfficeId", id);
  }

  static saveEmail(String email) async {
    SharedPreferences _prefs = await _sharedPreference();
    _prefs.setString("userEmail", email);
  }

  static savePassword(String password) async {
    SharedPreferences _prefs = await _sharedPreference();
    _prefs.setString("userPassword", password);
  }

  static saveCommissaryId(String id) async {
    SharedPreferences _prefs = await _sharedPreference();
    _prefs.setString("commissaryId", id);
  }

  static saveClusterId(String id) async {
    SharedPreferences _prefs = await _sharedPreference();
    _prefs.setString("clusterId", id);
  }

  static saveAdminRole(String type) async {
    SharedPreferences _prefs = await _sharedPreference();
    _prefs.setString("adminType", type);
  }

  static Future<BusinessInfo> getAdminDetails() async {
    SharedPreferences _prefs = await _sharedPreference();
    String uid = await getAdminUID();
    String type = await getAdminRole();
    String merchantId = await getMerchantId();
    String headOfficeId = await getHeadOfficeId();
    String commissaryId = await getCommissaryId();
    String clusterId = await getClusterId();
   // StoreDetails data = await DatabaseHelper().getStoreDetails();
    HeadOfficeDetails image = await DatabaseHelper().getHeadOfficeDetails();
    BusinessInfo info = new BusinessInfo();
    info.cashierName = _prefs.getString("kitchenDetails").split(',')[0] ?? '';
    info.merchantId = merchantId;
    info.headOfficeId = headOfficeId;
    info.salesId = "none";
    info.accountType = type;
    info.uid = uid;
    info.commissaryId = commissaryId;
    info.clusterId = clusterId;
    return info;
  }

  static Future<String> getAdminUID() async {
    SharedPreferences _prefs = await _sharedPreference();
    return _prefs.getString("adminUID") ?? '';
  }

  static Future<String> getAdminRole() async {
    SharedPreferences _prefs = await _sharedPreference();
    return _prefs.getString("adminType") ?? '';
  }

  static Future<String> getHeadOfficeId() async {
    SharedPreferences _prefs = await _sharedPreference();
    return _prefs.getString("headOfficeId") ?? '';
  }

  static Future<String> getCommissaryId() async {
    SharedPreferences _prefs = await _sharedPreference();
    return _prefs.getString("commissaryId") ?? '';
  }

  static Future<String> getUserEmail() async {
    SharedPreferences _prefs = await _sharedPreference();
    return _prefs.getString("userEmail") ?? '';
  }

  static Future<String> getUserPassword() async {
    SharedPreferences _prefs = await _sharedPreference();
    return _prefs.getString("userPassword") ?? '';
  }

  static Future<String> getClusterId() async {
    SharedPreferences _prefs = await _sharedPreference();
    return _prefs.getString("clusterId") ?? '';
  }

}