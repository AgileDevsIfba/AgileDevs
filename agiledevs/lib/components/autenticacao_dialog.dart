import 'package:agiledevs/Utils/autenticador.dart';
import 'package:agiledevs/Utils/estado.dart';
import 'package:agiledevs/apis/api.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class AutenticacaoDialog extends StatelessWidget {
  const AutenticacaoDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final estadoApp = Provider.of<EstadoApp>(context, listen: false);
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      contentPadding: const EdgeInsets.all(24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Faça seu login no AgileApp para curtir e comentar sobre os métodos ágeis!",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 25),
          ElevatedButton.icon(
            icon: const Icon(FontAwesomeIcons.google, color: Colors.white),
            label: const Text(
              "Entrar com o Google",
              style: TextStyle(color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              Navigator.of(context).pop();
              final usuario = await Autenticador.login();
              estadoApp.onLogin(usuario);
              if (usuario != null) {
                Toast.show(
                    "Você foi conectado com sucesso!",
                    duration: Toast.lengthLong,
                    gravity: Toast.bottom,
                  );
                final usuarioSalvo = await ServicoUsuarios().salvar(usuario);
                if (usuarioSalvo != null) {
                  Toast.show(
                    "Usuário salvo com sucesso!",
                    duration: Toast.lengthLong,
                    gravity: Toast.bottom,
                  );
                } else {
                  Toast.show(
                    "Erro ao salvar usuário no servidor",
                    duration: Toast.lengthLong,
                    gravity: Toast.bottom,
                  );
                }
              }
            },
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
