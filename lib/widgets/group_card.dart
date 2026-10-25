import 'package:flutter/material.dart';

import '../models/site_content.dart';
import 'illustrated_decor.dart';
import 'navigation_menu.dart';
import 'story_theme.dart';

/// Единый шаблон иллюстрированной карточки; на главной используется краткий вид.
class GroupCard extends StatelessWidget {
  const GroupCard({required this.group, this.showResults = true, super.key});

  final ResearchGroup group;
  final bool showResults;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    void open() => openSection(context, '/groups/${group.id}');
    return Card.outlined(
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: open,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ColoredBox(
              color: StoryColors.mint,
              child: StoryArtwork(asset: group.imageAsset, height: 200),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.title,
                    style: theme.textTheme.titleLarge?.copyWith(fontSize: 38),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    group.question,
                    style: theme.textTheme.titleMedium?.copyWith(fontSize: 15),
                  ),
                  const SizedBox(height: 14),
                  Text(group.summary, style: theme.textTheme.bodyMedium),
                  if (showResults) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      child: Divider(),
                    ),
                    Text(
                      'Основные результаты',
                      style: theme.textTheme.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(group.results, style: theme.textTheme.bodyMedium),
                  ],
                  const SizedBox(height: 20),
                  TextButton.icon(
                    key: ValueKey('open-group-${group.id}'),
                    onPressed: open,
                    icon: const Icon(Icons.arrow_forward, size: 18),
                    label: const Text('Подробнее'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
