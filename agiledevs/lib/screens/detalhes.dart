import 'dart:convert';

import 'package:agiledevs/Utils/estado.dart';
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
  late dynamic _feedEstatico;
  bool _isLoading = true;

  _EstadoMetodo _temMetodo = _EstadoMetodo.naoVerificado;
  late dynamic _metodo;

  late final WebViewController _webViewController;

  @override
  void initState() {
    super.initState();

    ToastContext().init(context);
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..clearCache()
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            _isLoading = true;
          });
        },
        onPageFinished: (url) {
          setState(() {
            _isLoading = false;
          });
        },
      ));
    _readFeedEstatico();
  }

  Future<void> _readFeedEstatico() async {
    final String conteudoJson = await rootBundle.loadString(
      "lib/data/json/feed.json",
    );
    _feedEstatico = await json.decode(conteudoJson);
    _carregarMetodos();
  }

  void _carregarMetodos() {
    setState(() {
      _metodo = _feedEstatico["metodos"].firstWhere(
        (metodo) => metodo["id"] == estadoApp.idMetodo,
      );

      _temMetodo =
          _metodo != null ? _EstadoMetodo.temMetodo : _EstadoMetodo.semMetodo;

      if (_temMetodo == _EstadoMetodo.temMetodo) {
        final String apiUrl = dotenv.env['API_BASE_URL']!;
        final String folder = _metodo["folder"];
        _webViewController.loadRequest(Uri.parse("$apiUrl/$folder/index.html"));
      }
    });
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
          GestureDetector(
            onTap: () {
              estadoApp.showMetodos();
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.arrow_back),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _webViewController),
          if (_isLoading) const Center(child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 1, 141, 255)),
          )),
        ],
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
