import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:money/components/customAlert.dart';
import 'package:money/components/customAppBar.dart';
import 'package:money/models/categoria.dart';
import 'package:money/models/icon_mapping.dart';
import 'package:money/services/categoria_provider.dart';
import 'package:money/services/movimiento_provider.dart';
import 'package:provider/provider.dart';

class CategoriasView extends StatefulWidget {
  const CategoriasView({super.key});

  @override
  _CategoriasViewState createState() => _CategoriasViewState();
}

class _CategoriasViewState extends State<CategoriasView> {
  final _nombreController = TextEditingController();
  Color _colorSeleccionado = Colors.blue;
  IconData _iconoSeleccionado = Icons.money;
  Categoria? _categoriaActual;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  void _mostrarPickerIcono(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Elige un ícono'),
          content: SingleChildScrollView(
            child: Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: iconosMapeados.entries.map((entry) {
                return IconButton(
                  icon: Icon(entry.value),
                  onPressed: () {
                    setState(() => _iconoSeleccionado = entry.value);
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void _agregarEditarCategoria(CategoriaProvider categoriaProvider) {
    if (_formKey.currentState!.validate()) {
      String iconoString = iconosMapeados.entries
          .firstWhere((entry) => entry.value == _iconoSeleccionado,
              orElse: () => const MapEntry("default", Icons.category))
          .key;

      if (_categoriaActual == null) {
        categoriaProvider.agregarCategoria(Categoria(
          id: DateTime.now().toString(),
          nombre: _nombreController.text,
          color: _colorSeleccionado.value,
          icono: iconoString,
        ));
      } else {
        categoriaProvider.editarCategoria(
          _categoriaActual!,
          Categoria(
            id: _categoriaActual!.id,
            nombre: _nombreController.text,
            color: _colorSeleccionado.value,
            icono: iconoString,
          ),
        );
      }
      _nombreController.clear();
      _categoriaActual = null;
    }
  }

  void _editarCategoria(Categoria categoria) {
    setState(() {
      _categoriaActual = categoria;
      _nombreController.text = categoria.nombre;
      _colorSeleccionado = Color(categoria.color);
      _iconoSeleccionado = iconosMapeados[categoria.icono] ?? Icons.category;
    });
  }

  bool esCategoriaEnUso(String categoriaNombre, BuildContext context) {
    final movimientoProvider =
        Provider.of<MovimientoProvider>(context, listen: false);
    return movimientoProvider.movimientos
        .any((movimiento) => movimiento.categoria == categoriaNombre);
  }

  void _eliminarCategoria(Categoria categoria,
      CategoriaProvider categoriaProvider, BuildContext context) {
    if (!esCategoriaEnUso(categoria.nombre, context)) {
      CustomAlert.showConfirmationDialog(
        context: context,
        title: 'Eliminar Categoría',
        message: '¿Estás seguro de que deseas eliminar esta categoría?',
        onConfirm: () {
          categoriaProvider.eliminarCategoria(categoria);
        },
      );
    } else {
      CustomAlert.showInfoDialog(
        context: context,
        title: 'Categoría en Uso',
        message: 'Esta categoría está en uso y no puede ser eliminada.',
      );
    }
  }

  void _mostrarPickerColor(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Elige un color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _colorSeleccionado,
              onColorChanged: (Color color) {
                setState(() => _colorSeleccionado = color);
              },
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Hecho'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoriaProvider = Provider.of<CategoriaProvider>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.deepPurple[50],
        appBar: CustomAppBar(
          showTitle: true,
          titleText: 'Categorías',
        ),
        body: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: categoriaProvider.categorias.length,
                  itemBuilder: (context, index) {
                    final categoria = categoriaProvider.categorias[index];
                    return ListTile(
                      title: Text(categoria.nombre),
                      leading: Icon(
                        iconosMapeados[categoria.icono] ?? Icons.category,
                        color: Color(categoria.color),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _editarCategoria(categoria),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _eliminarCategoria(
                                categoria, categoriaProvider, context),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              _formularioCategoria(categoriaProvider)
            ],
          ),
        ),
      ),
    );
  }

  Widget _formularioCategoria(CategoriaProvider categoriaProvider) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _nombreController,
            decoration:
                const InputDecoration(labelText: 'Nombre de la categoría'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa un nombre de la categoría';
              }
              return null;
            },
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () => _mostrarPickerColor(context),
                child: Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10, right: 10),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _colorSeleccionado,
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _mostrarPickerIcono(context),
                child: Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Icon(
                    _iconoSeleccionado,
                    size: 30,
                  ),
                ),
              ),
              SizedBox(width: 120),
              ElevatedButton(
                onPressed: () => _agregarEditarCategoria(categoriaProvider),
                child:
                    Text(_categoriaActual == null ? 'Guardar' : 'Actualizar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
