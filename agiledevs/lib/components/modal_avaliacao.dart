import 'package:agiledevs/Utils/estado.dart';
import 'package:agiledevs/components/avaliacao_card.dart';
import 'package:agiledevs/components/avaliacao_form.dart';
import 'package:agiledevs/models/avaliacao.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class ModalAvaliacao extends StatefulWidget {
  final List<Avaliacao> avaliacoes;
  final bool usuarioLogado;
  final Function(Avaliacao) onAvaliacaoSubmit;
  final Function(int) onAvaliacaoDelete;

  const ModalAvaliacao({
    super.key,
    required this.avaliacoes,
    required this.usuarioLogado,
    required this.onAvaliacaoSubmit,
    required this.onAvaliacaoDelete,
  });

  @override
  State<ModalAvaliacao> createState() => _ModalAvaliacaoState();
}

class _ModalAvaliacaoState extends State<ModalAvaliacao> {
  late List<Avaliacao> _avaliacoesLocais;

  @override
  void initState() {
    super.initState();
    _avaliacoesLocais = List.from(widget.avaliacoes);
  }

  void _handleAddAvaliacao(Avaliacao novaAvaliacao) {
    setState(() {
      _avaliacoesLocais.add(novaAvaliacao);
    });
    // Atualiza também o pai (se necessário)
    widget.onAvaliacaoSubmit(novaAvaliacao);
  }

  void _handleDeleteAvaliacao(int index) {
    setState(() {
      _avaliacoesLocais.removeAt(index);
    });
    widget.onAvaliacaoDelete(index);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Avaliações",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // BOTÃO PARA ADICIONAR AVALIAÇÃO
            IconButton(
              icon: const Icon(Icons.add, size: 40),
              onPressed: () {
                if (widget.usuarioLogado) {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    builder:
                        (context) => AvaliacaoForm(
                          onAvaliacaoSubmit: (avaliacao) {
                            _handleAddAvaliacao(avaliacao);
                          },
                        ),
                  );
                } else {
                  Toast.show(
                    "Você precisa estar logado para adicionar uma avaliação.",
                    duration: Toast.lengthShort,
                    gravity: Toast.bottom,
                  );
                }
              },
              color: widget.usuarioLogado ? Colors.black : Colors.grey,
            ),
          ],
        ),
        const Divider(color: Colors.grey, thickness: 1, height: 1),
        Expanded(
          flex: 2,
          child:
              _avaliacoesLocais.isEmpty
                  ? const Center(
                    child: Text(
                      "Nenhuma avaliação encontrada.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                  : ListView.builder(
                    itemCount: _avaliacoesLocais.length,
                    itemBuilder: (context, index) {
                      final avaliacao = _avaliacoesLocais[index];
                      final podeExcluir =
                          avaliacao.email == estadoApp.usuario?.email;
                      final card = AvaliacaoCard(avaliacao);

                      if (!podeExcluir) {
                        return card;
                      }

                      return Dismissible(
                        key: Key(avaliacao.email),
                        background: Container(
                          color: Colors.redAccent,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),
                        confirmDismiss: (direction) async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: const Text("Excluir Avaliação"),
                                  content: const Text(
                                    "Você tem certeza que deseja excluir esta avaliação?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () =>
                                              Navigator.of(context).pop(false),
                                      child: const Text("Cancelar"),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.of(context).pop(true),
                                      child: const Text("Excluir"),
                                    ),
                                  ],
                                ),
                          );
                          return confirm ?? false;
                        },
                        onDismissed: (direction) {
                          _handleDeleteAvaliacao(index);
                        },
                        child: card,
                      );
                    },
                  ),
        ),
      ],
    );
  }
}
