import 'package:agiledevs/Utils/estado.dart';
import 'package:agiledevs/apis/api.dart';
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
  final double mediaAvaliacoes;
  final int totalAvaliacoes;
  final VoidCallback onAtualizarMedia;

  const ModalAvaliacao({
    super.key,
    required this.avaliacoes,
    required this.usuarioLogado,
    required this.onAvaliacaoSubmit,
    required this.onAvaliacaoDelete,
    required this.mediaAvaliacoes,
    required this.totalAvaliacoes,
    required this.onAtualizarMedia,
  });

  @override
  State<ModalAvaliacao> createState() => _ModalAvaliacaoState();
}

class _ModalAvaliacaoState extends State<ModalAvaliacao> {
  late List<Avaliacao> _avaliacoesLocais;
  late ServicoAvaliacoes _servicoAvaliacoes;

  late double _mediaAvaliacoes;
  late int _totalAvaliacoes;

  @override
  void initState() {
    super.initState();
    _avaliacoesLocais = List.from(widget.avaliacoes);
    _servicoAvaliacoes = ServicoAvaliacoes();

    _mediaAvaliacoes = widget.mediaAvaliacoes;
    _totalAvaliacoes = widget.totalAvaliacoes;
  }

  Future<void> _handleAddAvaliacao(Avaliacao novaAvaliacao) async {
    final adicionar = await _servicoAvaliacoes.adicionarAvaliacao(
      novaAvaliacao.metodoId,
      novaAvaliacao.nome,
      novaAvaliacao.email,
      novaAvaliacao.nota,
      novaAvaliacao.tagsPositivas,
      novaAvaliacao.tagsNegativas,
      novaAvaliacao.comentario,
    );

    if (adicionar) {
      setState(() {
        _avaliacoesLocais.insert(0,novaAvaliacao);
      });

      Toast.show(
        "Avaliação enviada com sucesso!",
        gravity: Toast.bottom,
        duration: Toast.lengthShort,
      );

      widget.onAvaliacaoSubmit(novaAvaliacao);
      await _atualizarMediaLocal();
    } else {
      Toast.show(
        "Erro ao enviar avaliação. Tente novamente.",
        gravity: Toast.bottom,
        duration: Toast.lengthShort,
      );
    }
  }

  Future<void> _handleDeleteAvaliacao(int index) async {
    final avaliacao = _avaliacoesLocais[index];
    final email = avaliacao.email;
    final metodoId = estadoApp.idMetodo;

    final sucesso = await _servicoAvaliacoes.excluirAvaliacao(email, metodoId);

    if (sucesso) {
      setState(() {
        _avaliacoesLocais.removeAt(index);
      });

      Toast.show(
        "Avaliação excluída com sucesso.",
        duration: Toast.lengthShort,
        gravity: Toast.bottom,
      );

      widget.onAvaliacaoDelete(index);
      _atualizarMediaLocal();
    } else {
      Toast.show(
        "Erro ao excluir avaliação. Tente novamente.",
        duration: Toast.lengthShort,
        gravity: Toast.bottom,
      );
    }
  }

  Future<void> _atualizarMediaLocal() async {
    try {
      final resultado = await _servicoAvaliacoes.mediaAvaliacoesPorMetodo(
        estadoApp.idMetodo,
      );

      setState(() {
        _mediaAvaliacoes = resultado['media'] ?? 0.0;
        _totalAvaliacoes = resultado['total'] ?? 0;
      });

      widget.onAtualizarMedia(); // Notifica o pai para se atualizar também
    } catch (e) {
      setState(() {
        _mediaAvaliacoes = 0.0;
        _totalAvaliacoes = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cabeçalho com média e botão de adicionar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Avaliações",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      ...List.generate(5, (index) {
                        if (index < _mediaAvaliacoes.floor()) {
                          return const Icon(Icons.star, color: Colors.amber);
                        } else if (index < _mediaAvaliacoes) {
                          return const Icon(
                            Icons.star_half,
                            color: Colors.amber,
                          );
                        } else {
                          return const Icon(
                            Icons.star_border,
                            color: Colors.amber,
                          );
                        }
                      }),
                      const SizedBox(width: 15),
                      Text(
                        "${_mediaAvaliacoes.toStringAsFixed(1)} de $_totalAvaliacoes",
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
                          onAvaliacaoSubmit: _handleAddAvaliacao,
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

        // Lista de avaliações
        Expanded(
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

                      if (!podeExcluir) return card;

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
                          return await showDialog<bool>(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: const Text("Excluir Avaliação"),
                                      content: const Text(
                                        "Deseja mesmo excluir esta avaliação?",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () => Navigator.of(
                                                context,
                                              ).pop(false),
                                          child: const Text("Cancelar"),
                                        ),
                                        TextButton(
                                          onPressed:
                                              () => Navigator.of(
                                                context,
                                              ).pop(true),
                                          child: const Text("Excluir"),
                                        ),
                                      ],
                                    ),
                              ) ??
                              false;
                        },
                        onDismissed: (_) => _handleDeleteAvaliacao(index),
                        child: card,
                      );
                    },
                  ),
        ),
      ],
    );
  }
}
