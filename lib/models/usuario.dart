// Modelo que representa a un usuario en la base de datos.
// Cada vez que se registre alguien o se lea de SQLite, se usará esta clase.
class Usuario {
  final int? id; // Puede ser nulo porque cuando creamos uno nuevo, aún no tiene ID (lo genera SQLite)
  final String usuario;
  final String nombre;
  final String apellidos;
  final String email;
  final String password;
  final String fechaCreacion;
  final String rol; // 'administrador' o 'usuario'


  // Constructor de la clase.
  // 'required' significa que es obligatorio pasar estos datos al crear un Usuario.
  Usuario({
    this.id, // El id no es obligatorio (por eso no lleva required)
    required this.usuario,
    required this.nombre,
    required this.apellidos,
    required this.email,
    required this.password,
    required this.fechaCreacion,
    required this.rol,
  });


  // Este método convierte el objeto Usuario en un 'Map' (un diccionario de clave-valor).
  // Es necesario porque SQLite no entiende de objetos, solo de Mapas.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuario': usuario,
      'nombre': nombre,
      'apellidos': apellidos,
      'email': email,
      'password': password,
      'fecha_creacion': fechaCreacion, // Usamos el nombre exacto de la columna de la tabla
      'rol': rol,
    };
  }


  // Este es un constructor especial (factory) que hace lo contrario al toMap.
  // Recibe un Map (que viene de SQLite) y lo convierte de vuelta en un objeto Usuario.
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      usuario: map['usuario'],
      nombre: map['nombre'],
      apellidos: map['apellidos'],
      email: map['email'],
      password: map['password'],
      fechaCreacion: map['fecha_creacion'],
      rol: map['rol'],
    );
  }
}