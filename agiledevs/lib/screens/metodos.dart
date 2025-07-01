import 'dart:convert';

import 'package:agiledevs/Utils/autenticador.dart';
import 'package:agiledevs/Utils/estado.dart';
import 'package:agiledevs/components/autenticacao_dialog.dart';
import 'package:agiledevs/components/metodo_card.dart';
import 'package:agiledevs/models/metodo.dart';
import 'package:flat_list/flat_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class Metodos extends StatefulWidget {
  const Metodos({super.key});

  @override
  State<Metodos> createState() => _MetodosState();
}

const int tamanhoPagina = 4;

class _MetodosState extends State<Metodos> {
  dynamic _feedEstatico = [];
  List<dynamic> _metodos = [];

  int _proximaPagina = 1;
  bool _carregando = false;

  late TextEditingController _controladorFiltragem;
  String _filtro = "";

  @override
  void initState() {
    super.initState();

    ToastContext().init(context);
    _controladorFiltragem = TextEditingController();
    _readFeedEstatico();
    _recuperarUsuario();
  }

  void _recuperarUsuario() {
    Autenticador.recuperarUsuario().then(
      (usuario) => estadoApp.onLogin(usuario),
    );
  }

  Future<void> _readFeedEstatico() async {
    final String conteudoJson = await rootBundle.loadString(
      "lib/data/json/feed.json",
    );
    _feedEstatico = await json.decode(conteudoJson);
    _carregarMetodos();
  }

  void _carregarMetodos() {
    if (_carregando || _metodos.length >= _feedEstatico["metodos"].length) {
      return;
    }

    setState(() {
      _carregando = true;
    });

    var maisMetodos = [];
    if (_filtro.isNotEmpty) {
      maisMetodos =
          _feedEstatico["metodos"].where((item) {
            String title = item["title"] ?? "";
            return title.toLowerCase().contains(_filtro.toLowerCase());
          }).toList();
    } else {
      final inicio = (_proximaPagina - 1) * tamanhoPagina;
      final fim = (_proximaPagina * tamanhoPagina).clamp(
        0,
        _feedEstatico["metodos"].length,
      );

      maisMetodos = _feedEstatico["metodos"].sublist(inicio, fim);
    }

    setState(() {
      _metodos.addAll(
        maisMetodos.map((json) => Metodo.fromJson(json)).toList(),
      );
      _proximaPagina++;
      _carregando = false;
    });
  }

  Future<void> _atualizarFeed() async {
    _metodos = [];
    _proximaPagina = 1;
    _carregarMetodos();
  }

  @override
  Widget build(BuildContext context) {
    final estadoApp = Provider.of<EstadoApp>(context);
    bool usuarioLogado = estadoApp.usuario != null;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text("AgileDevs"),
            SizedBox(width: 6),
            Image.asset(
              "lib/data/images/logo.png",
              fit: BoxFit.cover,
              height: 30,
              width: 30,
            ),
          ],
        ),
        actions: [
          MenuAnchor(
            builder: (
              BuildContext context,
              MenuController controller,
              Widget? child,
            ) {
              return IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  if (controller.isOpen) {
                    controller.close();
                  } else {
                    controller.open();
                  }
                },
              );
            },
            menuChildren: [
              if (!usuarioLogado)
                MenuItemButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AutenticacaoDialog(),
                    );
                  },
                  child: SizedBox(
                    width: 80,
                    height: 50,
                    child: Center(
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF150050),
                        ),
                      ),
                    ),
                  ),
                ),
              if (usuarioLogado)
                MenuItemButton(
                  onPressed: () {
                    Autenticador.logout().then((_) {
                      setState(() {
                        estadoApp.onLogout();
                      });
                      Toast.show(
                        "Você foi desconectado com sucesso",
                        duration: Toast.lengthLong,
                        gravity: Toast.bottom,
                      );
                    });
                  },
                  child: SizedBox(
                    width: 80,
                    height: 50,
                    child: Center(
                      child: Text(
                        'Sair',
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF150050),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 17.0,
              bottom: 8.0,
              left: 10.0,
              right: 10.0,
            ),
            child: TextField(
              controller: _controladorFiltragem,
              onChanged: (descricao) {
                setState(() {
                  _filtro = descricao;
                });
                _atualizarFeed();
              },
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF150050), width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF150050), width: 2),
                ),
                hintText: "Pesquisar",
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: FlatList(
              data: _metodos,
              loading: _carregando,
              onRefresh: () {
                _filtro = "";
                _controladorFiltragem.clear();
                return _atualizarFeed();
              },
              onEndReached: () => _carregarMetodos(),
              buildItem: (item, int indice) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 10.0,
                  ),
                  child: Container(child: MetodoCard(item, usuarioLogado)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
