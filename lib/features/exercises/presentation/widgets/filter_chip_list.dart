import 'package:flutter/material.dart';

import 'item_filter_chip.dart';

class FilterChipList extends StatefulWidget {
  final Function(String tipo, {String? muscle, String? name}) onFilterChanged;

  const FilterChipList({super.key, required this.onFilterChanged});

  @override
  State<FilterChipList> createState() => _FilterChipListState();
}

class _FilterChipListState extends State<FilterChipList> {
  String _filtroAtivo = 'Todos';

  void _atualizarFiltro(String tipo, {String? muscle, String? name}) {
    setState(() {
      _filtroAtivo = tipo;
    });
    widget.onFilterChanged(tipo, muscle: muscle, name: name);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        children: [
          ItemFilterChip(
            label: 'Todos (Geral)',
            isActive: _filtroAtivo == 'Todos',
            onTap: () => _atualizarFiltro('Todos'),
          ),
          ItemFilterChip(
            label: 'Peito (Chest Mock)',
            isActive: _filtroAtivo == 'Peito',
            onTap: () => _atualizarFiltro('Peito', muscle: 'chest'),
          ),
          ItemFilterChip(
            label: 'Simular Vazio',
            isActive: _filtroAtivo == 'Vazio',
            onTap: () => _atualizarFiltro('Vazio', muscle: 'vazio'),
          ),
          ItemFilterChip(
            label: 'Simular Erro',
            isActive: _filtroAtivo == 'Erro',
            onTap: () => _atualizarFiltro('Erro', name: 'erro'),
          ),
        ],
      ),
    );
  }
}
