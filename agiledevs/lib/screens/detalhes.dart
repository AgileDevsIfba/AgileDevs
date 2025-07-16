// ignore: unused_import
import 'dart:convert';

import 'package:agiledevs/Utils/estado.dart';
import 'package:agiledevs/apis/api.dart';
import 'package:agiledevs/components/modal_avaliacao.dart';
import 'package:agiledevs/models/avaliacao.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:toast/toast.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Detalhes extends StatefulWidget {
  const Detalhes({super.key});

  @override
  State<Detalhes> createState() => _DetalhesState();
}

enum _EstadoMetodo { naoVerificado, temMetodo, semMetodo }

class _DetalhesState extends State<Detalhes> {
  bool _isLoading = true;
  double _mediaAvaliacoes = 0.0;
  int _totalAvaliacoes = 0;
  final bool usuarioLogado = estadoApp.usuario != null;

  _EstadoMetodo _temMetodo = _EstadoMetodo.naoVerificado;

  late List<Avaliacao> _avaliacoesDoMetodo = [];

  late final WebViewController _webViewController;
  late ServicoAvaliacoes _servicoAvaliacoes;
  late ServicoMetodos _servicoMetodos;

  @override
  void initState() {
    super.initState();

    ToastContext().init(context);
    _webViewController =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..clearCache()
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageStarted: (url) {
                setState(() {
                  _isLoading = true;
                });
              },
              onPageFinished: (url) async {
                await _loadAvaliacoes();
                await _loadMediaAvaliacoes();
                setState(() {
                  _isLoading = false;
                });
              },
              onNavigationRequest: (NavigationRequest request) {
                if (request.url.contains('praticas/index.html')) {
                  estadoApp.showPractices();
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            ),
          );
    _servicoMetodos = ServicoMetodos();
    _servicoAvaliacoes = ServicoAvaliacoes();
    _carregarMetodos();
  }

  Future<void> _loadAvaliacoes() async {
    final avaliacoes = await _servicoAvaliacoes.listarAvaliacoesPorMetodo(
      estadoApp.idMetodo,
    );

    setState(() {
      _avaliacoesDoMetodo =
          avaliacoes.map((a) => Avaliacao.fromJson(a)).toList();
    });
  }

  Future<void> _carregarMetodos() async {
    try {
      final metodoJson = await _servicoMetodos.buscarMetodoPorId(
        estadoApp.idMetodo,
      );
      setState(() {
        _temMetodo = _EstadoMetodo.temMetodo;
      });

      final String apiUrl = dotenv.env['API_BASE_URL']!;
      final String folder = metodoJson["folder"];
      _webViewController.loadRequest(Uri.parse("$apiUrl/$folder/index.html"));
    } catch (e) {
      setState(() {
        _temMetodo = _EstadoMetodo.semMetodo;
      });
    }
  }

  Future<void> _loadMediaAvaliacoes() async {
    try {
      final avaliacaoMedia = await _servicoAvaliacoes.mediaAvaliacoesPorMetodo(estadoApp.idMetodo);
      setState(() {
        _mediaAvaliacoes = avaliacaoMedia['media'] ?? 0.0;
        _totalAvaliacoes = avaliacaoMedia['total'] ?? 0;
      });
    } catch (e) {
      setState(() {
        _mediaAvaliacoes = 0.0;
        _totalAvaliacoes = 0;
      });
    }
  }

  Widget _exibirMensagemMetodoInexistente() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 6),
              child: Text("AgileDevs", style: TextStyle(color: Colors.black)),
            ),
            GestureDetector(
              onTap: () {
                estadoApp.showMetodos();
              },
              child: const Icon(Icons.arrow_back, color: Colors.black),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.error, size: 48, color: Colors.red),
            SizedBox(height: 16),
            Text(
              "Produto inexistente :(",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.red,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Selecione outro produto na tela anterior.",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _exibirMetodo() {
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
          // WebView
          Expanded(
            child: Stack(
              children: [
                WebViewWidget(controller: _webViewController),
                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed:
            () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder:
                  (context) => Container(
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: ModalAvaliacao(
                      avaliacoes: _avaliacoesDoMetodo,
                      usuarioLogado: usuarioLogado,
                      mediaAvaliacoes: _mediaAvaliacoes,
                      totalAvaliacoes: _totalAvaliacoes,
                      onAvaliacaoSubmit: (avaliacao) {
                        setState(() => _avaliacoesDoMetodo.add(avaliacao));
                        _loadMediaAvaliacoes();
                      },
                      onAvaliacaoDelete: (index) {
                        setState(() => _avaliacoesDoMetodo.removeAt(index));
                        _loadMediaAvaliacoes();
                      },
                      onAtualizarMedia: () {
                        _loadMediaAvaliacoes();
                      },
                    ),
                  ),
            ),
        label: const Text(
          "Avaliações",
          style: TextStyle(fontSize: 16, color: Color(0xFF150050)),
        ),
        icon: const Icon(Icons.reviews, color: Color(0xFF150050)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget detalhes = const SizedBox.shrink();

    if (_temMetodo == _EstadoMetodo.naoVerificado) {
      detalhes = const SizedBox.shrink();
    } else if (_temMetodo == _EstadoMetodo.temMetodo) {
      detalhes = _exibirMetodo();
    } else {
      detalhes = _exibirMensagemMetodoInexistente();
    }

    return detalhes;
  }
}
