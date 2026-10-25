import 'package:flutter/material.dart';

import '../models/site_content.dart';
import '../services/content_service.dart';
import '../widgets/content_widgets.dart';

/// Методические рекомендации: все важные разделы доступны без раскрытия.
class TeacherPage extends StatelessWidget {
  const TeacherPage({required this.service, super.key});

  final ContentService service;

  @override
  Widget build(BuildContext context) => AsyncContent<TeacherContent>(
    load: service.getTeacher,
    onRetry: service.clearCache,
    builder: (content) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(
          title: 'Методические рекомендации',
          description: content.description,
          eyebrow: 'Учителю',
        ),
        ContentSectionView(
          title: 'Общая характеристика учебного проекта',
          child: BodyCopy(content.overview),
        ),
        ContentSectionView(
          title: 'Целевая аудитория',
          child: BodyCopy(content.targetAudience),
        ),
        ContentSectionView(
          title: 'Учебные предметы и межпредметные связи',
          child: SectionList(sections: content.subjects),
        ),
        ContentSectionView(
          title: 'Образовательные цели',
          child: SectionList(sections: content.educationalGoals),
        ),
        ContentSectionView(
          title: 'Планируемые образовательные результаты',
          child: SectionList(sections: content.learningOutcomes),
        ),
        ContentSectionView(
          title: 'Подготовка проекта',
          child: SectionList(sections: content.preparation, numbered: true),
        ),
        ContentSectionView(
          title: 'Методические рекомендации',
          child: BodyCopy(content.methodicalRecommendations),
        ),
        ContentSectionView(
          title: 'Организация групповой работы',
          child: BodyCopy(content.groupWork),
        ),
        ContentSectionView(
          title: 'Этапы проведения',
          child: SectionList(sections: content.stages, numbered: true),
        ),
        ContentSectionView(
          title: 'Критерии оценивания',
          child: SectionList(sections: content.assessmentCriteria),
        ),
        ContentSectionView(
          title: 'Рефлексия',
          child: BodyCopy(content.reflection),
        ),
        ContentSectionView(
          title: 'Источники информации',
          child: ProductsList(products: content.sources),
        ),
        ContentSectionView(
          title: 'Дополнительные методические материалы',
          child: ProductsList(products: content.additionalMaterials),
        ),
      ],
    ),
  );
}
