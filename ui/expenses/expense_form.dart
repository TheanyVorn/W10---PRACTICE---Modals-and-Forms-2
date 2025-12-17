import 'package:flutter/material.dart';
import '../../models/expense.dart';

class ExpenseForm extends StatefulWidget {
  const ExpenseForm({super.key});

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  // Controller to capture the title input from the text field
  final _titleController = TextEditingController();
  // Controller to capture the amount input from the text field
  final _amountController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    // Clean up the title controller when the widget is disposed
    _titleController.dispose();
    // Clean up the amount controller when the widget is disposed
    _amountController.dispose();
  }

  void onCreate() {
    // 1. Get the title from the text field controller
    String title = _titleController.text;
    // 2. Get the amount from the text field and convert to double (or 0 if invalid)
    double amount = double.tryParse(_amountController.text) ?? 0;
    // 3. Set category (hardcoded for now)
    Category category = Category.food;
    // 4. Set the date to today
    DateTime date = DateTime.now();

    // 5. Create a new Expense object with the captured data
    Expense newExpense = Expense(
      title: title,
      amount: amount,
      date: date,
      category: category,
    );

    // 6. Close the modal and return the new expense back to the parent widget
    Navigator.pop(context, newExpense);
  }

  void onCancel() {
    // Close the modal
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title input field
          TextField(
            controller: _titleController,
            decoration: InputDecoration(label: Text("Title")),
            maxLength: 50,
          ),
          // Amount input field - accepts decimal numbers
          TextField(
            controller: _amountController,
            // Added prefix to display $ symbol when user enters amount
            decoration: InputDecoration(
              label: Text("Amount"),
              prefix: Text("\$ "), // Shows $ symbol before the input
            ),
            keyboardType: TextInputType.number,
            maxLength: 50,
          ),
          // Cancel button - closes the modal without returning anything
          ElevatedButton(onPressed: onCancel, child: Text("Cancel")),
          SizedBox(width: 10),
          // Create button - closes the modal and returns the expense
          ElevatedButton(onPressed: onCreate, child: Text("Create")),
        ],
      ),
    );
  }
}
