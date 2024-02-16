import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:money/models/Movimiento.dart';
import 'package:money/services/categoria_provider.dart';
import 'package:money/services/movimiento_provider.dart';
import 'package:money/components/customAppBar.dart';

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
    final List<String> categorias = ['Todos'] +
        categoriaProvider.categorias
            .map((categoria) => categoria.nombre)
            .toList();

    final movimientoProvider = Provider.of<MovimientoProvider>(context);
    final List<Movimiento> movimientos = movimientoProvider.movimientos;

    List<Movimiento> movimientosFiltrados = movimientos.where((movimiento) {
      bool matchCategoria = _selectedCategoria == 'Todos' ||
          movimiento.categoria == _selectedCategoria;
      bool matchTipoMovimiento = _selectedTipoMovimiento == 'Todos' ||
          movimiento.tipo == _selectedTipoMovimiento;
      return matchCategoria && matchTipoMovimiento;
    }).toList();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.deepPurple[50],
        appBar: CustomAppBar(showTitle: true, titleText: 'Análisis'),
        body: Container(
          margin: const EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                  child: Container(
                child: Text('aqui unas graficas bien mamalonas'),
              )),
              Expanded(
                child: movimientosFiltrados.isNotEmpty
                    ? ListView.builder(
                        itemCount: movimientosFiltrados.length,
                        itemBuilder: (context, index) {
                          final movimiento = movimientosFiltrados[index];
                          return ListTile(
                            title: Text(
                                "${movimiento.tipo}: \$${movimiento.cantidad}"),
                            subtitle: Text(
                                "${movimiento.categoria} - ${movimiento.concepto}"),
                          );
                        },
                      )
                    : Center(child: Text("No hay movimientos para mostrar")),
              ),
              SizedBox(height: 10),
              _filtros(categorias),
            ],
          ),
        ),
      ),
    );
  }

  Row _filtros(List<String> categorias) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 140,
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(5),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: _selectedCategoria,
              dropdownColor: Colors.blueAccent,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategoria = newValue!;
                });
              },
              items: categorias.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.deepPurple, borderRadius: BorderRadius.circular(5)),
          height: 50,
          width: 50,
          margin: EdgeInsets.all(5),
          child: GestureDetector(
            child: Icon(Icons.download),
            onTap: () {
              print('descargando');
            },
          ),
        ),
        Container(
          width: 140,
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
              color: Colors.blueAccent, borderRadius: BorderRadius.circular(5)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              dropdownColor: Colors.blue,
              borderRadius: BorderRadius.circular(10),
              value: _selectedTipoMovimiento,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedTipoMovimiento = newValue!;
                });
              },
              items: ['Todos', 'Ingreso', 'Egreso']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
