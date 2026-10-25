import 'package:flutter/material.dart';

import '../models/site_content.dart';
import '../widgets/content_widgets.dart';

/// Общая постановка исследования и последовательность работы класса.
class ProjectPage extends StatelessWidget {
  const ProjectPage({required this.project, super.key});

  final ProjectContent project;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      PageHeader(
        title: project.title,
        description: project.subtitle,
        eyebrow: 'О проекте',
      ),
      ContentPanel(
        title: 'Основополагающий вопрос',
        text: project.fundamentalQuestion,
        highlighted: true,
        icon: Icons.help_outline,
      ),
      const SizedBox(height: 36),
      ContentSectionView(
        title: 'Аннотация проекта',
        child: BodyCopy(project.annotation),
      ),
      ContentSectionView(
        title: 'Актуальность',
        child: BodyCopy(project.relevance),
      ),
      ContentSectionView(title: 'Цель проекта', child: BodyCopy(project.goal)),
      ContentSectionView(
        title: 'Задачи проекта',
        child: SectionList(sections: project.tasks, numbered: true),
      ),
      ContentSectionView(
        title: 'Наш класс',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              project.classInfo.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              project.classInfo.school,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            BodyCopy(project.classInfo.description),
          ],
        ),
      ),
      ContentSectionView(
        title: 'Организация командной работы',
        child: BodyCopy(project.workOrganization),
      ),
      ContentSectionView(
        title: 'Этапы проекта',
        child: SectionList(sections: project.stages, numbered: true),
      ),
      ContentSectionView(
        title: 'Ожидаемые результаты',
        child: SectionList(sections: project.expectedResults),
      ),
    ],
  );
}
