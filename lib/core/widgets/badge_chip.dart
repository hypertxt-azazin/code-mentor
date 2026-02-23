import 'package:flutter/material.dart';

class BadgeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const BadgeChip({
    super.key,
    required this.label,
    this.icon = Icons.star,
    this.color = Colors.amber,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 16, color: color),
      label: Text(label, style: const TextStyle(fontSize: 12)),
      backgroundColor: color.withOpacity(0.1),
    );
  }
}
