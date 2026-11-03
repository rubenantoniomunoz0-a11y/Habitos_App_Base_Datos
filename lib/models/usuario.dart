class Usuario {
  final int? id;
  final String usuario;
  final String nombre;
  final String apellidos;
  final String email;
  final String password;
  final String fechaCreacion;
  final String rol; // 'administrador' o 'usuario'


  Usuario({
    this.id,
    required this.usuario,
    required this.nombre,
    required this.apellidos,
    required this.email,
    required this.password,
    required this.fechaCreacion,
    required this.rol,
  });


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'usuario': usuario,
      'nombre': nombre,
      'apellidos': apellidos,
      'email': email,
      'password': password,
      'fecha_creacion': fechaCreacion,
      'rol': rol,
    };
  }


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