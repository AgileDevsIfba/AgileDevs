import 'package:agiledevs/Utils/estado.dart';
import 'package:agiledevs/screens/detalhes.dart';
import 'package:agiledevs/screens/metodos.dart';
import 'package:agiledevs/screens/metodos_salvos.dart';
import 'package:agiledevs/screens/praticas.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");

  runApp(const AgileDevsApp());
}

class AgileDevsApp extends StatelessWidget {
  const AgileDevsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EstadoApp(),
      child: MaterialApp(
        title: 'AgileDevs',
        theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromARGB(255, 217, 217, 217),
          appBarTheme: AppBarTheme(
            backgroundColor: const Color(0xFF150050),
            foregroundColor: Colors.white,
            titleTextStyle: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          textTheme: TextTheme(
            titleLarge: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
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

  // Controla o estado que qual tela foi chamada
  void _onItemTapped(int index) {
    if (index == 0) {
      estadoApp.showMetodos();
    } else if (index == 1) {
      estadoApp.showPractices();
    } else if (index == 2) {
      estadoApp.showSavedMethods();
    }
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
      telaAtual = const Praticas();
    }

    if (estadoApp.situacao == Situacao.showSavedMethods) {
      telaAtual = const MetodosSalvos();
    }


    int currentIndex = 0;
    if (estadoApp.situacao == Situacao.showMetodos) {
      currentIndex = 0;
    } else if (estadoApp.situacao == Situacao.showPractices) {
      currentIndex = 1;
    } else if (estadoApp.situacao == Situacao.showSavedMethods) {
      currentIndex = 2;
    }

    return Scaffold(
      body: telaAtual,
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.white,
          selectedLabelStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: const Color(0xFF150050),
          ),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 35),
              label: 'Home',
              activeIcon: Icon(
                Icons.home_rounded,
                color: Color(0xFF150050),
                size: 35,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined, size: 35),
              label: 'Práticas',
              activeIcon: Icon(
                Icons.menu_book_sharp,
                color: Color(0xFF150050),
                size: 35,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_outline, size: 35),
              label: 'Salvos',
              activeIcon: Icon(
                Icons.bookmark,
                color: Color(0xFF150050),
                size: 35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
