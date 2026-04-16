import 'package:flutter/material.dart';

class SettingTile extends StatelessWidget {
  const SettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    super.key,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            CircleAvatar(radius: 19, child: Icon(icon, size: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.bodyLarge),
                  Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
            trailing ?? const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}
