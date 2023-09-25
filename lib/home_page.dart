import 'package:flutter/material.dart';
import 'package:mon_e/header.dart';
import 'package:mon_e/transaction.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<Transaction> _transactions = [];
  late String _balance = '';
  late String _income = '';
  late String _expense = '';

  @override
  void initState() {
    super.initState();
    _updateHeader();
  }

  Future<void> _updateHeader() async {
    final transactions = await DBHelper.fetchTransactions();
    double income = 0;
    double expense = 0;

    for (final transaction in transactions) {
      final money = double.tryParse(transaction.money.replaceAll(',', ''));
      if (money != null) {
        if (transaction.expenseOrIncome == 'Income') {
          income += money;
        } else {
          expense += money;
        }
      }
    }

    final balance = income - expense;

    setState(() {
      _transactions = transactions;
      _balance = 'Rp ${balance.toStringAsFixed(2)}';
      _income = 'Rp ${income.toStringAsFixed(2)}';
      _expense = 'Rp ${expense.toStringAsFixed(2)}';
    });
  }

  void _addTransaction(
      String title, String amount, String expenseOrIncome, DateTime date) {
    final newTransaction = Transaction(
        id: UniqueKey().toString(),
        transactionName: title,
        money: amount,
        expenseOrIncome: expenseOrIncome,
        date: date);

    DBHelper.insertTransaction(newTransaction).then((_) {
      setState(() {
        _transactions.add(newTransaction);
      });
      _updateHeader();
    });
  }

  void _deleteTransaction(String id) {
    DBHelper.deleteTransaction(id).then((_) {
      setState(() {
        _transactions.removeWhere((transaction) => transaction.id == id);
      });
      _updateHeader();
    });
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: TransactionForm(
            addTransaction: _addTransaction,
            deleteTransaction: _deleteTransaction,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
        ),
        backgroundColor: Color.fromARGB(255, 225, 71, 97),
      ),
      body: Column(
        children: [
          Header(
            balance: _balance,
            income: _income,
            expense: _expense,
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _transactions.length,
              padding: EdgeInsets.zero,
              itemBuilder: (ctx, index) {
                return TransactionItem(
                  transaction: _transactions[index],
                  onDelete: _deleteTransaction,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _startAddNewTransaction(context),
        child: Icon(Icons.add),
        backgroundColor: Color.fromARGB(255, 225, 71, 97),
      ),
    );
  }
}
