import 'dart:convert';

import 'package:agiledevs/Utils/autenticador.dart';
import 'package:agiledevs/models/usuario.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Situacao { showMetodos, showDetails, showPractices, showSavedMethods, showModalAvaliacao }

class EstadoApp extends ChangeNotifier {
  Situacao _situacao = Situacao.showMetodos;
  Situacao get situacao => _situacao;

  late int _idMetodo;
  int get idMetodo => _idMetodo;

  Usuario? _usuario;
  Usuario? get usuario => _usuario;
  set usuario(Usuario? usuario) {
    _usuario = usuario;
  }

  List<int> _metodosSalvos = [];
  List<int> get metodosSalvos => _metodosSalvos;

  void showMetodos() {
    _situacao = Situacao.showMetodos;
    notifyListeners();
  }

  void showDetails(int idMetodo) {
    _situacao = Situacao.showDetails;
    _idMetodo = idMetodo;
    notifyListeners();
  }

  void showPractices() {
    _situacao = Situacao.showPractices;
    notifyListeners();
  }

  void showSavedMethods() {
    print('indo para metodos salvos');
    _situacao = Situacao.showSavedMethods;
    notifyListeners();
  }

  void showModalAvaliacao() {
    _situacao = Situacao.showModalAvaliacao;
    notifyListeners();
  }


  void onLogin(Usuario? usuario) async {
    _usuario = usuario;
    await _loadMetodosSalvos();
    notifyListeners();
  }

  void onLogout() {
    _usuario = null;
    notifyListeners();
  }

  Future<void> salvarMetodo(int idMetodo) async {
    if (!_metodosSalvos.contains(idMetodo)) {
      _metodosSalvos.add(idMetodo);
      await _saveMetodosSalvos();
      notifyListeners();
    }
  }

  Future<void> removerMetodo(int idMetodo) async {
    _metodosSalvos.remove(idMetodo);
    await _saveMetodosSalvos();
    notifyListeners();
  }

  bool isMetodoSalvo(int idMetodo) {
    return _metodosSalvos.contains(idMetodo);
  }

  Future<void> _loadMetodosSalvos() async {
    if (_usuario == null) return;

    final prefs = await SharedPreferences.getInstance();
    String? salvos = prefs.getString('metodos_salvos_${_usuario!.email}');
    if (salvos != null) {
      _metodosSalvos = List<int>.from(jsonDecode(salvos));
    } else {
      _metodosSalvos = [];
    }
    notifyListeners();
  }

  Future<void> _saveMetodosSalvos() async {
    if (_usuario == null) return;

    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      'metodos_salvos_${_usuario!.email}',
      jsonEncode(_metodosSalvos),
    );
  }
}

late EstadoApp estadoApp;
