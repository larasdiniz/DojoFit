import 'package:flutter/material.dart';

class CardExercicio extends StatelessWidget {
  final String nome;
  final String subtitulo;
  final String categoria;

  const CardExercicio({
    super.key,
    required this.nome,
    required this.subtitulo,
    required this.categoria,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.fitness_center)),
        title: Text(nome, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitulo),
        trailing: Chip(
          label: Text(categoria, style: const TextStyle(fontSize: 12)),
          backgroundColor: Colors.grey[200],
        ),
      ),
    );
  }
}
