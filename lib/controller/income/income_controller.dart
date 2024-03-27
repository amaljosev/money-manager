import 'dart:developer';

import 'package:get/get.dart';
import 'package:moneymanager/model/income_model.dart';
import 'package:sqflite/sqflite.dart' as sql;

class IncomeController extends GetxController {
  RxList<Map<String, dynamic>> incomeCollection = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    refreshIcomeTable();
  }
  

  refreshIcomeTable() async {
    final ctrl = IncomeController();
    final data = await ctrl.getItems();
    incomeCollection.value = data;
  }

  
  Future<void> createTable(sql.Database database) async {
    await database.execute('''CREATE TABLE income_db(
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
      amount INTEGER,
      source TEXT,
      date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
    )''');
  }

  Future<sql.Database> db() async {
    return sql.openDatabase(
      'income_db',
      version: 1,
      onCreate: (db, version) async {
        log('...creating income db');
        await createTable(db);
      },
    );
  }

  Future<int> insertIncome(IncomeModel income) async {
    final ctrl = IncomeController();
    final db = await ctrl.db();
    int response = await db.insert(
        'income_db', {'amount': income.amount, 'source': income.source},
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return response;
  }

  Future<List<Map<String, dynamic>>> getItems() async {
    final ctrl = IncomeController();
    final db = await ctrl.db();
    return db.query('income_db', orderBy: 'id');
  }

  Future<List<Map<String, dynamic>>> getItem(int id) async {
    final ctrl = IncomeController();
    final db = await ctrl.db();
    return db.query('income_db', where: 'id=?', whereArgs: [id]);
  }

  Future<int> updateIncome(IncomeModel income) async {
    final ctrl = IncomeController();
    final db = await ctrl.db();
    final response = await db.update(
        'income_db',
        {
          'amount': income.amount,
          'source': income.source,
          'date': DateTime.now().toString()
        },
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return response;
  }

  Future<int> delete(int id) async {
    final ctrl = IncomeController();
    final db = await ctrl.db();
    final response = db.delete('income_db', where: 'id=?', whereArgs: [id]);
    return response;
  }
}
