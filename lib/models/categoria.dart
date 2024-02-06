class Categoria {
  String id;
  String nombre;
  int color;
  String icono;

  Categoria({
    required this.id,
    required this.nombre,
    required this.color,
    required this.icono,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'color': color,
      'icono': icono,
    };
  }

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'],
      nombre: json['nombre'],
      color: json['color'],
      icono: json['icono'],
    );
  }
}
