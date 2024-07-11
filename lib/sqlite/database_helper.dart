import 'package:flutter_application_99/data/account_json.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  final databaseName = "flutterdesk.db";

  String accountTbl = '''
CREATE TABLE accounts (
  accId INTEGER PRIMARY KEY AUTOINCREMENT,
  accHolder TEXT NOT NULL,
  accName TEXT NOT NULL,
  accStatus INTEGER,
  createdAt TEXT NOT
)''';

//database connection
  Future<Database> init() async {
    final databasePath = await getApplicationDocumentsDirectory();
    final path = "${databasePath.path}/$databaseName";

    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(accountTbl);
    });
  }

//get
  Future<List<AccountsJson>> getAccounts() async {
    final Database db = await init();
    List<Map<String, Object?>> result =
        await db.query("accounts", where: "accStatus = 1");

    return result.map((e) => AccountsJson.fromMap((e))).toList();
  }

  //post
  Future<int> insertAccount(AccountsJson account) async {
    final Database db = await init();
    return db.insert("accounts", account.toMap());
  }

  //update
  Future<int> updateAccount(String accHolder, String accName, int id) async {
    final Database db = await init();

    return db.rawUpdate(
        "update accounts set accHolder = ?, accName = ? where accId = ?",
        [accHolder, accName, id]);
  }

  //delete
  Future<int> deleteAccount(int id) async {
    final Database db = await init();
    return db.delete("accounts", where: "accId = ?", whereArgs: [id]);
  }

  //filter
  Future<List<AccountsJson>> filter(String keyword) async {
    final Database db = await init();
    List<Map<String, Object?>> result = await db.rawQuery(
        "select * from accounts where accHolder LIKE ? OR accName LIKE ?",
        ["%$keyword%", "%$keyword%"]);

    return result.map((e) => AccountsJson.fromMap((e))).toList();
  }
}
