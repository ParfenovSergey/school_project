import 'package:flutter/material.dart';

import '../models/site_content.dart';
import '../services/content_service.dart';
import '../widgets/content_widgets.dart';
import '../widgets/group_card.dart';
import '../widgets/illustrated_decor.dart';
import '../widgets/navigation_menu.dart';
import '../widgets/story_theme.dart';

/// Иллюстрированная главная с общей для всех групп навигацией.
class HomePage extends StatelessWidget {
  const HomePage({required this.project, required this.service, super.key});

  final ProjectContent project;
  final ContentService service;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      _Hero(project: project),
      ContentWidth(
        padding: const EdgeInsets.fromLTRB(24, 8, 24, 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ResponsiveCards(
              maxColumns: 2,
              children: [
                ContentPanel(
                  title: 'Кратко о проекте',
                  text: project.annotation,
                  icon: Icons.explore_outlined,
                ),
                ContentPanel(
                  title: project.classInfo.title,
                  text: project.classInfo.description,
                  icon: Icons.school_outlined,
                ),
              ],
            ),
            const SizedBox(height: 48),
            ContentSectionView(
              title: 'Исследовательские группы',
              child: AsyncContent<List<ResearchGroup>>(
                load: service.getGroups,
                onRetry: service.clearCache,
                builder: (groups) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (groups.isEmpty)
                      const EmptyNotice(
                        'Исследовательские группы пока не добавлены.',
                      )
                    else
                      ResponsiveCards(
                        children: [
                          for (final group in groups.take(3))
                            GroupCard(group: group, showResults: false),
                        ],
                      ),
                    const SizedBox(height: 24),
                    OutlinedButton.icon(
                      onPressed: () => openSection(context, '/groups'),
                      icon: const Icon(Icons.arrow_forward),
                      label: const Text('Все работы групп'),
                    ),
                  ],
                ),
              ),
            ),
            AsyncContent<ConclusionsContent>(
              load: service.getConclusions,
              onRetry: service.clearCache,
              builder: (conclusions) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ContentPanel(
                    title: 'Общие выводы',
                    text: conclusions.answer,
                    highlighted: true,
                    icon: Icons.fact_check_outlined,
                  ),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: () => openSection(context, '/conclusions'),
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Все итоги проекта'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _Hero extends StatelessWidget {
  const _Hero({required this.project});

  final ProjectContent project;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                StoryColors.deepOcean,
                Color(0xFF007D8E),
                Color(0xFF84DDDA),
              ],
              stops: [0, 0.68, 1],
            ),
          ),
          child: Stack(
            children: [
              const Positioned.fill(child: SkyOrnaments()),
              Column(
                children: [
                  ContentWidth(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 8),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final wide =
                            constraints.maxWidth >= 820 &&
                            MediaQuery.textScalerOf(context).scale(16) <= 22;
                        final copy = Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.1),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                project.hero.eyebrow,
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            Semantics(
                              header: true,
                              child: Text(
                                project.title,
                                style: theme.textTheme.headlineLarge?.copyWith(
                                  fontSize: wide ? 84 : 54,
                                  color: const Color(0xFFFFF8DA),
                                  height: 1.05,
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              project.hero.description,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: Colors.white,
                                fontSize: wide ? 16 : 15,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                FilledButton.icon(
                                  onPressed: () =>
                                      openSection(context, '/project'),
                                  icon: const Icon(
                                    Icons.arrow_forward,
                                    size: 18,
                                  ),
                                  label: const Text('О проекте'),
                                ),
                                OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    side: const BorderSide(color: Colors.white),
                                  ),
                                  onPressed: () =>
                                      openSection(context, '/groups'),
                                  child: const Text('Работы групп'),
                                ),
                              ],
                            ),
                          ],
                        );
                        final artwork = StoryArtwork(
                          asset: project.hero.imageAsset,
                          height: wide ? 455 : 215,
                          hero: true,
                        );
                        return wide
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(flex: 6, child: copy),
                                  const SizedBox(width: 24),
                                  Expanded(flex: 5, child: artwork),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  copy,
                                  const SizedBox(height: 12),
                                  artwork,
                                ],
                              );
                      },
                    ),
                  ),
                  const CloudEdge(height: 90),
                ],
              ),
            ],
          ),
        ),
        ContentWidth(
          padding: const EdgeInsets.fromLTRB(24, 4, 24, 40),
          child: Column(
            children: [
              Semantics(
                header: true,
                child: Text(
                  'Основополагающий вопрос',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall,
                ),
              ),
              const SizedBox(height: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 780),
                child: Text(
                  project.fundamentalQuestion,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(fontSize: 20),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 56,
                height: 4,
                decoration: BoxDecoration(
                  color: StoryColors.gold,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
