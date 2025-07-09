import 'package:agiledevs/Utils/estado.dart';
import 'package:agiledevs/components/autenticacao_dialog.dart';
import 'package:agiledevs/models/metodo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MetodoCard extends StatelessWidget {
  final Metodo metodos;
  final bool isFavorito;
  final bool usuarioLogado;
  final VoidCallback onToggleFavorito;

  const MetodoCard({
    required this.metodos,
    required this.isFavorito,
    required this.usuarioLogado,
    required this.onToggleFavorito,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final estadoApp = Provider.of<EstadoApp>(context);

    return GestureDetector(
      onTap: () {
        estadoApp.showDetails(metodos.id);
      },
      child: Card(
        color: const Color(0x50150050),
        elevation: 5,
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('lib/data/images/method.png'),
              fit: BoxFit.cover,
              opacity: 0.3,
            ),
            color: const Color(0x80150050),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            metodos.title.toUpperCase(),
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomRight,
                          child: Consumer<EstadoApp>(
                            builder: (context, value, child) {
                              return IconButton(
                                icon: Icon(
                                  usuarioLogado && isFavorito
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                ),
                                color:
                                    usuarioLogado ? Colors.white : Colors.grey,
                                onPressed: () async {
                                  if (!usuarioLogado) {
                                    showDialog(
                                      context: context,
                                      builder:
                                          (context) =>
                                              const AutenticacaoDialog(),
                                    );
                                  } else {
                                    onToggleFavorito();
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            metodos.description,
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            ...List.generate(5, (index) {
                              final media =
                                  metodos.mediaNota ??
                                  0.0; // garante que não seja nulo
                              if (index < media.floor()) {
                                return const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 20,
                                );
                              } else if (index < media) {
                                return const Icon(
                                  Icons.star_half,
                                  color: Colors.amber,
                                  size: 20,
                                );
                              } else {
                                return const Icon(
                                  Icons.star_border,
                                  color: Colors.amber,
                                  size: 20,
                                );
                              }
                            }),
                            const SizedBox(width: 6),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
