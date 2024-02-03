import 'package:flutter/material.dart';
import 'package:money/models/Movimiento.dart';

class MovimientoProvider with ChangeNotifier {
  List<Movimiento> _movimientos = [];

  List<Movimiento> get movimientos => _movimientos;

  void agregarMovimiento(Movimiento Movimiento) {
    _movimientos.add(Movimiento);
    notifyListeners();
  }

  void editarMovimiento(
      Movimiento MovimientoAntigua, Movimiento MovimientoNueva) {
    int index = _movimientos.indexOf(MovimientoAntigua);
    if (index != -1) {
      _movimientos[index] = MovimientoNueva;
      notifyListeners();
    }
  }

  void eliminarMovimiento(Movimiento Movimiento) {
    _movimientos.remove(Movimiento);
    notifyListeners();
  }

  double getTotalIngresos() {
    return _movimientos
        .where((movimiento) => movimiento.tipo == "Ingreso")
        .fold(0.0, (sum, current) => sum + current.cantidad);
  }

  // Método para calcular la sumatoria de los egresos
  double getTotalEgresos() {
    return _movimientos
        .where((movimiento) => movimiento.tipo == "Egreso")
        .fold(0.0, (sum, current) => sum + current.cantidad);
  }
}
