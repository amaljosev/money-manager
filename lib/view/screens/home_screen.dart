import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneymanager/controller/expense/expense_controller.dart';
import 'package:moneymanager/controller/income/income_controller.dart';
import 'package:moneymanager/view/widgets/my_form.dart';

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
    final expenseCtrl = Get.put(ExpenceController());
    final incomeCtrl = Get.put(IncomeController());
    return Obx(() => Scaffold(
          appBar: AppBar(
            title: const Text('Money Manager'),
            backgroundColor: const Color.fromARGB(255, 53, 49, 59),
            bottom: TabBar(
                controller: expenseController.tabController,
                tabs: const [
                  Tab(text: 'Expense'),
                  Tab(text: 'Income'),
                ]),
          ),
          body: TabBarView(
            controller: expenseCtrl.tabController,
            children: [
              SizedBox(
                child: ListView.builder(
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(expenseCtrl.expenses[index]['title']),
                        subtitle:
                            Text("₹${expenseCtrl.expenses[index]['expense']}"),
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
              SizedBox(
                child: ListView.builder(
                    itemBuilder: (context, index) {
                      return ListTile(
                        title:
                            Text(incomeCtrl.incomeCollection[index]['source']),
                        subtitle: Text(
                            "₹${incomeCtrl.incomeCollection[index]['amount']}"),
                        trailing: IconButton(
                            onPressed: () {
                              incomeCtrl.delete(
                                  incomeCtrl.incomeCollection[index]['id']);
                              incomeCtrl.refreshIcomeTable();
                            },
                            icon: const Icon(Icons.delete_outline_outlined)),
                        onTap: () => expenseCtrl.showForm(
                            incomeCtrl.incomeCollection[index]['id'], context),
                      );
                    },
                    itemCount: incomeCtrl.incomeCollection.length),
              )
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => expenseCtrl.showForm(null, context), 
            label: const Text('Add'),
            icon: const Icon(Icons.add),
          ),
        ));
  }
}
