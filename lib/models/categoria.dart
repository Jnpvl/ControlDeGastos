import 'package:flutter/material.dart';

class Categoria {
  String id;
  String nombre;
  Color color;
  IconData icono;

  Categoria(
      {required this.nombre,
      required this.color,
      required this.icono,
      required this.id});
}
