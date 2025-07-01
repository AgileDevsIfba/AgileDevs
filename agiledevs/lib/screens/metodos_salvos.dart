import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:agiledevs/components/metodo_card.dart';
import 'package:agiledevs/models/metodo.dart';
import 'package:agiledevs/Utils/estado.dart';

class MetodosSalvos extends StatefulWidget {
  const MetodosSalvos({super.key});

  @override
  State<MetodosSalvos> createState() => _MetodosSalvosState();
}

class _MetodosSalvosState extends State<MetodosSalvos> {
  List<Metodo> _metodos = [];

  @override
  void initState() {
    super.initState();
    estadoApp.addListener(_onEstadoAppChanged);
    _carregarMetodos();
  }

  @override
  void dispose() {
    estadoApp.removeListener(_onEstadoAppChanged);
    super.dispose();
  }

  void _onEstadoAppChanged() {
    _carregarMetodos();
  }

  Future<void> _carregarMetodos() async {
    final String conteudoJson = await rootBundle.loadString(
      "lib/data/json/feed.json",
    );
    final feed = json.decode(conteudoJson);
    List<dynamic> todosMetodos = feed["metodos"];

    List<Metodo> metodosFiltrados =
        todosMetodos
            .where((json) => estadoApp.metodosSalvos.contains(json["id"]))
            .map((json) => Metodo.fromJson(json))
            .toList();

    setState(() {
      _metodos = metodosFiltrados;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool usuarioLogado = estadoApp.usuario != null;
    print("usuario está logado!!!!!!!!: ${usuarioLogado}" );
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
      body: ListView.builder(
        itemCount: _metodos.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: MetodoCard(_metodos[index], usuarioLogado),
          );
        },
      ),
    );
  }
}
