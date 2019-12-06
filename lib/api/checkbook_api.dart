import 'dart:io';

import 'package:finances_manager/models/checbook.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:finances_manager/constant.dart';

class CheckoutApi{
  Future<String> get _dbPath async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, Constant.DB_NAME);

    return path;
  }

  Future<Database> get _localFile async {
    final path = await _dbPath;
    Database database = await openDatabase(path, version: 1);
    return database;
  }

  Future<int> saveCheckbook(String name) async {
    final db = await _localFile;
    return db.transaction((trx){
      trx.rawInsert( 'INSERT INTO checkbook(name) VALUES("$name")');
    });
  }

  Future<List<CheckBookModel>> getExistingCheckbook() async {
    final db = await _localFile;
    var result;
    try{
      result = await db.rawQuery('SELECT * FROM checkbook');
    }
    catch(ex){
      await db.execute("CREATE TABLE checkbook (id INTEGER PRIMARY KEY, name TEXT, createTime TIMESTAMP default (datetime('now', 'localtime')), closeTime TIMESTAMP)");
      result = await db.rawQuery('SELECT * FROM checkbook');
    }
    List<CheckBookModel> accountList = result.map<CheckBookModel>((item) => CheckBookModel.fromMap(item)).toList();
    return accountList;
  }

  Future<int> deleteCheckbook(int id) async{
    final db = await _localFile;
    return db.transaction((trx){
      trx.rawDelete("DELETE FROM checkbook WHERE id='$id'");
    });
  }

}