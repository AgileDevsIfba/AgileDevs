// ignore: unused_import
import 'dart:convert';

import 'package:agiledevs/Utils/autenticador.dart';
import 'package:agiledevs/Utils/estado.dart';
import 'package:agiledevs/components/autenticacao_dialog.dart';
import 'package:agiledevs/components/metodo_card.dart';
import 'package:agiledevs/models/metodo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:agiledevs/apis/api.dart';

class Metodos extends StatefulWidget {
  const Metodos({super.key});

  @override
  State<Metodos> createState() => _MetodosState();
}

const int tamanhoPagina = 4;

class _MetodosState extends State<Metodos> {
  List<dynamic> _metodos = [];
  List<int> _favoritos = [];

  final ScrollController _controladorListaMetodos = ScrollController();
  final TextEditingController _controladorDoFiltro = TextEditingController();

  // ignore: unused_field
  String _filtro = "";

  late ServicoMetodos _servicoMetodos;
  late ServicoFavoritos _servicoFavoritos;
  late ServicoAvaliacoes _servicoAvaliacoes;

  int _ultimoMetodo = 0;

  @override
  void initState() {
    super.initState();

    ToastContext().init(context);
    _servicoMetodos = ServicoMetodos();
    _servicoFavoritos = ServicoFavoritos();
    _servicoAvaliacoes = ServicoAvaliacoes();
    _controladorListaMetodos.addListener(() {
      if (_controladorListaMetodos.position.pixels ==
          _controladorListaMetodos.position.maxScrollExtent) {
        _carregarMetodos();
      }
    });
    _carregarMetodos();
    _recuperarUsuario();
    _carregarFavoritos();
  }

  void _recuperarUsuario() {
    Autenticador.recuperarUsuario().then(
      (usuario) => estadoApp.onLogin(usuario),
    );
    _carregarFavoritos();
  }

  void _carregarFavoritos() async{
    if (estadoApp.usuario != null) {
      final favoritos = await _servicoFavoritos.listarIdsFavoritos(estadoApp.usuario!.email);
      setState(() {
        _favoritos = favoritos;
      });
    }
  }

  Future<void> _alternarFavorito(int metodoId) async {
  if (_favoritos.contains(metodoId)) {
    await ServicoFavoritos().removerFavorito(estadoApp.usuario!.email, metodoId);
    setState(() => _favoritos.remove(metodoId));
    Toast.show("Método removido da lista de salvos com sucesso!");
  } else {
    await ServicoFavoritos().adicionarFavorito(estadoApp.usuario!.email, metodoId);
    setState(() => _favoritos.add(metodoId));
    Toast.show("Adicionado a lista de salvos com sucesso!");
  }
}

  void _carregarMetodos() {
    if (_filtro.isNotEmpty) {
      _servicoMetodos.findMetodos(_ultimoMetodo, tamanhoPagina, _filtro).then((
        metodos,
      ) {
        _exibirMetodos(metodos);
      });
    } else {
      _servicoMetodos.getMetodos(_ultimoMetodo, tamanhoPagina).then((metodos) {
        _exibirMetodos(metodos);
      });
    }
  }

  void _exibirMetodos(List<dynamic> metodos) {
  for (var json in metodos) {
    Metodo metodo = Metodo.fromJson(json as Map<String, dynamic>);

    if (!_metodos.any((m) => m.id == metodo.id)) {
      setState(() {
        _metodos.add(metodo);
      });

      _servicoAvaliacoes.mediaAvaliacoesPorMetodo(metodo.id).then((resultado) {
        final media = resultado['media']?.toDouble() ?? 0.0;
        final totalAvaliacoes = resultado['total'] ?? 0;

        setState(() {
          final index = _metodos.indexWhere((m) => m.id == metodo.id);
          if (index != -1) {
            _metodos[index].mediaNota = media;
            _metodos[index].totalAvaliacoes = totalAvaliacoes;
          }
        });
      });
    }
  }

  if (metodos.isNotEmpty) {
    setState(() {
      _ultimoMetodo = metodos.last["id"];
    });
  }
}


  Future<void> _atualizarMetodos() async {
    _metodos = [];
    _ultimoMetodo = 0;

    _controladorDoFiltro.text = "";
    _filtro = "";

    _carregarMetodos();
  }

  void _aplicarFiltro(String filtro) {
    _filtro = filtro;

    _metodos.clear();
    _ultimoMetodo = 0;

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
              controller: _controladorDoFiltro,
              onSubmitted: (filtro) {
                _aplicarFiltro(filtro);
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
            child: RefreshIndicator(
              color: Colors.blue,
              onRefresh: () => _atualizarMetodos(),
              child: GridView.builder(
                controller: _controladorListaMetodos,
                scrollDirection: Axis.vertical,
                physics: const AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 1.8,
                ),
                padding: const EdgeInsets.all(12.0),
                itemCount: _metodos.length,
                itemBuilder: (context, index) {
                  Metodo metodo = _metodos[index];
                  return MetodoCard(
                    metodos: metodo,
                    usuarioLogado: usuarioLogado,
                    isFavorito: _favoritos.contains(metodo.id),
                    onToggleFavorito: () => _alternarFavorito(metodo.id),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
