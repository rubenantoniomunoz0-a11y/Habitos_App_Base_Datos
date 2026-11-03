import 'package:flutter/material.dart';

// Componente reutilizable para mostrar datos estadísticos.
class DatoEstadistica extends StatelessWidget {
  final String etiqueta;
  final String valor;
  final IconData icono;
  final Color color;

  const DatoEstadistica({
    super.key,
    required this.etiqueta,
    required this.valor,
    required this.icono,
    this.color = Colors.blue, 
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icono, color: color, size: 30),
        const SizedBox(height: 8),
        Text(valor, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(etiqueta, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}