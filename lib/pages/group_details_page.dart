import 'package:flutter/material.dart';

import '../models/site_content.dart';
import '../services/content_service.dart';
import '../widgets/content_widgets.dart';
import '../widgets/navigation_menu.dart';
import 'not_found_page.dart';

/// Универсальная страница группы, выбранной по идентификатору из URL.
class GroupDetailsPage extends StatelessWidget {
  const GroupDetailsPage({
    required this.groupId,
    required this.service,
    super.key,
  });

  final String groupId;
  final ContentService service;

  @override
  Widget build(BuildContext context) => AsyncContent<ResearchGroup?>(
    load: () => service.getGroup(groupId),
    onRetry: service.clearCache,
    builder: (group) {
      if (group == null) return const NotFoundPage(isGroup: true);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => openSection(context, '/groups'),
              icon: const Icon(Icons.arrow_back),
              label: const Text('К списку групп'),
            ),
          ),
          const SizedBox(height: 20),
          PageHeader(
            title: group.title,
            description: group.summary,
            eyebrow: 'Исследование',
          ),
          ContentPanel(
            title: 'Проблемный вопрос',
            text: group.question,
            highlighted: true,
            icon: Icons.help_outline,
          ),
          const SizedBox(height: 36),
          ContentSectionView(
            title: 'Актуальность исследования',
            child: BodyCopy(group.relevance),
          ),
          ContentSectionView(
            title: 'Цель исследования',
            child: BodyCopy(group.goal),
          ),
          ContentSectionView(
            title: 'Гипотеза',
            child: BodyCopy(group.hypothesis),
          ),
          ContentSectionView(
            title: 'Методы исследования',
            child: SectionList(sections: group.methods),
          ),
          ContentSectionView(
            title: 'Этапы выполнения работы',
            child: SectionList(sections: group.stages, numbered: true),
          ),
          ContentSectionView(
            title: 'Полученные результаты',
            child: BodyCopy(group.results),
          ),
          ContentSectionView(
            title: 'Выводы группы',
            child: BodyCopy(group.conclusion),
          ),
          ContentSectionView(
            title: 'Информационные продукты',
            child: ProductsList(products: group.products),
          ),
        ],
      );
    },
  );
}
