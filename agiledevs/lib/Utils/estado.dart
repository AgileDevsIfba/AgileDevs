
import 'package:agiledevs/Utils/autenticador.dart';
import 'package:flutter/material.dart';

enum Situacao {
  showMetodos,
  showDetails,
  showPractices
}

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

  void onLogin(Usuario usuario) {
    _usuario = usuario;
    notifyListeners();
  }

  void onLogout() {
    _usuario = null;
    notifyListeners();
  }

}

late EstadoApp estadoApp;