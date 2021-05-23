import 'package:fish_scan/models/pesee.dart';
import 'package:fish_scan/models/tracabilite.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DatabaseProvider {
  final String table_tracabilite = 'tracabilite';
  final String table_pesee = 'pesee';
  Database db;

  Future open() async {
    if (db != null) return;

    db = await openDatabase(join(await getDatabasesPath(), 'tulipe.db'),
        version: 2, onCreate: (db, version) async {
      await db.execute('''
      CREATE TABLE IF NOT EXISTS $table_tracabilite (

        idTracabilite TEXT PRIMARY KEY,
        sourceId TEXT,
        itemNoa46 TEXT,
        sourceRefa46Noa46 TEXT,
        lotNoa46 TEXT,
        quantity TEXT,
        
        locationCode TEXT,
        createdBy TEXT,
        numPalette TEXT
    )
      ''');

      await db.execute('''
      CREATE TABLE IF NOT EXISTS $table_pesee (
               
        idPesee TEXT PRIMARY KEY,
        lotNoa46 TEXT,
        quantity TEXT,
        nombreCartons TEXT,
        totalPoids TEXT,
        articleNo TEXT,
        locationCode TEXT,
        sourceId TEXT,
        itemNoa46 TEXT,
        sourceRefa46Noa46 TEXT,
        createdBy TEXT,
        fpreparateur INTEGER,
        fverificateur INTEGER
    )
      ''');
    });
  }

  Future<Tracabilite> insertTracabilite(Tracabilite tracabilite) async {
    await open();
    try {
      tracabilite.id = await db.insert(table_tracabilite, tracabilite.toMap());
    } on DatabaseException {
      tracabilite.id = -1;
    }
    return tracabilite;
  }

  Future<Pesee> insertPesee(Pesee pesee) async {
    await open();
    try {
      pesee.id = await db.insert(table_pesee, pesee.toMap());
    } on DatabaseException catch (e) {
      print("\n\n\n\n\n\n\n\n\n\nexception => $e");
      pesee.id = -1;
    }
    return pesee;
  }

  Future<List<Tracabilite>> getTracabiliteByArticle(String articleNo) async {
    await open();
    print("\n\n INSERTION DE LA TRACABILITE");
    List<Map> maps = await db.query(table_tracabilite,
        where: 'itemNoa46 = ?', whereArgs: [articleNo]);
    if (maps.length > 0) {
      List<Tracabilite> datas = List();
      maps.forEach((map) {
        datas.add(Tracabilite.fromMap(map));
      });
      return datas;
    }
    return List();
  }

  Future<List<Pesee>> getPeseeByArticle(String articleNo) async {
    await open();
    print("\n\n getPeseeByArticle  articleNo =${articleNo}");
    List<Map> maps = await db
        .query(table_pesee, where: 'articleNo =?',  whereArgs: [articleNo]);
    if (maps.length > 0) {
      List<Pesee> datas = List();
      maps.forEach((map) {
        datas.add(Pesee.fromMap(map));
      });
      print("RESULTAT DE LA REQUETTE : ${datas}");
      return datas;
    }
    return List();
  }

  Future<int> deleteTracabilite(String id) async {
    await open();
    return db
        .delete(table_tracabilite, where: 'idTracabilite = ?', whereArgs: [id]);
  }

  Future deleteTracabilites(List<Tracabilite> tracabilites) async {
    await open();
    try {
      await db.transaction((txn) {
        for (int i = 0; i < tracabilites.length; i++) {
          txn.delete(table_tracabilite,
              where: 'idTracabilite = ?',
              whereArgs: [tracabilites[i].idTracabilite]).then((value) => null);
        }
      });
    } catch (e){
      print("exception");
      print("$e");
    }
  }

  Future<int> deletePesee(String id) async {
    await open();
    return db.delete(table_pesee, where: 'idPesee = ?', whereArgs: [id]);
  }
  Future<int> deleteOnePeseeById(int id) async {
    await open();
    return db.delete(table_pesee, where: 'id = ?', whereArgs: [id]);

  }


  Future close() async => db.close();
}
