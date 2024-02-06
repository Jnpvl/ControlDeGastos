class Movimiento {
  double cantidad;
  String tipo;
  String categoria;
  String concepto;
  DateTime fecha;
  String id;

  Movimiento({
    required this.cantidad,
    required this.tipo,
    required this.categoria,
    required this.concepto,
    required this.fecha,
    required this.id,
  });

  Map<String, dynamic> toJson() {
    return {
      'cantidad': cantidad,
      'tipo': tipo,
      'categoria': categoria,
      'concepto': concepto,
      'fecha': fecha.toIso8601String(),
      'id': id,
    };
  }

  factory Movimiento.fromJson(Map<String, dynamic> json) {
    return Movimiento(
      cantidad: json['cantidad'],
      tipo: json['tipo'],
      categoria: json['categoria'],
      concepto: json['concepto'],
      fecha: DateTime.parse(json['fecha']),
      id: json['id'],
    );
  }
}
