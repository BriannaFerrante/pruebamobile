import 'package:flutter/material.dart';

void main() {
  runApp(const TareasApp());
}

class TareasApp extends StatelessWidget {
  const TareasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tareas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const PantallaTareas(),
    );
  }
}

class PantallaTareas extends StatefulWidget {
  const PantallaTareas({super.key});

  @override
  State<PantallaTareas> createState() => _PantallaTareasState();
}

class _PantallaTareasState extends State<PantallaTareas> {
  final TextEditingController _controlador = TextEditingController();
  final List<Tarea> _tareas = [];

  void _agregarTarea() {
    final texto = _controlador.text.trim();
    if (texto.isEmpty) {
      return;
    }
    setState(() {
      _tareas.add(Tarea(texto));
      _controlador.clear();
    });
  }

  void _marcarTarea(int indice, bool hecha) {
    setState(() {
      _tareas[indice].hecha = hecha;
    });
  }

  void _eliminarTarea(int indice) {
    setState(() {
      _tareas.removeAt(indice);
    });
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis tareas'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controlador,
                    decoration: const InputDecoration(
                      labelText: 'Nueva tarea',
                      hintText: 'Escribe una tarea',
                      border: OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _agregarTarea(),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: _agregarTarea,
                  child: const Text('Agregar'),
                ),
              ],
            ),
          ),
          Expanded(
            child: _tareas.isEmpty
                ? const Center(
                    child: Text('No hay tareas registradas'),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: _tareas.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, indice) {
                      final tarea = _tareas[indice];
                      return Material(
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                        child: ListTile(
                          leading: Checkbox(
                            value: tarea.hecha,
                            onChanged: (valor) =>
                                _marcarTarea(indice, valor ?? false),
                          ),
                          title: Text(
                            tarea.texto,
                            style: TextStyle(
                              decoration: tarea.hecha
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          trailing: IconButton(
                            tooltip: 'Eliminar',
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => _eliminarTarea(indice),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class Tarea {
  Tarea(this.texto);

  final String texto;
  bool hecha = false;
}
