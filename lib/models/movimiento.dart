class Movimiento {
  String id;
  double cantidad;
  String tipo;
  String categoria;
  String concepto;
  DateTime fecha;

  Movimiento({
    required this.cantidad,
    required this.tipo,
    required this.categoria,
    required this.concepto,
    required this.fecha,
    required this.id,
  });
}
