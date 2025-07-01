import 'package:agiledevs/Utils/estado.dart';
import 'package:agiledevs/components/autenticacao_dialog.dart';
import 'package:agiledevs/models/metodo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class MetodoCard extends StatelessWidget {
  final Metodo metodos;
  final bool usuarioLogado;
  const MetodoCard(this.metodos, this.usuarioLogado, {super.key});

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
              image: AssetImage(metodos.image),
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
                                  usuarioLogado && estadoApp.metodosSalvos.contains(metodos.id)
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                ),
                                color:
                                    usuarioLogado ? Colors.white : Colors.grey,
                                onPressed: () async {
                                  if (!usuarioLogado) {
                                    showDialog(
                                      context: context,
                                      builder: (context) => const AutenticacaoDialog(),
                                    );
                                  } else {
                                    if (estadoApp.metodosSalvos.contains(
                                      metodos.id,
                                    )) {
                                      await estadoApp.removerMetodo(metodos.id);
                                      Toast.show(
                                        "Método removido dos salvos",
                                        duration: Toast.lengthShort,
                                        gravity: Toast.bottom,
                                      );
                                    } else {
                                      await estadoApp.salvarMetodo(metodos.id);
                                      Toast.show(
                                        "Método salvo com sucesso",
                                        duration: Toast.lengthShort,
                                        gravity: Toast.bottom,
                                      );
                                    }
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
                            Icon(Icons.star, color: Colors.yellow, size: 25),
                            // Text(
                            //   'likes: ${mt.likes}',
                            // )
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
