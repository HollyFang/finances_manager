import 'dart:io';

import 'package:finances_manager/models/account.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:finances_manager/constant.dart';

class AccountApi{
  Future<String> get _dbPath async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, Constant.DB_NAME);

    return path;
  }

  Future<Database> get _localFile async {
    final path = await _dbPath;
    //await deleteDatabase(path);
    Database database = await openDatabase(path, version: 1);
    return database;
  }

  Future<int> saveAccount(String name,double balance,String belongTo) async {
    final db = await _localFile;
    return db.transaction((trx){
      trx.rawInsert( 'INSERT INTO account(name,balance,belongTo) VALUES("$name",$balance,"$belongTo")');
    });
  }

  Future<List<AccountModel>> getExistingAccount() async {
    final db = await _localFile;
    var result;
    try{
      result = await db.rawQuery('SELECT * FROM account');
    }
    catch(ex){
      await db.execute("CREATE TABLE account (id INTEGER PRIMARY KEY, name TEXT, createTime TIMESTAMP default (datetime('now', 'localtime')), closeTime TIMESTAMP,balance DOUBLE,belongTo TEXT)");
      result = await db.rawQuery('SELECT * FROM account');
    }
    List<AccountModel> accountList = result.map<AccountModel>((item) => AccountModel.fromMap(item)).toList();
    return accountList;
  }

  Future<int> deleteAccount(int id) async{
    final db = await _localFile;
    return db.transaction((trx){
      trx.rawDelete("DELETE FROM account WHERE id='$id'");
    });
  }

}