import 'dart:io';

import 'package:flutter/material.dart';
import 'package:outerboxadmin/src/models/headoffice_details.dart';
import 'package:outerboxadmin/src/models/store_details.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

class DatabaseHelper {
  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return _db;
  }

  initDatabase() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'kitchen.db');
    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (e) {
      print(e);
    }
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE tblStoreDetails ('
        'storeId INTEGER PRIMARY KEY AUTOINCREMENT,'
        'id TEXT,'
        'user_id TEXT,'
        'device_id TEXT,'
        'business_name TEXT,'
        'address TEXT,'
        'tin TEXT,'
        'bir_num TEXT,'
        'transaction_no TEXT,'
        'contact_no TEXT,'
        'account_type TEXT,'
        'created_at TEXT,'
        'updated_at TEXT'
        ')',
    );
    await db.execute('CREATE TABLE tblHeadOfficeDetails ('
        'headOfficeId INTEGER PRIMARY KEY AUTOINCREMENT,'
        'id TEXT,'
        'user_id TEXT,'
        'bthumbnail TEXT,'
        'bthumbnailBlob BLOB,'
        'business_name TEXT,'
        'business_type TEXT,'
        'address TEXT,'
        'tin TEXT,'
        'contact_no TEXT,'
        'r_header TEXT,'
        'r_footer TEXT,'
        'vat_enable INTEGER,'
        'vat_percentages TEXT,'
        'acred_num TEXT,'
        'date_issued TEXT,'
        'valid_until TEXT,'
        'final_permit_used TEXT,'
        'created_at TEXT,'
        'updated_at TEXT'
        ')',
    );
  }

  Future deleteDatabaseLogout() async {
    var dbClient = await db;
    await dbClient.rawDelete('DELETE FROM tblStoreDetails');
    await dbClient.rawDelete('DELETE FROM tblHeadOfficeDetails');

  }



  Future<StoreDetails> getStoreDetails() async {
    var dbClient = await db;
    var data = await dbClient.rawQuery('SELECT * FROM tblStoreDetails');

    if(data != null){
      return data.map((e) => StoreDetails.fromJson(e)).first;
    } else {
      return null;
    }
  }

  Future<void> insertStoreDetails({
    @required StoreDetails storeDetails
  }) async {
    var dbClient = await db;
    await dbClient.insert('tblStoreDetails', storeDetails.toJson());

  }

  Future<HeadOfficeDetails> getHeadOfficeDetails() async {
    var dbClient = await db;
    var headOffice = await dbClient.rawQuery('SELECT * FROM tblHeadOfficeDetails');
    if (headOffice.isNotEmpty) {
      return headOffice.map((e) => HeadOfficeDetails.fromJson(e)).first;
    } else {
      return null;
    }
  }

  Future<void> insertHeadOffice({@required HeadOfficeDetails officeDetails}) async {
    var dbClient = await db;
    await dbClient.insert('tblHeadOfficeDetails', officeDetails.toJson());
  }

}