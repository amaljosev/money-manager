import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneymanager/controller/expense/expense_controller.dart';

final expenseController = Get.find<ExpenceController>();

class MyForm extends StatelessWidget {
  const MyForm({
    super.key,
    required this.isUpdate,
    required this.id,
  });
  final RxBool isUpdate;
  final int id;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: expenseController.formKey,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextFormField(
              controller: expenseController.titleController,
              decoration: const InputDecoration(hintText: 'Title'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a title' : null,
            ),
            const SizedBox(
              height: 30,
            ),
            TextFormField(
              controller: expenseController.expenseController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Expense'),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter an expense' : null,
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    onPressed: expenseController.isLoading.value
                        ? () {}
                        : () async {
                            if (expenseController.formKey.currentState!
                                .validate()) {
                              expenseController.isLoading.value = true;
                              isUpdate.value
                                  ? await expenseController.updateItem(
                                      id,
                                      expenseController.titleController.text,
                                      int.parse(expenseController
                                          .expenseController.text))
                                  : await expenseController.createExpense(
                                      expenseController.titleController.text,
                                      int.parse(expenseController
                                          .expenseController.text));

                              expenseController.titleController.text = '';
                              expenseController.expenseController.text = '';
                              expenseController.isLoading.value = false;
                              Get.back();
                              expenseController.refreshAllData();
                            }
                          },
                    child: Text(
                        isUpdate.value ? 'Update Expense' : 'Add Expense')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
