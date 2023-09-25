import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart';

class DBHelper {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    final pathString = path.join(dbPath, 'transactions.db');

    return await sql.openDatabase(
      pathString,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE transactions(id TEXT PRIMARY KEY, transactionName TEXT, money TEXT, expenseOrIncome TEXT, date TEXT)',
        );
      },
    );
  }

  static Future<void> insertTransaction(Transaction transaction) async {
    final db = await DBHelper.database();
    await db.insert(
      'transactions',
      transaction.toMap(),
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Transaction>> fetchTransactions() async {
    final db = await DBHelper.database();
    final List<Map<String, dynamic>> maps = await db.query('transactions');
    return List.generate(maps.length, (index) {
      return Transaction.fromMap(maps[index]);
    });
  }

  static Future<void> deleteTransaction(String id) async {
    final db = await DBHelper.database();
    await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

class Transaction {
  final String id;
  final String transactionName;
  final String money;
  final String expenseOrIncome;
  final DateTime date;

  Transaction({
    required this.id,
    required this.transactionName,
    required this.money,
    required this.expenseOrIncome,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'transactionName': transactionName,
      'money': money,
      'expenseOrIncome': expenseOrIncome,
      'date': date.toIso8601String(),
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'],
      transactionName: map['transactionName'],
      money: map['money'],
      expenseOrIncome: map['expenseOrIncome'],
      date: DateTime.parse(map['date']),
    );
  }
}

class TransactionForm extends StatefulWidget {
  final Function(String, String, String, DateTime) addTransaction;
  final Function(String) deleteTransaction;

  TransactionForm({
    required this.addTransaction,
    required this.deleteTransaction,
  });

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _typeController = TextEditingController();
  DateTime? _selectedDate;

  void _submitForm() {
    final enteredTitle = _titleController.text;
    final enteredAmount = _amountController.text;
    final enteredType = _typeController.text;

    if (enteredTitle.isEmpty ||
        enteredAmount.isEmpty ||
        enteredType.isEmpty ||
        _selectedDate == null) {
      return;
    }

    widget.addTransaction(
      enteredTitle,
      enteredAmount,
      enteredType,
      _selectedDate!,
    );

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light().copyWith(
              primary:
                  Color.fromARGB(255, 225, 71, 97),
            ),
          ),
          child: child!,
        );
      },
    ).then((pickedDate) {
      if (pickedDate != null) {
        setState(() {
          _selectedDate = pickedDate;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Card(
          elevation: 5,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Date: ${_selectedDate != null ? _selectedDate!.toString().substring(0, 10) : 'No Date Selected'}',
                      style: TextStyle(fontSize: 16),
                    ),
                    TextButton(
                      onPressed: _presentDatePicker,
                      child: Text(
                        'Choose Date',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 225, 71, 97),
                        ),
                      ),
                    ),
                  ],
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Title',
                    enabled: _selectedDate !=
                        null,
                  ),
                  controller: _titleController,
                  onSubmitted: (_) => _submitForm(),
                  enabled: _selectedDate !=
                      null,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    enabled: _selectedDate !=
                        null,
                  ),
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  onSubmitted: (_) => _submitForm(),
                  enabled: _selectedDate !=
                      null,
                ),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Type',
                    enabled: _selectedDate !=
                        null,
                  ),
                  controller: _typeController,
                  onSubmitted: (_) => _submitForm(),
                  enabled: _selectedDate !=
                      null,
                ),
                ElevatedButton(
                  child: Text('Add Transaction'),
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(
                        255, 225, 71, 97),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final Function(String) onDelete;

  TransactionItem({
    required this.transaction,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.black54,
            blurRadius: 6.0,
            offset: Offset(0.0, 2.0),
          ),
        ],
      ),
      child: ListTile(
        leading: IconButton(
          icon: Icon(Icons.delete),
          color: Colors.grey,
          onPressed: () => onDelete(transaction.id),
        ),
        title: Text(
          transaction.transactionName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              transaction.expenseOrIncome,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Date: ${transaction.date.toString().substring(0, 10)}',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        trailing: Text(
          (transaction.expenseOrIncome == 'Expense' ? '-' : '+') +
              'Rp' +
              transaction.money,
          style: TextStyle(
            color: (transaction.expenseOrIncome == 'Expense'
                ? Colors.red
                : Colors.green),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
