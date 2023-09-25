import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:csv/csv.dart';
import 'dart:io';

class Report extends StatelessWidget {
  const Report({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reports',
        ),
        backgroundColor: Color.fromARGB(255, 225, 71, 97),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _exportToExcel,
          child: const Text('Export to Excel'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 225, 71, 97),
          ),
        ),
      ),
    );
  }

  void _exportToExcel() async {
    final dbPath = await sql.getDatabasesPath();
    final databasePath = path.join(dbPath!, 'transactions.db');

    final database = await sql.openDatabase(databasePath);

    final transactions = await database.query('transactions');

    final csvData = <List<dynamic>>[];
    csvData
        .add(['ID', 'Transaction Name', 'Money', 'Expense or Income', 'Date']);
    transactions.forEach((transaction) {
      csvData.add([
        transaction['id'],
        transaction['transactionName'],
        transaction['money'],
        transaction['expenseOrIncome'],
        transaction['date']
      ]);
    });
    final csvString = const ListToCsvConverter().convert(csvData);

    final documentsDirectory = await getExternalStorageDirectory();
    final excelFilePath =
        path.join(documentsDirectory!.path, 'transactions.csv');

    final file = File(excelFilePath);
    await file.writeAsString(csvString);

    print('File saved successfully: $excelFilePath');
  }
}

void main() {
  runApp(MaterialApp(
    home: const Report(),
  ));
}
