import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../widgets/tarjeta_habito.dart';
import 'editar_habito_screen.dart';
import 'login_screen.dart';
import '../services/database_helper.dart';

class HabitosScreen extends StatefulWidget {
  final Usuario usuario;
  const HabitosScreen({super.key, required this.usuario});

  @override
  State<HabitosScreen> createState() => _HabitosScreenState();
}

class _HabitosScreenState extends State<HabitosScreen> {
  final _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _habitos = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarHabitos();
  }

  // Leer de SQLite
  Future<void> _cargarHabitos() async {
    final habitos = await _dbHelper.leerHabitos(widget.usuario.id!, widget.usuario.rol);
    if (!mounted) return;
    setState(() {
      _habitos = habitos;
      _cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Si es admin, se lo indicamos en el título
          title: Text('Hola, ${widget.usuario.nombre} ${widget.usuario.rol == 'administrador' ? '(Admin)' : ''}'),
          actions: [
            IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginScreen()));
                }
            )
          ]
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _habitos.isEmpty
          ? const Center(child: Text('No hay hábitos. ¡Crea uno!'))
          : ListView.builder(
        itemCount: _habitos.length,
        itemBuilder: (context, index) {
          final h = _habitos[index];
          // Obtenemos la fecha de hoy en texto
          final fechaHoy = DateTime.now().toIso8601String().substring(0, 10);
          // Comprobamos si la fecha de hoy está dentro de las completadas
          final fechasStr = h['fechas_completado'] ?? '';
          final completadoHoy = fechasStr.contains(fechaHoy);

          return TarjetaHabito(
            nombre: h['nombre'],
            color: Color(h['color']),
            completadoHoy: completadoHoy,
            onCompletar: () async {
              // Marcar/desmarcar de la BD
              List<String> fechas = fechasStr.isEmpty ? [] : fechasStr.split(',');
              if (completadoHoy) {
                fechas.remove(fechaHoy); // Quitamos la fecha
              } else {
                fechas.add(fechaHoy); // Añadimos la fecha
              }
              final nuevasFechas = fechas.join(',');

              await _dbHelper.actualizarHabito(h['id'], h['nombre'], h['color'], nuevasFechas);
              _cargarHabitos(); // Recargamos la lista
            },
            onEditar: () async {
              final resultado = await Navigator.push<Map<String, dynamic>>(
                context,
                MaterialPageRoute(
                  builder: (_) => EditarHabitoScreen(
                    nombreInicial: h['nombre'],
                    colorInicial: Color(h['color']),
                  ),
                ),
              );
              // Si el usuario guardó cambios, actualizamos en la BD
              if (resultado != null) {
                await _dbHelper.actualizarHabito(
                    h['id'],
                    resultado['nombre'],
                    (resultado['color'] as Color).value,
                    fechasStr
                );
                _cargarHabitos();
              }
            },
            onEliminar: () async {
              await _dbHelper.borrarHabito(h['id']);
              _cargarHabitos();
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final resultado = await Navigator.push<Map<String, dynamic>>(
            context,
            MaterialPageRoute(builder: (_) => const EditarHabitoScreen()),
          );
          if (resultado != null) {
            // Insertamos el nuevo hábito en la BD
            await _dbHelper.insertarHabito(
                widget.usuario.id!,
                resultado['nombre'],
                (resultado['color'] as Color).value
            );
            _cargarHabitos();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}