import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/usuario.dart';

class DatabaseHelper {
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

        // 2. TABLA HABITOS
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

  // Cuenta cuántos usuarios hay 
  Future<int> contarUsuarios() async {
    final db = await database;
    final res = await db.rawQuery('SELECT COUNT(*) FROM usuarios');
    return Sqflite.firstIntValue(res) ?? 0;
  }

  // --- CRUD DE HÁBITOS ---
  Future<int> insertarHabito(int idUsuario, String nombre, int color) async {
    final db = await database;
    return await db.insert('habitos', {
      'id_usuario': idUsuario,
      'nombre': nombre,
      'color': color,
      'fechas_completado': '',
    });
  }

  Future<List<Map<String, dynamic>>> leerHabitos(int idUsuario, String rol) async {
    final db = await database;
    if (rol == 'administrador') {
      return await db.query('habitos'); // Admin ve todos
    } else {
      return await db.query('habitos', where: 'id_usuario = ?', whereArgs: [idUsuario]); // Usuario ve los suyos
    }
  }

  Future<int> actualizarHabito(int id, String nombre, int color, String fechas) async {
    final db = await database;
    return await db.update('habitos', {
      'nombre': nombre,
      'color': color,
      'fechas_completado': fechas,
    }, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> borrarHabito(int id) async {
    final db = await database;
    return await db.delete('habitos', where: 'id = ?', whereArgs: [id]);
  }

  // --- CRUD DE ESTADÍSTICAS ---
  Future<int> insertarEstadistica(int idHabito, int racha, int dias) async {
    final db = await database;
    return await db.insert('estadisticas', {
      'id_habito': idHabito,
      'racha_actual': racha,
      'dias_completados': dias,
    });
  }

  Future<List<Map<String, dynamic>>> leerEstadisticas(int idHabito) async {
    final db = await database;
    return await db.query('estadisticas', where: 'id_habito = ?', whereArgs: [idHabito]);
  }
}