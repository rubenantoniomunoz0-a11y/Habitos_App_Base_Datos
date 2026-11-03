import 'package:flutter/material.dart';
import '../widgets/campo_texto_app.dart';
import '../widgets/boton_principal.dart';
import '../services/database_helper.dart';
import '../models/usuario.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});
  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  // Controladores para los campos de texto
  final _userController = TextEditingController();
  final _nombreController = TextEditingController();
  final _apellidosController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  // Instancia del servicio de base de datos
  final _dbHelper = DatabaseHelper();

  @override
  void dispose() {
    _userController.dispose();
    _nombreController.dispose();
    _apellidosController.dispose();
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void _registrar() async {
    if (_userController.text.isEmpty || _passController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Usuario y contraseña son obligatorios')));
      return;
    }

    final nuevoUsuario = Usuario(
      usuario: _userController.text.trim(),
      nombre: _nombreController.text.trim(),
      apellidos: _apellidosController.text.trim(),
      email: _emailController.text.trim(),
      password: _passController.text.trim(),
      fechaCreacion: DateTime.now().toIso8601String(),
      rol: 'usuario', // Por defecto
    );

    try {
      // Llamada al DatabaseHelper
      await _dbHelper.insertarUsuario(nuevoUsuario);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registro exitoso. Inicia sesión.')));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error: El usuario ya existe')));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registro')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            CampoTextoApp(label: 'Usuario', controller: _userController),
            CampoTextoApp(label: 'Nombre', controller: _nombreController),
            CampoTextoApp(label: 'Apellidos', controller: _apellidosController),
            CampoTextoApp(label: 'Email', controller: _emailController),
            CampoTextoApp(label: 'Contraseña', controller: _passController, ocultarContenido: true),
            BotonPrincipal(texto: 'Registrarse', onPressed: _registrar),
          ],
        ),
      ),
    );
  }
}