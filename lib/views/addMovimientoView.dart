import 'package:flutter/material.dart';
import 'package:money/components/customAppBar.dart';
import 'package:provider/provider.dart';
import 'package:money/services/categoria_provider.dart';
import 'package:money/services/movimiento_provider.dart';
import 'package:money/models/Movimiento.dart';
import 'package:intl/intl.dart';

class MovimientosView extends StatefulWidget {
  const MovimientosView({super.key});

  @override
  State<MovimientosView> createState() => _MovimientosViewState();
}

class _MovimientosViewState extends State<MovimientosView> {
  final _formKey = GlobalKey<FormState>();
  final _cantidadController = TextEditingController();
  final _conceptoController = TextEditingController();

  String? _tipoMovimiento;
  String? _categoria;

  @override
  void dispose() {
    _cantidadController.dispose();
    _conceptoController.dispose();
    super.dispose();
  }

  String formatNumber(double number) {
    final formatter = NumberFormat("#,##0.00", "en_US");
    return formatter.format(number);
  }

  void _guardarMovimiento() {
    if (_formKey.currentState!.validate()) {
      final movimientoProvider =
          Provider.of<MovimientoProvider>(context, listen: false);
      double cantidad = double.tryParse(_cantidadController.text) ?? 0;
      DateTime fechaActual = DateTime.now();
      String movimientoId = DateTime.now().millisecondsSinceEpoch.toString();

      Movimiento nuevoMovimiento = Movimiento(
        id: movimientoId,
        cantidad: cantidad,
        tipo: _tipoMovimiento ?? '',
        categoria: _categoria ?? '',
        concepto: _conceptoController.text,
        fecha: fechaActual,
      );

      movimientoProvider.agregarMovimiento(nuevoMovimiento);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Movimiento guardado')),
      );

      _formKey.currentState!.reset();
      _cantidadController.clear();
      _conceptoController.clear();
      setState(() {
        _tipoMovimiento = null;
        _categoria = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriaProvider = Provider.of<CategoriaProvider>(context);

    List<DropdownMenuItem<String>> categoriaItems = categoriaProvider.categorias
        .map((categoria) => DropdownMenuItem<String>(
              value: categoria.nombre,
              child: Text(categoria.nombre),
            ))
        .toList();

    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: CustomAppBar(
        showTitle: true,
        titleText: 'Ingresa tus movimientos',
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _cantidadController,
                    decoration: const InputDecoration(labelText: 'Cantidad'),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    validator: (value) {
                      final double? parsedValue = double.tryParse(value ?? '');
                      if (parsedValue == null) {
                        return 'Por favor ingresa solo caracteres numericos';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      final parts = value.split('.');
                      if (parts.length == 2 && parts[1].length > 2) {
                        _cantidadController.text =
                            '${parts[0]}.${parts[1].substring(0, 2)}';
                      }
                    },
                    onFieldSubmitted: (value) {
                      final double? parsedValue =
                          double.tryParse(_cantidadController.text);
                      if (parsedValue != null) {
                        _cantidadController.text = formatNumber(parsedValue);
                      }
                    },
                  ),
                  DropdownButtonFormField<String>(
                    decoration:
                        const InputDecoration(labelText: 'Tipo de movimiento'),
                    value: _tipoMovimiento,
                    items: <String>['Ingreso', 'Egreso']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _tipoMovimiento = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor selecciona un tipo de movimiento';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Categoría'),
                    value: _categoria,
                    items: categoriaItems,
                    onChanged: (String? newValue) {
                      setState(() {
                        _categoria = newValue;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor selecciona una categoría';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _conceptoController,
                    decoration: const InputDecoration(labelText: 'Concepto'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor ingresa el concepto';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: ElevatedButton(
                      onPressed: _guardarMovimiento,
                      child: const Text('Guardar movimiento'),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
