import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:money/models/Movimiento.dart';
import 'dart:convert';

class MovimientoProvider with ChangeNotifier {
  final LocalStorage storage = LocalStorage('movimientos_storage');
  List<Movimiento> _movimientos = [];

  MovimientoProvider() {
    _loadFromLocalStorage();
  }

  List<Movimiento> get movimientos => _movimientos;

  Future<void> _loadFromLocalStorage() async {
    await storage.ready;
    var items = storage.getItem('movimientos');
    if (items != null) {
      _movimientos = (json.decode(items) as List)
          .map((item) => Movimiento.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    }
    notifyListeners();
  }

  void _saveToLocalStorage() {
    storage.setItem('movimientos',
        json.encode(_movimientos.map((m) => m.toJson()).toList()));
  }

  void agregarMovimiento(Movimiento movimiento) {
    _movimientos.add(movimiento);
    _saveToLocalStorage();
    notifyListeners();
  }

  void editarMovimiento(
      Movimiento movimientoAntiguo, Movimiento movimientoNuevo) {
    int index = _movimientos.indexOf(movimientoAntiguo);
    if (index != -1) {
      _movimientos[index] = movimientoNuevo;
      _saveToLocalStorage();
      notifyListeners();
    }
  }

  void eliminarMovimiento(String id) {
    _movimientos.removeWhere((movimiento) => movimiento.id == id);
    _saveToLocalStorage();
    notifyListeners();
  }

  double getTotalIngresos() {
    return _movimientos
        .where((movimiento) => movimiento.tipo == "Ingreso")
        .fold(0.0, (sum, current) => sum + current.cantidad);
  }

  double getTotalEgresos() {
    return _movimientos
        .where((movimiento) => movimiento.tipo == "Egreso")
        .fold(0.0, (sum, current) => sum + current.cantidad);
  }
}
