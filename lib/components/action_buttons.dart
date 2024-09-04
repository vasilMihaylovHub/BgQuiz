import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const ActionButtons({
    super.key,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.white),
          onPressed: onEdit,
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete,
        ),
      ],
    );
  }
}
