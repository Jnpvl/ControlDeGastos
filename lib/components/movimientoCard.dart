import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:money/models/icon_mapping.dart';
import 'package:provider/provider.dart';
import 'package:money/services/movimiento_provider.dart';
import 'package:money/services/categoria_provider.dart';
import 'package:money/models/Movimiento.dart';
import 'package:money/models/categoria.dart';

class MovimientosCard extends StatelessWidget {
  final int? maxItems;
  final bool enableDelete;

  MovimientosCard({this.maxItems, this.enableDelete = true});

  IconData _getIconData(String iconName) {
    return iconosMapeados[iconName] ?? Icons.error;
  }

  @override
  Widget build(BuildContext context) {
    final movimientoProvider = Provider.of<MovimientoProvider>(context);

    if (movimientoProvider.movimientos.isEmpty) {
      return Center(
        child: Column(
          children: [
            SizedBox(height: 40),
            Text("Aún no hay movimientos registrados"),
          ],
        ),
      );
    } else {
      final categoriaProvider = Provider.of<CategoriaProvider>(context);

      final itemCount = maxItems == null
          ? movimientoProvider.movimientos.length
          : min(maxItems!, movimientoProvider.movimientos.length);

      return Expanded(
        child: ListView.builder(
          itemCount: itemCount,
          itemBuilder: (context, index) {
            int invertedIndex =
                movimientoProvider.movimientos.length - 1 - index;
            if (maxItems != null) {
              invertedIndex =
                  max(movimientoProvider.movimientos.length - index - 1, 0);
            }
            Movimiento movimiento =
                movimientoProvider.movimientos[invertedIndex];
            Categoria categoria = categoriaProvider.categorias.firstWhere(
              (cat) => cat.nombre == movimiento.categoria,
              orElse: () => Categoria(
                  id: '',
                  nombre: '',
                  color: Colors.grey.value,
                  icono: 'error_outline'),
            );
            String fechaFormateada =
                DateFormat('dd/MM/yyyy').format(movimiento.fecha);

            final item = _card(categoria, movimiento, fechaFormateada, context);
            if (enableDelete) {
              return Dismissible(
                key: Key(movimiento.id.toString()),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  movimientoProvider.eliminarMovimiento(movimiento.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Movimiento eliminado")));
                },
                background: Container(
                  color: Colors.red,
                  child: Align(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Icon(Icons.delete, color: Colors.white),
                        Text(" Eliminar",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                            textAlign: TextAlign.right),
                        SizedBox(width: 20),
                      ],
                    ),
                    alignment: Alignment.centerRight,
                  ),
                ),
                child: item,
              );
            } else {
              return item;
            }
          },
        ),
      );
    }
  }

  Widget _card(Categoria categoria, Movimiento movimiento,
      String fechaFormateada, BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 0, right: 15),
      height: 70,
      margin: EdgeInsets.only(right: 10, left: 10, top: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                height: 70,
                width: 70,
                margin: EdgeInsets.all(5),
                child: Icon(
                  _getIconData(categoria.icono),
                  color: Color(categoria.color),
                  size: 60,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(capitalizeFirstLetter(movimiento.concepto),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(fechaFormateada),
                ],
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                  "${signo(movimiento.tipo)} \$${movimiento.cantidad.toStringAsFixed(2)}",
                  style: TextStyle(
                      fontSize: 18,
                      color: textColor(movimiento.tipo),
                      fontWeight: FontWeight.bold)),
              Text(movimiento.tipo,
                  style: TextStyle(
                      color: textColor(movimiento.tipo),
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  String capitalizeFirstLetter(String text) => text.isEmpty
      ? ''
      : '${text[0].toUpperCase()}${text.substring(1).toLowerCase()}';

  String signo(String tipo) => tipo == "Ingreso" ? "+" : "-";

  Color textColor(String tipo) => tipo == "Ingreso" ? Colors.green : Colors.red;
}
