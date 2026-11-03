import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/usuario.dart';


class DatabaseHelper {
  // Patrón Singleton (Una sola instancia, como pide la teoría)
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();


  static Database? _database;


  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }


  Future<Database> _initDB() async {
    final ruta = join(await getDatabasesPath(), 'habitos_app.db');
    return await openDatabase(
      ruta,
      version: 1,
      onCreate: (db, version) async {
        // 1. TABLA USUARIOS
        await db.execute(
            'CREATE TABLE usuarios ('
                'id INTEGER PRIMARY KEY AUTOINCREMENT, '
                'usuario TEXT UNIQUE, '
                'nombre TEXT, '
                'apellidos TEXT, '
                'email TEXT, '
                'password TEXT, '
                'fecha_creacion TEXT, '
                'rol TEXT)'
        );


        // 2. TABLA HABITOS (con id_usuario para saber de quién es)
        await db.execute(
            'CREATE TABLE habitos ('
                'id INTEGER PRIMARY KEY AUTOINCREMENT, '
                'id_usuario INTEGER, '
                'nombre TEXT, '
                'color INTEGER, '
                'fechas_completado TEXT)'
        );


        // 3. TABLA ESTADISTICAS
        await db.execute(
            'CREATE TABLE estadisticas ('
                'id INTEGER PRIMARY KEY AUTOINCREMENT, '
                'id_habito INTEGER, '
                'racha_actual INTEGER, '
                'dias_completados INTEGER)'
        );
      },
    );
  }


  // --- CRUD DE USUARIOS ---


  Future<int> insertarUsuario(Usuario usuario) async {
    final db = await database;
    return await db.insert('usuarios', usuario.toMap());
  }


  Future<Usuario?> login(String usuario, String password) async {
    final db = await database;
    final res = await db.query(
      'usuarios',
      where: 'usuario = ? AND password = ?',
      whereArgs: [usuario, password],
    );
    if (res.isNotEmpty) return Usuario.fromMap(res.first);
    return null;
  }
}