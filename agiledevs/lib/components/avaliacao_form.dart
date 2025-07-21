import 'package:agiledevs/Utils/estado.dart';
import 'package:agiledevs/models/avaliacao.dart';
import 'package:flutter/material.dart';

class AvaliacaoForm extends StatefulWidget {
  final Future<void> Function(Avaliacao) onAvaliacaoSubmit;

  const AvaliacaoForm({super.key, required this.onAvaliacaoSubmit});

  @override
  State<AvaliacaoForm> createState() => _AvaliacaoFormState();
}

class _AvaliacaoFormState extends State<AvaliacaoForm> {
  int _nota = 0;

  final List<String> _tagsPositivasDisponiveis = [
    "Excelente!",
    "Muito útil!",
    "Solução eficaz",
    "Facilitou meu trabalho",
  ];

  final List<String> _tagsNegativasDisponiveis = [
    "Mediano",
    "Ruim",
    "Não funcionou para mim",
    "Não atendeu as expectativas",
  ];

  final List<String> _tagsPositivasSelecionadas = [];
  final List<String> _tagsNegativasSelecionadas = [];

  final _comentarioController = TextEditingController();

  void _toggleTag(String tag, {required bool positiva}) {
    setState(() {
      final lista =
          positiva ? _tagsPositivasSelecionadas : _tagsNegativasSelecionadas;
      if (lista.contains(tag)) {
        lista.remove(tag);
      } else {
        lista.add(tag);
      }
    });
  }

  void _atualizarNota(int novaNota) {
    setState(() {
      _nota = novaNota;
      // Limpar tags quando a nota muda
      if (novaNota >= 4) {
        _tagsNegativasSelecionadas.clear();
      } else if (novaNota > 0) {
        _tagsPositivasSelecionadas.clear();
      }
    });
  }

  Future<void> _enviarAvaliacao() async {
    final usuario = estadoApp.usuario;

    if (usuario == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Você precisa estar logado para avaliar."),
        ),
      );
      return;
    }

    final avaliacao = Avaliacao(
      metodoId: estadoApp.idMetodo,
      nome: usuario.nome ?? '',
      email: usuario.email ?? '',
      nota: _nota,
      tagsPositivas: _tagsPositivasSelecionadas,
      tagsNegativas: _tagsNegativasSelecionadas,
      comentario: _comentarioController.text.trim(),
    );

    await widget.onAvaliacaoSubmit(avaliacao);
    Navigator.of(context).pop();
  }

  Widget _buildEstrelas() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(5, (index) {
        final filled = index < _nota;
        return IconButton(
          icon: Icon(
            filled ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
          onPressed: () => _atualizarNota(index + 1),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 25,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Avalie este método",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildEstrelas(),
                ],
              ),
            ),
            const SizedBox(height: 10),
            if (_nota >= 4) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    _tagsPositivasDisponiveis.map((tag) {
                      final selecionada = _tagsPositivasSelecionadas.contains(
                        tag,
                      );
                      return ChoiceChip(
                        label: Text(tag),
                        selected: selecionada,
                        selectedColor: Colors.green,
                        labelStyle: TextStyle(
                          color: selecionada ? Colors.white : Colors.black,
                        ),
                        //borda
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: selecionada ? Colors.green : Colors.grey,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        onSelected: (_) => _toggleTag(tag, positiva: true),
                      );
                    }).toList(),
              ),
            ],

            if (_nota > 0 && _nota < 4) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    _tagsNegativasDisponiveis.map((tag) {
                      final selecionada = _tagsNegativasSelecionadas.contains(
                        tag,
                      );
                      return ChoiceChip(
                        label: Text(tag),
                        selected: selecionada,
                        selectedColor: Colors.red.shade900,
                        labelStyle: TextStyle(
                          color: selecionada ? Colors.white : Colors.black,
                        ),
                        //borda
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: selecionada ? Colors.red.shade900 : Colors.grey,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        onSelected: (_) => _toggleTag(tag, positiva: false),
                      );
                    }).toList(),
              ),
            ],

            const SizedBox(height: 45),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Feedback",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _comentarioController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Deixe o seu feedback...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: _enviarAvaliacao,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF150050),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      "Enviar",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}     