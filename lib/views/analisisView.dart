import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:money/services/movimiento_provider.dart';
import 'package:money/services/categoria_provider.dart';
import 'package:money/models/Movimiento.dart';
import 'package:money/components/customAppBar.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';
import 'package:share/share.dart';

class AnalisisView extends StatefulWidget {
  const AnalisisView({Key? key}) : super(key: key);

  @override
  _AnalisisViewState createState() => _AnalisisViewState();
}

class _AnalisisViewState extends State<AnalisisView> {
  String _selectedCategoria = 'Todos';
  String _selectedTipoMovimiento = 'Todos';

  @override
  Widget build(BuildContext context) {
    final categoriaProvider = Provider.of<CategoriaProvider>(context);
    final movimientoProvider = Provider.of<MovimientoProvider>(context);

    List<String> categorias =
        ['Todos'] + categoriaProvider.categorias.map((c) => c.nombre).toList();
    List<String> tiposDeMovimiento = ['Todos', 'Ingreso', 'Egreso'];

    List<Movimiento> movimientosFiltrados =
        movimientoProvider.movimientos.where((movimiento) {
      bool matchCategoria = _selectedCategoria == 'Todos' ||
          movimiento.categoria == _selectedCategoria;
      bool matchTipo = _selectedTipoMovimiento == 'Todos' ||
          movimiento.tipo == _selectedTipoMovimiento;
      return matchCategoria && matchTipo;
    }).toList();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.deepPurple[50],
        appBar: CustomAppBar(showTitle: true, titleText: 'Análisis'),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: movimientosFiltrados.length,
                itemBuilder: (context, index) {
                  Movimiento movimiento = movimientosFiltrados[index];
                  return ListTile(
                    title: Text("${movimiento.tipo}: \$${movimiento.cantidad}"),
                    subtitle: Text(
                        "${movimiento.categoria} - ${movimiento.concepto}"),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: DropdownButton<String>(
                    value: _selectedCategoria,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedCategoria = newValue!;
                      });
                    },
                    items: categorias
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.download),
                  onPressed: () => descargarExcel(movimientosFiltrados),
                ),
                Expanded(
                  child: DropdownButton<String>(
                    value: _selectedTipoMovimiento,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedTipoMovimiento = newValue!;
                      });
                    },
                    items: tiposDeMovimiento
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> descargarExcel(List<Movimiento> movimientos) async {
    // Implementa la lógica para descargar Excel aquí
    print('excel');
  }
}
