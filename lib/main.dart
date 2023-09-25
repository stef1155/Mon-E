import 'package:flutter/material.dart';
import 'package:mon_e/pageController.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

late String sqflitePath;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  sqflitePath = appDocumentDirectory.path;
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyWidget(),
    );
  }
}
