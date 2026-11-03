import 'package:flutter/material.dart';
import '../widgets/campo_texto_app.dart';
import '../widgets/boton_principal.dart';

class EditarHabitoScreen extends StatefulWidget {
  final String? nombreInicial;
  final Color? colorInicial;

  const EditarHabitoScreen({super.key, this.nombreInicial, this.colorInicial});

  @override
  State<EditarHabitoScreen> createState() => _EditarHabitoScreenState();
}

class _EditarHabitoScreenState extends State<EditarHabitoScreen> {
  // Controlador para el nombre
  late TextEditingController _nombreController;
  // Color seleccionado por defecto
  late Color _colorSeleccionado;

  @override
  void initState() {
    super.initState();
    // Si venimos a editar, rellenamos el campo con el nombre actual. Si no, vacío.
    _nombreController = TextEditingController(text: widget.nombreInicial ?? '');
    // Si venimos a editar, ponemos el color actual. Si no, azul por defecto.
    _colorSeleccionado = widget.colorInicial ?? Colors.blue;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  void _guardar() {
    final nuevoNombre = _nombreController.text.trim();
    if (nuevoNombre.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El nombre no puede estar vacío')),
      );
      return;
    }
    // Devolvemos los datos a la pantalla anterior
    Navigator.pop(context, {
      'nombre': nuevoNombre,
      'color': _colorSeleccionado,
    });
  }

  @override
  Widget build(BuildContext context) {
    // Si es null, estamos creando. Si no, editando.
    final esEdicion = widget.nombreInicial != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(esEdicion ? 'Editar Hábito' : 'Crear Hábito'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo de texto reutilizable
            CampoTextoApp(
              label: 'Nombre del hábito',
              controller: _nombreController,
            ),

            const SizedBox(height: 24),

            // Selector de colores
            const Text(
              'Selecciona un color:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),

            // Fila con los botones de colores
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _botonColor(Colors.blue),
                _botonColor(Colors.green),
                _botonColor(Colors.orange),
                _botonColor(Colors.purple),
              ],
            ),

            const SizedBox(height: 32),

            // Botón de guardar reutilizable
            BotonPrincipal(
              texto: 'Guardar',
              onPressed: _guardar,
            ),

            // Botón de cancelar
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context), // Devuelve null
                child: const Text('Cancelar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para dibujar cada círculo de color
  Widget _botonColor(Color color) {
    final estaSeleccionado = _colorSeleccionado == color;

    return GestureDetector(
      onTap: () => setState(() => _colorSeleccionado = color),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          // Si está seleccionado, le ponemos un borde negro
          border: Border.all(
            color: estaSeleccionado ? Colors.black : Colors.transparent,
            width: 3,
          ),
        ),
        // Si está seleccionado, mostramos un tick blanco dentro
        child: estaSeleccionado
            ? const Icon(Icons.check, color: Colors.white)
            : null,
      ),
    );
  }
}