import 'package:flutter/material.dart';

// Componente reutilizable que representa visualmente un hábito en la lista.
class TarjetaHabito extends StatelessWidget {
  final String nombre;
  final Color color;
  final bool completadoHoy;
  final IconData icono;
  final VoidCallback onCompletar;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;

  const TarjetaHabito({
    super.key,
    required this.nombre,
    required this.color,
    required this.completadoHoy,
    this.icono = Icons.star,
    required this.onCompletar,
    required this.onEditar,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color, child: Icon(icono, color: Colors.white)),
        title: Text(nombre, style: TextStyle(
          decoration: completadoHoy ? TextDecoration.lineThrough : null,
          fontWeight: FontWeight.bold,
        )),
        subtitle: Text(completadoHoy ? 'Completado hoy' : 'Pendiente'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(completadoHoy ? Icons.check_circle : Icons.check_circle_outline, color: Colors.green),
              onPressed: onCompletar,
            ),
            IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: onEditar),
            IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: onEliminar),
          ],
        ),
      ),
    );
  }
}