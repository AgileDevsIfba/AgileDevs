import 'package:agiledevs/Utils/estado.dart';
import 'package:agiledevs/screens/detalhes.dart';
import 'package:agiledevs/screens/metodos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); 

  await dotenv.load(fileName: ".env"); 

  runApp(const AgileDevsApp());
}

class AgileDevsApp extends StatelessWidget {
  const AgileDevsApp({super.key}); // a

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EstadoApp(),
      child: MaterialApp(
        title: 'AgileDevs',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: const Color(0xFF150050),
            foregroundColor: Colors.white,
            titleTextStyle: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w600,
            )
          ),
          textTheme: TextTheme(
            titleLarge: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            )
          )
        ),
        home: Tela(),
      ),
    );
  }
}

class Tela extends StatefulWidget {
  const Tela({super.key});
  @override
  State<Tela> createState() => _TelaState();
}

class _TelaState extends State<Tela> {
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    estadoApp = Provider.of<EstadoApp>(context);

    Widget telaAtual = const SizedBox(); 

    if (estadoApp.situacao == Situacao.showMetodos) {
      telaAtual = const Metodos();
    }

    if (estadoApp.situacao == Situacao.showDetails) {
      telaAtual = const Detalhes();
    }

    if (estadoApp.situacao == Situacao.showPractices) {
      telaAtual = Text(
        'Práticas',
        style: Theme.of(context).textTheme.titleLarge,
      );
    }
    
    return telaAtual;
  }
}
