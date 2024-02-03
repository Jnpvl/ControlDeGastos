import 'package:flutter/material.dart';
import 'package:money/models/categoria.dart';

class CategoriaProvider with ChangeNotifier {
  List<Categoria> _categorias = [];

  List<Categoria> get categorias => _categorias;

  void agregarCategoria(Categoria categoria) {
    _categorias.add(categoria);
    notifyListeners();
  }

  void editarCategoria(Categoria categoriaAntigua, Categoria categoriaNueva) {
    int index = _categorias.indexOf(categoriaAntigua);
    if (index != -1) {
      _categorias[index] = categoriaNueva;
      notifyListeners();
    }
  }

  void eliminarCategoria(Categoria categoria) {
    _categorias.remove(categoria);
    notifyListeners();
  }
}
