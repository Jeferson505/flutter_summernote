import 'package:flutter/material.dart';

class BottomToolbarItem extends StatelessWidget {
  final void Function() onTap;
  final IconData icon;
  final String label;

  const BottomToolbarItem({
    super.key,
    required this.onTap,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 20, color: Colors.grey[800]),
        label: Text(label, style: TextStyle(color: Colors.grey[800])),
      ),
    );
  }
}
