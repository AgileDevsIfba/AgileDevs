// ignore: unused_import
import 'dart:convert';
import 'package:agiledevs/apis/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:agiledevs/components/metodo_card.dart';
import 'package:agiledevs/models/metodo.dart';
import 'package:agiledevs/Utils/estado.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class MetodosSalvos extends StatefulWidget {
  const MetodosSalvos({super.key});

  @override
  State<MetodosSalvos> createState() => _MetodosSalvosState();
}

const int tamanhoPagina = 4;

class _MetodosSalvosState extends State<MetodosSalvos> {
  List<Metodo> _metodos = [];
  List<int> _favoritos = [];

  final ScrollController _controladorListaMetodos = ScrollController();
  final TextEditingController _controladorDoFiltro = TextEditingController();

  String _filtro = "";
  int _ultimoMetodo = 0;

  late ServicoFavoritos _servicoFavoritos;

  @override
  void initState() {
    super.initState();

    ToastContext().init(context);
    _servicoFavoritos = ServicoFavoritos();
    _controladorListaMetodos.addListener(() {
      if (_controladorListaMetodos.position.pixels ==
          _controladorListaMetodos.position.maxScrollExtent) {
        _carregarFavoritos();
      }
    });
    _carregarIdsFavoritos();
    _carregarFavoritos();
  }

    void _carregarIdsFavoritos() async {
    final favoritos = await _servicoFavoritos.listarIdsFavoritos(estadoApp.usuario!.email);
    setState(() {
      _favoritos = favoritos;
    });
  }

  void _carregarFavoritos() async {
    if (_filtro.isNotEmpty) {
      _servicoFavoritos
          .buscarFavoritos(
            estadoApp.usuario!.email,
            _ultimoMetodo,
            tamanhoPagina,
            _filtro,
          )
          .then((metodos) {
            _exibirMetodos(metodos);
          });
    } else {
      _servicoFavoritos
          .listarFavoritos(
            estadoApp.usuario!.email,
            _ultimoMetodo,
            tamanhoPagina,
          )
          .then((metodos) {
            _exibirMetodos(metodos);
          });
    }
  }

  Future<void> _alternarFavorito(int metodoId) async {
    if (_favoritos.contains(metodoId)) {
      await ServicoFavoritos().removerFavorito(
        estadoApp.usuario!.email,
        metodoId,
      );
      setState(() => _favoritos.remove(metodoId));
      Toast.show("Método removido da lista de salvos com sucesso!");
    }
  }

  void _exibirMetodos(List<dynamic> metodos) {
    setState(() {
      for (var json in metodos) {
        Metodo metodo = Metodo.fromJson(json as Map<String, dynamic>);
        if (!_metodos.any((m) => m.id == metodo.id)) {
          _metodos.add(metodo);
        }
      }

      if (metodos.isNotEmpty) {
        _ultimoMetodo = metodos.last["id"];
      }
    });
  }

  Future<void> _atualizarMetodos() async {
    _metodos = [];
    _ultimoMetodo = 0;

    _controladorDoFiltro.text = "";
    _filtro = "";

    _carregarFavoritos();
  }

  void _aplicarFiltro(String filtro) {
    _filtro = filtro;

    _metodos.clear();
    _ultimoMetodo = 0;

    _carregarFavoritos();
  }

  @override
  Widget build(BuildContext context) {
    final estadoApp = Provider.of<EstadoApp>(context);
    bool usuarioLogado = estadoApp.usuario != null;
    print("usuario está logado!!!!!!!!: ${usuarioLogado}");
    if (!usuarioLogado) {
      return const Center(
        child: Text("Você precisa estar logado para ver os métodos salvos."),
      );
    }

    if (_metodos.isEmpty) {
      return const Center(child: Text("Nenhum método salvo."));
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                estadoApp.showMetodos();
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.arrow_back),
              ),
            ),
            Row(
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
          ],
        ),
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
