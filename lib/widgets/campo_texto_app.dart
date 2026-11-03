import 'package:flutter/material.dart';

// Componente reutilizable para todos los campos de texto de la app.
// Evita repetir el mismo diseño de TextField en Login, Registro o Editar Hábito.
class CampoTextoApp extends StatelessWidget {
  final String label; // El texto de la etiqueta (ej. 'Usuario')
  final TextEditingController controller; // Controlador para leer/escribir el texto
  final bool ocultarContenido; // Si es true, oculta el texto (ideal para contraseñas)

  const CampoTextoApp({
    super.key,
    required this.label,
    required this.controller,
    this.ocultarContenido = false, // Por defecto, el texto se ve normal
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0), // Separación arriba y abajo
      child: TextField(
        controller: controller,
        obscureText: ocultarContenido, // Aplica el ocultamiento si es true
        decoration: InputDecoration(
          labelText: label, // Muestra la etiqueta flotante
          border: const OutlineInputBorder(), // Dibuja el borde cuadrado
        ),
      ),
    );
  }
}