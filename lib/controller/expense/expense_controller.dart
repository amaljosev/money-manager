import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneymanager/view/widgets/my_form.dart';
import 'package:sqflite/sqflite.dart' as sql;

class ExpenceController extends GetxController
    with GetTickerProviderStateMixin {
  RxList<Map<String, dynamic>> expenses = <Map<String, dynamic>>[].obs;
  var category = Category.expense.obs;
  final formKey = GlobalKey<FormState>();
  RxInt expenseId = 0.obs;
  RxBool isUpdate = false.obs;
  RxBool isLoading = false.obs;
  final titleController = TextEditingController();
  final expenseController = TextEditingController();
  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    refreshAllData();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  void refreshAllData() async {
    final controller = ExpenceController();
    final data = await controller.getItems();
    expenses.value = data;
  }

  Future<void> createTable(sql.Database database) async {
    await database.execute('''CREATE TABLE expense_db (
      id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      title TEXT,
      expense INTEGER,
      created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP)''');
  }

  Future<sql.Database> db() async {
    return sql.openDatabase('expense_db', version: 1,
        onCreate: (sql.Database database, int version) async {
      log('....creating table.....');
      await createTable(database);
    });
  }

  Future<int> createExpense(String title, int expense) async {
    final controller = ExpenceController();
    final db = await controller.db();
    final data = {'title': title, 'expense': expense};
    final id = await db.insert('expense_db', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  Future<List<Map<String, dynamic>>> getItems() async {
    final controller = ExpenceController();
    final db = await controller.db();
    return db.query('expense_db', orderBy: 'id');
  }

  Future<List<Map<String, dynamic>>> getItem(int id) async {
    final controller = ExpenceController();
    final db = await controller.db();
    return db.query('expense_db', where: 'id=?', whereArgs: [id]);
  }

  Future<int> updateItem(int id, String title, int expense) async {
    final controller = ExpenceController();
    final db = await controller.db();
    final data = {
      'title': title,
      'expense': expense,
      'created_at': DateTime.now().toString()
    };
    final result =
        await db.update('expense_db', data, where: 'id=?', whereArgs: [id]);
    return result;
  }

  Future<void> deleteItem(int id) async {
    final controller = ExpenceController();
    final db = await controller.db();
    try {
      await db.delete('expense_db', where: 'id=?', whereArgs: [id]);
    } catch (e) {
      log(e.toString());
    }
  }

  void showForm(int? id, BuildContext context) {
    if (id != null) {
      final expense = expenses.firstWhere((element) => element['id'] == id);
      titleController.text = expense['title'];
      expenseController.text = expense['expense'].toString();
      expenseId.value = expense['id'];
      isUpdate.value = true;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      constraints: const BoxConstraints(maxHeight: 600),
      builder: (context) {
        return MyForm(isUpdate: isUpdate, id: expenseId.value);
      },
      elevation: 5,
    );
  }
}
