import 'package:flutter/material.dart';

class BottomToolbarItem extends StatelessWidget {
  final void Function() onTap;
  final IconData icon;
  final String label;

  const BottomToolbarItem({
    Key? key,
    required this.onTap,
    required this.icon,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon),
            Text(label),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }
}
