import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/patient.dart';

/// Storage contract. Android uses SQLite; the web preview uses memory
/// because sqflite does not run in the browser.
abstract class PatientStore {
  Future<List<Patient>> all({String query = ''});
  Future<void> add(Patient patient);
  Future<void> update(Patient patient);
  Future<void> delete(int id);

  static Future<PatientStore> open() async {
    if (kIsWeb) return MemoryPatientStore();
    return SqlitePatientStore.open();
  }
}

class SqlitePatientStore implements PatientStore {
  SqlitePatientStore._(this._db);
  final Database _db;

  static Future<SqlitePatientStore> open() async {
    final db = await openDatabase(
      p.join(await getDatabasesPath(), 'clinic_register.db'),
      version: 1,
      onCreate: (db, _) => db.execute('''
        CREATE TABLE patients(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          age INTEGER NOT NULL,
          gender TEXT NOT NULL,
          phone TEXT NOT NULL,
          notes TEXT,
          created_at INTEGER NOT NULL
        )'''),
    );
    return SqlitePatientStore._(db);
  }

  @override
  Future<List<Patient>> all({String query = ''}) async {
    final q = query.trim();
    final rows = await _db.query(
      'patients',
      where: q.isEmpty ? null : 'name LIKE ? OR phone LIKE ?',
      whereArgs: q.isEmpty ? null : ['%$q%', '%$q%'],
      orderBy: 'created_at DESC',
    );
    return rows.map(Patient.fromMap).toList();
  }

  @override
  Future<void> add(Patient patient) => _db.insert('patients', patient.toMap()
    ..remove('id'));

  @override
  Future<void> update(Patient patient) => _db
      .update('patients', patient.toMap(), where: 'id = ?', whereArgs: [patient.id]);

  @override
  Future<void> delete(int id) =>
      _db.delete('patients', where: 'id = ?', whereArgs: [id]);
}

class MemoryPatientStore implements PatientStore {
  final List<Patient> _items = [];
  int _nextId = 1;

  @override
  Future<List<Patient>> all({String query = ''}) async {
    final q = query.trim().toLowerCase();
    final list = _items
        .where((x) =>
            q.isEmpty ||
            x.name.toLowerCase().contains(q) ||
            x.phone.contains(q))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  @override
  Future<void> add(Patient patient) async =>
      _items.add(patient.copyWith(id: _nextId++));

  @override
  Future<void> update(Patient patient) async {
    final i = _items.indexWhere((x) => x.id == patient.id);
    if (i >= 0) _items[i] = patient;
  }

  @override
  Future<void> delete(int id) async => _items.removeWhere((x) => x.id == id);
}
