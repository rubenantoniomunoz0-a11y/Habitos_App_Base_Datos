import 'package:flutter/material.dart';
import '../widgets/campo_texto_app.dart';
import '../widgets/boton_principal.dart';
import '../services/database_helper.dart';
import 'registro_screen.dart';
import 'habitos_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controladores para leer lo que escribe el usuario
  final _userController = TextEditingController();
  final _passController = TextEditingController();

  // Instancia del servicio de base de datos
  final _dbHelper = DatabaseHelper();

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    super.dispose();
  }

  void _login() async {
    final user = _userController.text.trim();
    final pass = _passController.text.trim();

    // Validación básica
    if (user.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Rellena todos los campos')));
      return;
    }

    // Busca en la base de datos si el usuario existe
    final usuarioLogueado = await _dbHelper.login(user, pass);

    if (usuarioLogueado != null) {
      if (!mounted) return;
      // Si existe, navega a la pantalla principal pasándole el usuario
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HabitosScreen(usuario: usuarioLogueado))
      );
    } else {
      if (!mounted) return;
      // Si no existe, muestra error
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Usuario o contraseña incorrectos')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar Sesión')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Usamos nuestros componentes reutilizables
            CampoTextoApp(label: 'Usuario', controller: _userController),
            CampoTextoApp(label: 'Contraseña', controller: _passController, ocultarContenido: true),
            BotonPrincipal(texto: 'Entrar', onPressed: _login),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const RegistroScreen()));
              },
              child: const Text('¿No tienes cuenta? Regístrate'),
            )
          ],
        ),
      ),
    );
  }
}