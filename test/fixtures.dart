import 'dart:convert';

import 'package:flutter/foundation.dart' show FlutterError;
import 'package:flutter/services.dart';

const _text = 'Первое тестовое предложение. Второе тестовое предложение.';

Map<String, Object?> _section(String title) => {
  'title': title,
  'description': _text,
};

List<Map<String, Object?>> _sections(int count) => [
  for (var i = 1; i <= count; i++) _section('Тестовый пункт $i'),
];

/// Данные тестов независимы от редактируемого содержимого assets/data.
Map<String, String> fixtureFiles() {
  final data = <String, Object?>{
    'project': {
      'id': 'school-research-test',
      'title': 'Тестовый учебный проект',
      'subtitle': _text,
      'fundamentalQuestion': 'Тестовый основополагающий вопрос?',
      'annotation': _text,
      'relevance': _text,
      'goal': _text,
      'tasks': _sections(3),
      'academicYear': 'Тестовый учебный год',
      'classInfo': {
        'title': 'Тестовый класс',
        'school': 'Тестовая организация',
        'description': _text,
      },
      'workOrganization': _text,
      'stages': _sections(3),
      'expectedResults': _sections(2),
      'hero': {'eyebrow': 'Тестовый проект', 'description': _text},
      'footerNote': 'Тестовые данные',
    },
    'groups': [
      for (var i = 1; i <= 3; i++)
        {
          'id': 'group-$i',
          'title': 'Тестовая группа $i',
          'question': 'Тестовый проблемный вопрос $i?',
          'summary': _text,
          'relevance': _text,
          'goal': _text,
          'hypothesis': _text,
          'methods': _sections(2),
          'stages': _sections(3),
          'results': _text,
          'conclusion': _text,
          'products': [
            if (i != 3)
              {
                'title': 'Тестовый продукт $i',
                'description': _text,
                'url': i == 1 ? 'https://example.com/product' : '',
              },
          ],
        },
    ],
    'conclusions': {
      'summary': _text,
      'mainFindings': _sections(3),
      'answer': _text,
      'practicalSignificance': _text,
      'futureWork': _sections(2),
    },
    'teacher': {
      'description': _text,
      'overview': _text,
      'targetAudience': _text,
      'subjects': _sections(2),
      'educationalGoals': _sections(2),
      'learningOutcomes': _sections(2),
      'preparation': _sections(2),
      'methodicalRecommendations': _text,
      'groupWork': _text,
      'stages': _sections(3),
      'assessmentCriteria': _sections(3),
      'reflection': _text,
      'sources': [
        {
          'title': 'Тестовый источник 1',
          'description': _text,
          'url': 'https://example.com/source',
        },
      ],
      'additionalMaterials': [
        {'title': 'Тестовый материал 1', 'description': _text},
      ],
    },
  };
  return {
    for (final entry in data.entries)
      'assets/data/${entry.key}.json': jsonEncode(entry.value),
  };
}

/// Изолированная загрузка из памяти: тесты не зависят от внешних сервисов.
class MemoryAssetBundle extends CachingAssetBundle {
  MemoryAssetBundle(this.files);

  final Map<String, String> files;
  final Map<String, int> reads = {};

  @override
  Future<ByteData> load(String key) async {
    reads.update(key, (count) => count + 1, ifAbsent: () => 1);
    final content = files[key];
    if (content == null) throw FlutterError('Asset not found: $key');
    return ByteData.sublistView(Uint8List.fromList(utf8.encode(content)));
  }
}
