import 'package:agiledevs/models/avaliacao.dart';
import 'package:flutter/material.dart';

class AvaliacaoCard extends StatelessWidget {
  final Avaliacao avaliacao;

  const AvaliacaoCard(this.avaliacao, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(side: BorderSide.none),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0xFF150050), // Cor da borda inferior
              width: 1, // Espessura da borda
            ),
          ),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 30, // Largura do círculo
                  height: 30, // Altura do círculo
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black, // Cor da borda
                      width: 2.0, // Espessura da borda
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Icon(
                      Icons.person, // Ícone dentro do círculo
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  avaliacao.nome,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // notas
            Row(
              children: List.generate(
                5,
                (index) => Icon(
                  index < avaliacao.nota ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(height: 8),
            if (avaliacao.tagsPositivas.isNotEmpty)
              Wrap(
                spacing: 12,
                children:
                    avaliacao.tagsPositivas.map((tag) {
                      return Chip(
                        label: Text(tag),
                        backgroundColor: Colors.green,
                        labelStyle: const TextStyle(color: Colors.white),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.green,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      );
                    }).toList(),
              ),

            if (avaliacao.tagsNegativas.isNotEmpty)
              Wrap(
                spacing: 6,
                children:
                    avaliacao.tagsNegativas.map((tag) {
                      return Chip(
                        label: Text(tag),
                        backgroundColor: Colors.red.shade900,
                        labelStyle: TextStyle(color: Colors.white),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.red.shade900, // Cor da borda
                            width: 1, // Espessura da borda
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      );
                    }).toList(),
              ),

            if (avaliacao.comentario != null &&
                avaliacao.comentario!.isNotEmpty)
              Text(avaliacao.comentario!),
          ],
        ),
      ),
    );
  }
}
