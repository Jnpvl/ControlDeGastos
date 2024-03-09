import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:money/services/movimiento_provider.dart';
import 'package:money/services/categoria_provider.dart';
import 'package:money/models/Movimiento.dart';
import 'package:money/components/customAppBar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';

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
                  onPressed: () => crearYGuardarExcel(movimientosFiltrados),
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

  Future<void> crearYGuardarExcel(List<Movimiento> movimientos) async {
    final xlsio.Workbook workbook = xlsio.Workbook();
    final xlsio.Worksheet sheet = workbook.worksheets[0];
    sheet.getRangeByName('A1').setText('Tipo');
    sheet.getRangeByName('B1').setText('Cantidad');
    sheet.getRangeByName('C1').setText('Categoría');
    sheet.getRangeByName('D1').setText('Concepto');

    for (int i = 0; i < movimientos.length; i++) {
      sheet.getRangeByName('A${i + 2}').setText(movimientos[i].tipo);
      sheet.getRangeByName('B${i + 2}').setNumber(movimientos[i].cantidad);
      sheet.getRangeByName('C${i + 2}').setText(movimientos[i].categoria);
      sheet.getRangeByName('D${i + 2}').setText(movimientos[i].concepto);
    }

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = '${directory.path}/Movimientos.xlsx';
    final File file = File(path);
    await file.writeAsBytes(bytes, flush: true);
    //Share.shareFiles([file.path], text: 'Aquí están tus movimientos exportados.');
    // OpenFile.open(path);

 
    try {
     // final result = await OpenFile.open(path); para abrir directamente pero pss no me dejo
      Share.shareFiles([file.path], text: 'Aquí están tus movimientos exportados.'); //es para compartir
    } catch (e) {
      print("Error al abrir el archivo: $e");
    }
  }
}
