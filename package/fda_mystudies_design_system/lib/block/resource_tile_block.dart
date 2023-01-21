import 'package:flutter/material.dart';

class ResourceTileBlock extends StatelessWidget {
  final String title;
  final String? subtitle;
  final void Function() onTap;

  const ResourceTileBlock(
      {super.key, required this.title, this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    var scaleFactor = MediaQuery.of(context).textScaleFactor;
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.description_outlined,
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.7),
                  size: 20 * scaleFactor)
            ]),
            title: Text(title, style: Theme.of(context).textTheme.titleMedium),
            subtitle: (subtitle != null && subtitle?.isNotEmpty == true)
                ? Text(subtitle ?? '',
                    style: Theme.of(context).textTheme.bodySmall)
                : null,
            onTap: onTap));
  }
}
