import 'package:flutter/material.dart';

import '../models/site_content.dart';
import '../services/content_service.dart';
import '../widgets/content_widgets.dart';

/// Обобщённые выводы без дублирования основополагающего вопроса в JSON.
class ConclusionsPage extends StatelessWidget {
  const ConclusionsPage({
    required this.project,
    required this.service,
    super.key,
  });

  final ProjectContent project;
  final ContentService service;

  @override
  Widget build(BuildContext context) => AsyncContent<ConclusionsContent>(
    load: service.getConclusions,
    onRetry: service.clearCache,
    builder: (content) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(title: 'Итоги проекта', description: content.summary),
        ContentSectionView(
          title: 'Основополагающий вопрос',
          child: BodyCopy(project.fundamentalQuestion),
        ),
        ContentSectionView(
          title: 'Основные выводы класса',
          child: SectionList(sections: content.mainFindings, numbered: true),
        ),
        ContentPanel(
          title: 'Ответ на основополагающий вопрос',
          text: content.answer,
          highlighted: true,
          icon: Icons.check_circle_outline,
        ),
        const SizedBox(height: 36),
        ContentSectionView(
          title: 'Практическая значимость',
          child: BodyCopy(content.practicalSignificance),
        ),
        ContentSectionView(
          title: 'Дальнейшая работа',
          child: SectionList(sections: content.futureWork),
        ),
      ],
    ),
  );
}
