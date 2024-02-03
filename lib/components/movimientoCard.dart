import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:money/services/movimiento_provider.dart';
import 'package:money/services/categoria_provider.dart';
import 'package:money/models/Movimiento.dart';
import 'package:money/models/categoria.dart';

class MovimientosCard extends StatelessWidget {
  final int? maxItems;
  MovimientosCard({this.maxItems});

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
              orElse: () =>
                  Categoria(nombre: '', color: Colors.grey, icono: Icons.error),
            );
            String fechaFormateada =
                DateFormat('dd/MM/yyyy').format(movimiento.fecha);

            return _card(categoria, movimiento, fechaFormateada);
          },
        ),
      );
    }
  }

  Container _card(
      Categoria categoria, Movimiento movimiento, String fechaFormateada) {
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
                  categoria.icono,
                  color: categoria.color,
                  size: 60,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${capitalizeFirstLetter(movimiento.concepto)}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text('${fechaFormateada}')
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
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '${movimiento.tipo}',
                style: TextStyle(
                    color: textColor(movimiento.tipo),
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
        ],
      ),
    );
  }

  String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  String signo(String tipo) {
    return tipo == "Ingreso" ? "+" : "-";
  }

  Color textColor(String tipo) {
    return tipo == "Ingreso" ? Colors.green : Colors.red;
  }
}
