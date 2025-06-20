import 'package:flutter/material.dart';
import 'package:agiledevs/Utils/estado.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Praticas extends StatefulWidget {
  const Praticas({super.key});

  @override
  State<Praticas> createState() => _PraticasState();
}

class _PraticasState extends State<Praticas> {
  bool _isLoading = true;
  late final WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
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
              onPageFinished: (url) {
                setState(() {
                  _isLoading = false;
                });
              },
            ),
          );

    _loadPraticas();
  }

  void _loadPraticas() {
    final String apiUrl = dotenv.env['API_BASE_URL']!;
    if (apiUrl.isNotEmpty) {
      _webViewController.loadRequest(Uri.parse("$apiUrl/praticas/index.html"));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('URL da API de práticas não configurada.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: Stack(
        children: [
          WebViewWidget(controller: _webViewController),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 1, 141, 255),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
