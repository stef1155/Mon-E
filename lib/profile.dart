import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _loadSavedName();
  }

  Future<void> _loadSavedName() async {
    final name = await DatabaseHelper.getName();
    if (name != null) {
      setState(() {
        _nameController.text = name;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color.fromARGB(255, 225, 71, 97),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 15, top: 20, right: 15),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        border: Border.all(width: 4, color: Colors.white),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1)),
                        ],
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQLXblniGmMNsgM8GpMxwoWMyS6yisEsGhRYg&usqp=CAU'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              buildTextField("Full Name", " ", _nameController),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _saveName(context);
                    },
                    child: Text(
                      "SAVE",
                      style: TextStyle(
                          fontSize: 15, letterSpacing: 2, color: Colors.white),
                    ),
                    style: OutlinedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 225, 71, 97),
                        padding: EdgeInsets.symmetric(horizontal: 50),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String labelText, String placeholder, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 5),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
      ),
    );
  }

  Future<void> _saveName(BuildContext context) async {
    final name = _nameController.text.trim();
    if (name.isNotEmpty) {
      await DatabaseHelper.saveName(name);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Name saved successfully.'),
      ));
    }
  }
}

class DatabaseHelper {
  static late Database _database;
  static final _tableName = 'profile';
  static Future<Database>? _databaseFuture;

  static Future<Database> get database async {
    if (_databaseFuture == null) {
      _databaseFuture = _initDatabase();
    }
    _database = await _databaseFuture!;
    return _database;
  }

  static Future<Database> _initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'profile.db');
    _database = await openDatabase(path, version: 1, onCreate: _createTable);
    return _database;
  }

  static Future<void> _createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY,
        name TEXT
      )
    ''');
  }

  static Future<void> saveName(String name) async {
    final db = await database;
    await db.insert(_tableName, {'name': name},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<String?> getName() async {
    final db = await database;
    final result = await db.query(_tableName, limit: 1, orderBy: 'id DESC');
    if (result.isEmpty) return null;
    return result.first['name'] as String?;
  }
}
