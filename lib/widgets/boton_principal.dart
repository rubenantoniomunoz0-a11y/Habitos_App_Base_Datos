import 'package:flutter/material.dart';

// Componente reutilizable para los botones de acción principal.
// Asegura que botones como "Entrar" o "Guardar" tengan el mismo estilo en toda la app.
class BotonPrincipal extends StatelessWidget {
  final String texto; // El texto que mostrará el botón
  final VoidCallback onPressed; // La función que se ejecutará al pulsar (callback)

  const BotonPrincipal({
    super.key,
    required this.texto,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onPressed, // Asocia el callback a la acción del botón
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          child: Text(texto),
        ),
      ),
    );
  }
}