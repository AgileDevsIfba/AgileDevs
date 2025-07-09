// ignore: unused_import
import 'dart:convert';

import 'package:agiledevs/models/usuario.dart';
import 'package:flutter/material.dart';

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
    _situacao = Situacao.showSavedMethods;
    notifyListeners();
  }

  void showModalAvaliacao() {
    _situacao = Situacao.showModalAvaliacao;
    notifyListeners();
  }


  void onLogin(Usuario? usuario) async {
    _usuario = usuario;
    notifyListeners();
  }

  void onLogout() {
    _usuario = null;
    notifyListeners();
  }

}

late EstadoApp estadoApp;
