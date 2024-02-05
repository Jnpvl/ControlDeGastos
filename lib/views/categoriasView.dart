import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:money/components/customAppBar.dart';
import 'package:money/models/categoria.dart';
import 'package:money/services/categoria_provider.dart';
import 'package:provider/provider.dart';

class CategoriasView extends StatefulWidget {
  @override
  _CategoriasViewState createState() => _CategoriasViewState();
}

class _CategoriasViewState extends State<CategoriasView> {
  final List<Categoria> _categorias = [];
  final _nombreController = TextEditingController();
  Color _colorSeleccionado = Colors.blue;
  IconData _iconoSeleccionado = Icons.category;
  Categoria? _categoriaActual;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nombreController.dispose();
    super.dispose();
  }

  final List<IconData> _iconosDisponibles = [
    Icons.home,
    Icons.business,
    Icons.school,
    Icons.pets,
    Icons.shopping_cart,
  ];

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
              children: _iconosDisponibles.map((IconData icono) {
                return IconButton(
                  icon: Icon(icono),
                  onPressed: () {
                    setState(() => _iconoSeleccionado = icono);
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
      if (_categoriaActual == null) {
        categoriaProvider.agregarCategoria(Categoria(
          id: _nombreController.text,
          nombre: _nombreController.text,
          color: _colorSeleccionado,
          icono: _iconoSeleccionado,
        ));
      } else {
        categoriaProvider.editarCategoria(
          _categoriaActual!,
          Categoria(
            id: _nombreController.text,
            nombre: _nombreController.text,
            color: _colorSeleccionado,
            icono: _iconoSeleccionado,
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
      _colorSeleccionado = categoria.color;
      _iconoSeleccionado = categoria.icono;
    });
  }

  void _eliminarCategoria(Categoria categoria) {
    setState(() {
      _categorias.remove(categoria);
    });
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
          titleText: 'Categorias',
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
                      leading: Icon(categoria.icono, color: categoria.color),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _editarCategoria(categoria),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _eliminarCategoria(categoria),
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
