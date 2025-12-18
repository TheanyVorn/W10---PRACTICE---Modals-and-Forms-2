import 'package:flutter/material.dart';
import '../../models/expense.dart';

class ExpenseForm extends StatefulWidget {
  const ExpenseForm({super.key});

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _titleController = TextEditingController();
  // controller to store the amount the user enters
  final _amountController = TextEditingController();
  // state to track which category user selected in dropdown
  late Category _selectedCategory = Category.food;
  // state to store the date user selected from date picker
  DateTime? _selectedDate;

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    // clean up the amount controller when we're done
    _amountController.dispose();
  }

  void onCreate() {
    String title = _titleController.text;
    double amount = double.tryParse(_amountController.text) ?? 0;
    // use the category user selected from dropdown
    Category category = _selectedCategory;
    // use the date user selected, or today's date if none selected
    DateTime date = _selectedDate ?? DateTime.now();

    Expense newExpense = Expense(
      title: title,
      amount: amount,
      date: date,
      category: category,
    );

    //send the new expense back to the parent screen
    Navigator.pop(context, newExpense);
  }

  void onCancel() {
    // close the modal without returning anything
    Navigator.pop(context);
  }

  // method to open date picker and get selected date
  Future<void> _presentDatePicker() async {
    // open the date picker and wait for user to select a date
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    // if user selected a date, update the state
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _titleController,
            decoration: InputDecoration(label: Text("Title")),
            maxLength: 50,
          ),
          // amount field with $ symbol prefix
          TextField(
            controller: _amountController,
            // shows $ symbol before user input
            decoration: InputDecoration(
              label: Text("Amount"),
              prefix: Text("\$ "), // $ symbol appears at the start
            ),
            keyboardType: TextInputType.number,
            maxLength: 50,
          ),
          // dropdown to let user pick a category
          DropdownButton<Category>(
            isExpanded: true,
            value: _selectedCategory,
            // show all available categories in uppercase
            items: Category.values
                .map(
                  (category) => DropdownMenuItem(
                    value: category,
                    child: Text(category.name.toUpperCase()),
                  ),
                )
                .toList(),
            // update the selected category when user picks one
            onChanged: (Category? newCategory) {
              if (newCategory != null) {
                setState(() {
                  _selectedCategory = newCategory;
                });
              }
            },
          ),
          // date picker composed of text and icon button
          Row(
            children: [
              // show the selected date or message if no date selected
              Text(
                _selectedDate != null
                    ? 'Date: ${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}'
                    : 'No date selected',
              ),
              IconButton(
                // open date picker when user taps the icon
                onPressed: _presentDatePicker,
                icon: Icon(Icons.calendar_today),
              ),
            ],
          ),
          ElevatedButton(onPressed: onCancel, child: Text("Cancel")),
          SizedBox(width: 10),
          ElevatedButton(onPressed: onCreate, child: Text("Save Expense")),
        ],
      ),
    );
  }
}
