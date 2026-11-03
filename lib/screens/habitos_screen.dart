import 'package:flutter/material.dart';
import '../models/usuario.dart'; // De tu compañero
import '../widgets/tarjeta_habito.dart';
import 'editar_habito_screen.dart';
import 'login_screen.dart';

class HabitosScreen extends StatefulWidget {
  final Usuario usuario; // Recibimos el usuario que ha hecho login

  const HabitosScreen({super.key, required this.usuario});

  @override
  State<HabitosScreen> createState() => _HabitosScreenState();
}

class _HabitosScreenState extends State<HabitosScreen> {
  // Datos en memoria por ahora
  final List<Map<String, dynamic>> _habitos = [
    {'nombre': 'Beber agua', 'color': Colors.blue, 'completado': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Saludamos al usuario
          title: Text('Hola, ${widget.usuario.nombre}'),
          actions: [
            IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                }
            )
          ]
      ),
      body: _habitos.isEmpty
          ? const Center(child: Text('No hay hábitos. ¡Crea uno!'))
          : ListView.builder(
        itemCount: _habitos.length,
        itemBuilder: (context, index) {
          final h = _habitos[index];
          return TarjetaHabito(
            nombre: h['nombre'],
            color: h['color'],
            completadoHoy: h['completado'],
            onCompletar: () {
              setState(() {
                _habitos[index]['completado'] = !_habitos[index]['completado'];
              });
            },
            onEditar: () {
              // Aquí iría la apertura de la pantalla de editar
            },
            onEliminar: () {
              setState(() {
                _habitos.removeAt(index);
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Aquí iría la apertura de la pantalla de editar (crear)
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}