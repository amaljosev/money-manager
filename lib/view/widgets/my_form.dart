import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneymanager/controller/expense/expense_controller.dart';
import 'package:moneymanager/controller/income/income_controller.dart';
import 'package:moneymanager/model/income_model.dart';

final expenseController = Get.find<ExpenceController>();
final incomeController = Get.find<IncomeController>();

enum Category { expense, income }

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
    return Obx(() => Form(
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Radio<Category>(
                          value: Category.expense,
                          groupValue: expenseController.category.value,
                          onChanged: isUpdate.value
                              ? (Category? value) {}
                              : (Category? value) =>
                                  expenseController.category.value = value!,
                        ),
                        const Text('Expense'),
                        Radio<Category>(
                          value: Category.income,
                          groupValue: expenseController.category.value,
                          onChanged: isUpdate.value
                              ? (Category? value) {}
                              : (Category? value) =>
                                  expenseController.category.value = value!,
                        ),
                        const Text('Income'),
                      ],
                    ),
                    Row(
                      children: [
                        ElevatedButton(
                            onPressed: expenseController.isLoading.value
                                ? () {}
                                : expenseController.category.value ==
                                        Category.expense
                                    ? () async {
                                        if (expenseController
                                            .formKey.currentState!
                                            .validate()) {
                                          expenseController.isLoading.value =
                                              true;
                                          isUpdate.value
                                              ? await expenseController
                                                  .updateItem(
                                                      id,
                                                      expenseController
                                                          .titleController.text,
                                                      int.parse(expenseController
                                                          .expenseController
                                                          .text))
                                              : await expenseController
                                                  .createExpense(
                                                      expenseController
                                                          .titleController.text,
                                                      int.parse(
                                                          expenseController
                                                              .expenseController
                                                              .text));

                                          expenseController
                                              .titleController.text = '';
                                          expenseController
                                              .expenseController.text = '';
                                          expenseController.isLoading.value =
                                              false;
                                          Get.back();
                                          expenseController.refreshAllData();
                                        }
                                      }
                                    : () async {
                                        final incomeData = IncomeModel(
                                            id: id,
                                            amount: int.parse(expenseController
                                                .expenseController.text),
                                            source: expenseController
                                                .titleController.text);
                                        if (expenseController
                                            .formKey.currentState!
                                            .validate()) {
                                          expenseController.isLoading.value =
                                              true;
                                          isUpdate.value
                                              ? await incomeController
                                                  .updateIncome(incomeData)
                                              : await incomeController
                                                  .insertIncome(incomeData);

                                          expenseController
                                              .titleController.text = '';
                                          expenseController
                                              .expenseController.text = '';
                                          expenseController.isLoading.value =
                                              false;
                                          Get.back();
                                          incomeController.refreshIcomeTable();
                                        }
                                      },
                            child: Text(isUpdate.value ? 'Update' : 'Add')),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
