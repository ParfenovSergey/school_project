import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:school_project/models/site_content.dart';
import 'package:school_project/services/content_service.dart';

import 'fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Map<String, String> files;
  late MemoryAssetBundle bundle;
  late ContentService service;

  setUp(() {
    files = fixtureFiles();
    bundle = MemoryAssetBundle(files);
    service = ContentService(bundle: bundle);
  });

  test('JSON проекта преобразуется в типизированную модель', () {
    final project = ProjectContent.fromJson(
      jsonDecode(files['assets/data/project.json']!),
    );
    expect(project.title, 'Тестовый учебный проект');
    expect(project.classInfo.title, 'Тестовый класс');
    expect(project.tasks, isNotEmpty);
    expect(project.hero.description, contains('Первое тестовое'));
  });

  test('Иллюстрации необязательны и читаются как пути к локальным assets', () {
    final data =
        jsonDecode(files['assets/data/project.json']!) as Map<String, Object?>;
    final hero = data['hero']! as Map<String, Object?>;
    expect(ProjectContent.fromJson(data).hero.imageAsset, isNull);
    hero['imageAsset'] = 'assets/images/project/test.webp';
    expect(
      ProjectContent.fromJson(data).hero.imageAsset,
      'assets/images/project/test.webp',
    );
    hero['imageAsset'] = 42;
    expect(() => ProjectContent.fromJson(data), throwsFormatException);
  });

  test('JSON группы содержит методы, этапы и информационные продукты', () {
    final data = jsonDecode(files['assets/data/groups.json']!) as List<Object?>;
    final group = ResearchGroup.fromJson(data.first);
    expect(group.id, 'group-1');
    expect(group.methods, hasLength(2));
    expect(group.stages, hasLength(3));
    expect(group.products.single.url?.host, 'example.com');
  });

  test('Отсутствующее обязательное поле сообщает свой путь', () {
    final data =
        jsonDecode(files['assets/data/project.json']!) as Map<String, Object?>;
    data.remove('title');
    expect(
      () => ProjectContent.fromJson(data),
      throwsA(
        isA<FormatException>().having(
          (e) => e.message,
          'message',
          contains(r'$.title'),
        ),
      ),
    );
  });

  test('Неверный тип поля не замалчивается', () {
    final data =
        jsonDecode(files['assets/data/project.json']!) as Map<String, Object?>;
    data['tasks'] = 'не массив';
    expect(
      () => ProjectContent.fromJson(data),
      throwsA(
        isA<FormatException>().having(
          (e) => e.message,
          'message',
          contains(r'$.tasks'),
        ),
      ),
    );
  });

  test('Ошибка вложенного поля содержит индекс элемента', () {
    final data =
        jsonDecode(files['assets/data/project.json']!) as Map<String, Object?>;
    data['stages'] = [
      <String, Object?>{'title': 'Этап', 'description': 12},
    ];
    expect(
      () => ProjectContent.fromJson(data),
      throwsA(
        isA<FormatException>().having(
          (e) => e.message,
          'message',
          contains(r'$.stages[0].description'),
        ),
      ),
    );
  });

  test('Все четыре тестовых файла успешно загружаются', () async {
    expect(await service.getProject(), isA<ProjectContent>());
    expect(await service.getGroups(), hasLength(3));
    expect((await service.getConclusions()).mainFindings, isNotEmpty);
    expect((await service.getTeacher()).assessmentCriteria, isNotEmpty);
  });

  test('Одинаковый Future и один доступ к файлу до очистки кэша', () async {
    final first = service.getGroups();
    final second = service.getGroups();
    expect(identical(first, second), isTrue);
    await first;
    expect((await service.getGroup('group-1'))?.id, 'group-1');
    expect(bundle.reads['assets/data/groups.json'], 1);
    service.clearCache();
    await service.getGroups();
    expect(bundle.reads['assets/data/groups.json'], 2);
  });

  test('Неизвестная группа возвращает null', () async {
    expect(await service.getGroup('unknown'), isNull);
  });

  test('Отсутствующий файл даёт понятную ошибку', () async {
    files.remove('assets/data/project.json');
    await expectLater(
      service.getProject(),
      throwsA(
        isA<ContentException>().having(
          (e) => e.message,
          'message',
          contains('project.json недоступен'),
        ),
      ),
    );
  });

  test('Некорректный синтаксис JSON даёт понятную ошибку', () async {
    files['assets/data/project.json'] = '{';
    await expectLater(
      service.getProject(),
      throwsA(
        isA<ContentException>().having(
          (e) => e.message,
          'message',
          contains('Ошибка в assets/data/project.json'),
        ),
      ),
    );
  });

  test(
    'После исправления файла кэш можно очистить и загрузить снова',
    () async {
      final original = files['assets/data/project.json']!;
      files['assets/data/project.json'] = '{}';
      await expectLater(service.getProject(), throwsA(isA<ContentException>()));
      files['assets/data/project.json'] = original;
      service.clearCache();
      expect((await service.getProject()).id, 'school-research-test');
    },
  );

  test('Повторяющийся идентификатор группы отклоняется', () {
    final data = jsonDecode(files['assets/data/groups.json']!) as List<Object?>;
    expect(
      () => ResearchGroup.listFromJson([data.first, data.first]),
      throwsA(
        isA<FormatException>().having(
          (e) => e.message,
          'message',
          contains('повторяется'),
        ),
      ),
    );
  });

  test('Идентификатор группы пригоден для маршрута', () {
    final data =
        (jsonDecode(files['assets/data/groups.json']!) as List<Object?>).first
            as Map<String, Object?>;
    data['id'] = 'неверный/id';
    expect(() => ResearchGroup.fromJson(data), throwsFormatException);
  });

  for (final url in [
    null,
    '',
    'не ссылка',
    'javascript:alert(1)',
    'mailto:test@example.com',
    'https://',
  ]) {
    test(
      'Отсутствующий или неподходящий URL не даёт активной ссылки: $url',
      () {
        final product = InformationProduct.fromJson({
          'title': 'Продукт',
          'description': 'Описание',
          'url': url,
        });
        expect(product.url, isNull);
      },
    );
  }

  test('Массив продуктов необязателен', () {
    final data =
        (jsonDecode(files['assets/data/groups.json']!) as List<Object?>).first
            as Map<String, Object?>;
    data.remove('products');
    expect(ResearchGroup.fromJson(data).products, isEmpty);
  });

  test('Неверный тип URL считается ошибкой данных', () {
    expect(
      () => InformationProduct.fromJson({
        'title': 'Продукт',
        'description': 'Описание',
        'url': 42,
      }),
      throwsFormatException,
    );
  });

  test('Редактируемые JSON assets/data соответствуют моделям', () async {
    final actual = <String, String>{
      for (final name in ['project', 'groups', 'conclusions', 'teacher'])
        'assets/data/$name.json': File('assets/data/$name.json')
            .readAsStringSync(),
    };
    final actualService = ContentService(bundle: MemoryAssetBundle(actual));
    await actualService.getProject();
    await actualService.getGroups();
    await actualService.getConclusions();
    await actualService.getTeacher();
  });
}
