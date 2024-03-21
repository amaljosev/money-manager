import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneymanager/controller/expense/expense_controller.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    final expenseCtrl = Get.put(ExpenceController());
    final size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Money Manager'),
          backgroundColor: const Color.fromARGB(255, 53, 49, 59),
          bottom: const TabBar(tabs: [
            Tab(text: 'Expense'),
            Tab(text: 'Income'),
          ]),
        ),
        body: Obx(() => TabBarView(
              children: [
                SizedBox(
                  width: size.width,
                  height: size.height,
                  child: ListView.builder(
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(expenseCtrl.expenses[index]['title']),
                          subtitle: Text(
                              "₹${expenseCtrl.expenses[index]['expense']}"),
                          trailing: IconButton(
                              onPressed: () {
                                expenseCtrl.deleteItem(
                                    expenseCtrl.expenses[index]['id']);
                                expenseCtrl.refreshAllData();
                              },
                              icon: const Icon(Icons.delete_outline_outlined)),
                          onTap: () => expenseCtrl.showForm(
                              expenseCtrl.expenses[index]['id'], context),
                        );
                      },
                      itemCount: expenseCtrl.expenses.length),
                ),
                Container(
                  width: size.width,
                  height: size.height,
                  color: Colors.deepPurple,
                )
              ],
            )),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => expenseCtrl.showForm(null, context),
          label: const Text('Add'),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }
}
