import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/usuario.dart';


// Clase encargada de gestionar la base de datos SQLite.
// Usa el patrón Singleton para asegurar que solo haya una instancia abierta en toda la app.
class DatabaseHelper {
  // 1. Patrón Singleton: Instancia única
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();


  // Variable que guardará la conexión a la base de datos
  static Database? _database;


  // Getter que devuelve la base de datos. Si no existe, la crea.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }


  // Método que abre la base de datos y ejecuta el código SQL para crear las tablas
  Future<Database> _initDB() async {
    // Construye la ruta donde se guardará el archivo de la base de datos
    final ruta = join(await getDatabasesPath(), 'habitos_app.db');

    return await openDatabase(
      ruta,
      version: 1, // Versión inicial de la base de datos
      onCreate: (db, version) async {
        // TABLA 1: USUARIOS (según el PDF de la profesora)
        await db.execute(
            'CREATE TABLE usuarios ('
                'id INTEGER PRIMARY KEY AUTOINCREMENT, '
                'usuario TEXT UNIQUE, ' // UNIQUE evita usuarios duplicados
                'nombre TEXT, '
                'apellidos TEXT, '
                'email TEXT, '
                'password TEXT, '
                'fecha_creacion TEXT, '
                'rol TEXT)'
        );


        // TABLA 2: HABITOS
        // Se añade 'id_usuario' para saber a qué usuario pertenece cada hábito
        await db.execute(
            'CREATE TABLE habitos ('
                'id INTEGER PRIMARY KEY AUTOINCREMENT, '
                'id_usuario INTEGER, '
                'nombre TEXT, '
                'color INTEGER, '
                'fechas_completado TEXT)'
        );


        // TABLA 3: ESTADISTICAS
        // Vinculada a un hábito mediante 'id_habito'
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


  // Método para insertar un usuario en la base de datos (usado en el Registro)
  Future<int> insertarUsuario(Usuario usuario) async {
    final db = await database;
    // Convierte el objeto Usuario a Map y lo inserta en la tabla 'usuarios'
    return await db.insert('usuarios', usuario.toMap());
  }


  // Método para comprobar si un usuario y contraseña existen (usado en el Login)
  Future<Usuario?> login(String usuario, String password) async {
    final db = await database;
    // Hace una consulta SQL: SELECT * FROM usuarios WHERE usuario = ? AND password = ?
    final res = await db.query(
      'usuarios',
      where: 'usuario = ? AND password = ?',
      whereArgs: [usuario, password], // Evita inyección SQL
    );

    // Si encuentra al menos un resultado, devuelve el primer usuario encontrado
    if (res.isNotEmpty) return Usuario.fromMap(res.first);

    // Si no encuentra nada, devuelve null
    return null;
  }
}