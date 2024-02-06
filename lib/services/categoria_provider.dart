import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:money/models/categoria.dart';

class CategoriaProvider with ChangeNotifier {
  final LocalStorage storage = new LocalStorage('categorias.json');
  List<Categoria> _categorias = [];

  CategoriaProvider() {
    _loadCategoriasFromStorage();
  }

  List<Categoria> get categorias => _categorias;

  void _loadCategoriasFromStorage() async {
    await storage.ready;
    var items = storage.getItem('categorias');
    if (items != null) {
      _categorias = List<Categoria>.from(
          (items as List).map((item) => Categoria.fromJson(item)));
      notifyListeners();
    }
  }

  void _saveCategoriasToStorage() async {
    await storage.ready;
    storage.setItem('categorias',
        _categorias.map((categoria) => categoria.toJson()).toList());
  }

  void agregarCategoria(Categoria categoria) {
    _categorias.add(categoria);
    _saveCategoriasToStorage();
    notifyListeners();
  }

  void editarCategoria(Categoria categoriaAntigua, Categoria categoriaNueva) {
    int index = _categorias.indexOf(categoriaAntigua);
    if (index != -1) {
      _categorias[index] = categoriaNueva;
      _saveCategoriasToStorage();
      notifyListeners();
    }
  }

  void eliminarCategoria(Categoria categoria) {
    _categorias.removeWhere((cat) => cat.id == categoria.id);
    _saveCategoriasToStorage();
    notifyListeners();
  }
}
