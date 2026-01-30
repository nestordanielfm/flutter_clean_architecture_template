import 'package:flutter/material.dart';
import 'package:template_app/features/episodes/domain/entities/episode.dart';

class EpisodeListItem extends StatelessWidget {
  final Episode episode;

  const EpisodeListItem({super.key, required this.episode});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(
          '${episode.number}',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
      title: Text(
        episode.name,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        'Production Code: ${episode.productionCode}',
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).textTheme.bodySmall?.color,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 4,
      ),
    );
  }
}
