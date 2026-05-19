import 'package:flutter/material.dart';

class ItemFilterChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const ItemFilterChip({
    super.key,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ChoiceChip(
        label: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black,
            fontSize: 12,
          ),
        ),
        selected: isActive,
        selectedColor: Colors.blueGrey[800],
        onSelected: (_) => onTap(),
      ),
    );
  }
}
