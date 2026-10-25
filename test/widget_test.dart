import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:school_project/main.dart';
import 'package:school_project/pages/group_details_page.dart';
import 'package:school_project/pages/groups_page.dart';
import 'package:school_project/pages/home_page.dart';
import 'package:school_project/pages/teacher_page.dart';
import 'package:school_project/services/content_service.dart';
import 'package:school_project/widgets/content_widgets.dart';
import 'package:school_project/widgets/group_card.dart';

import 'fixtures.dart';

Future<void> showSite(
  WidgetTester tester, {
  String route = '/',
  Map<String, String>? files,
  Size size = const Size(1440, 1000),
  double textScale = 1,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  tester.platformDispatcher.textScaleFactorTestValue = textScale;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  await tester.pumpWidget(
    SchoolProjectApp(
      key: UniqueKey(),
      initialRoute: route,
      contentService: ContentService(
        bundle: MemoryAssetBundle(files ?? fixtureFiles()),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('Главная показывает проект, класс и три группы', (tester) async {
    await showSite(tester);
    expect(find.byType(HomePage), findsOneWidget);
    expect(find.text('Тестовый учебный проект'), findsWidgets);
    expect(find.text('Тестовый класс'), findsOneWidget);
    expect(find.byType(GroupCard), findsNWidgets(3));
    expect(find.text('Общие выводы'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Отсутствующий файл иллюстрации показывает резервное оформление',
    (tester) async {
      final files = fixtureFiles();
      final project = jsonDecode(
        files['assets/data/project.json']!,
      ) as Map<String, Object?>;
      (project['hero']! as Map<String, Object?>)['imageAsset'] =
          'assets/images/project/missing.webp';
      files['assets/data/project.json'] = jsonEncode(project);
      final groups =
          jsonDecode(files['assets/data/groups.json']!) as List<Object?>;
      (groups.first! as Map<String, Object?>)['imageAsset'] =
          'assets/images/groups/missing.webp';
      files['assets/data/groups.json'] = jsonEncode(groups);
      await showSite(tester, files: files);
      expect(find.byType(HomePage), findsOneWidget);
      expect(find.byType(GroupCard), findsNWidgets(3));
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Список групп доступен через меню', (tester) async {
    await showSite(tester);
    await tester.tap(find.byKey(const ValueKey('header-nav-/groups')));
    await tester.pumpAndSettle();
    expect(find.byType(GroupsPage), findsOneWidget);
    expect(find.byType(GroupCard), findsNWidgets(3));
  });

  testWidgets('Подробнее открывает универсальный экран и возвращает в список', (
    tester,
  ) async {
    await showSite(tester, route: '/groups');
    final button = find.byKey(const ValueKey('open-group-group-1'));
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pumpAndSettle();
    expect(find.byType(GroupDetailsPage), findsOneWidget);
    expect(find.text('Тестовая группа 1'), findsOneWidget);
    expect(find.text('Гипотеза'), findsOneWidget);
    await tester.tap(find.text('К списку групп'));
    await tester.pumpAndSettle();
    expect(find.byType(GroupsPage), findsOneWidget);
  });

  testWidgets('Прямой маршрут группы открывается без главной страницы', (
    tester,
  ) async {
    await showSite(tester, route: '/groups/group-2');
    expect(find.byType(GroupDetailsPage), findsOneWidget);
    expect(find.byType(HomePage), findsNothing);
    expect(find.text('Тестовая группа 2'), findsOneWidget);
    expect(find.text('Ссылка пока не добавлена'), findsOneWidget);
    expect(find.text('Открыть материал'), findsNothing);
  });

  testWidgets('Отсутствие продуктов не нарушает страницу', (tester) async {
    await showSite(tester, route: '/groups/group-3');
    expect(find.text('Материалы пока не добавлены.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Неизвестная группа даёт понятную страницу', (tester) async {
    await showSite(tester, route: '/groups/unknown');
    expect(find.text('Группа не найдена'), findsOneWidget);
    await tester.tap(find.text('К списку групп'));
    await tester.pumpAndSettle();
    expect(find.byType(GroupsPage), findsOneWidget);
  });

  testWidgets('Неизвестный маршрут даёт понятную страницу', (tester) async {
    await showSite(tester, route: '/unknown');
    expect(find.text('Страница не найдена'), findsOneWidget);
  });

  testWidgets('Учителю содержит все методические разделы', (tester) async {
    await showSite(tester, route: '/teacher');
    expect(find.byType(TeacherPage), findsOneWidget);
    expect(find.text('Критерии оценивания'), findsOneWidget);
    expect(find.text('Рефлексия'), findsOneWidget);
    expect(find.text('Дополнительные методические материалы'), findsOneWidget);
    expect(find.text('Тестовый источник 1'), findsOneWidget);
  });

  testWidgets('Мобильное меню открывает выбранный раздел', (tester) async {
    await showSite(tester, size: const Size(390, 844));
    await tester.tap(find.byKey(const ValueKey('open-menu')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('drawer-nav-/teacher')));
    await tester.pumpAndSettle();
    expect(find.byType(TeacherPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Кнопка повторения восстанавливает экран после ошибки JSON', (
    tester,
  ) async {
    final files = fixtureFiles();
    final original = files['assets/data/project.json']!;
    files['assets/data/project.json'] = '{';
    await showSite(tester, files: files);
    expect(find.byType(ContentError), findsOneWidget);
    files['assets/data/project.json'] = original;
    await tester.tap(find.text('Повторить'));
    await tester.pumpAndSettle();
    expect(find.byType(HomePage), findsOneWidget);
    expect(find.byType(ContentError), findsNothing);
  });

  testWidgets('Повторение загрузки групп восстанавливает вложенный раздел', (
    tester,
  ) async {
    final files = fixtureFiles();
    final original = files['assets/data/groups.json']!;
    files['assets/data/groups.json'] = '{';
    await showSite(tester, files: files, route: '/groups');
    expect(find.byType(ContentError), findsOneWidget);
    files['assets/data/groups.json'] = original;
    await tester.tap(find.text('Повторить'));
    await tester.pumpAndSettle();
    expect(find.byType(GroupCard), findsNWidgets(3));
    expect(find.byType(ContentError), findsNothing);
  });

  testWidgets('Пустой массив групп поддерживается', (tester) async {
    final files = fixtureFiles()..['assets/data/groups.json'] = '[]';
    await showSite(tester, files: files, route: '/groups');
    expect(
      find.text('Исследовательские группы пока не добавлены.'),
      findsOneWidget,
    );
    expect(find.byType(GroupCard), findsNothing);
  });

  testWidgets('Группы можно добавлять только через JSON', (tester) async {
    final files = fixtureFiles();
    final groups =
        jsonDecode(files['assets/data/groups.json']!) as List<Object?>;
    final extra =
        Map<String, Object?>.from(groups.first! as Map<String, Object?>)
          ..['id'] = 'group-4'
          ..['title'] = 'Тестовая группа 4';
    files['assets/data/groups.json'] = jsonEncode([...groups, extra]);
    await showSite(tester, files: files, route: '/groups/group-4');
    expect(find.text('Тестовая группа 4'), findsOneWidget);
    expect(find.text('Группа не найдена'), findsNothing);
  });

  testWidgets('Меню можно использовать с клавиатуры', (tester) async {
    await showSite(tester);
    // Иконка главной, Главная, О проекте, Работы групп.
    for (var i = 0; i < 4; i++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
    }
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(find.byType(GroupsPage), findsOneWidget);
  });

  for (final width in [320.0, 768.0, 1440.0]) {
    for (final route in [
      '/',
      '/project',
      '/groups',
      '/groups/group-1',
      '/conclusions',
      '/teacher',
    ]) {
      testWidgets('Нет ошибок компоновки: $route, ширина $width', (
        tester,
      ) async {
        await showSite(tester, route: route, size: Size(width, 900));
        expect(find.byType(ContentError), findsNothing);
        expect(tester.takeException(), isNull);
      });
    }
  }

  testWidgets('Длинные заголовки и масштаб текста 200% не переполняют экран', (
    tester,
  ) async {
    final files = fixtureFiles();
    final project =
        jsonDecode(files['assets/data/project.json']!) as Map<String, Object?>;
    project['title'] = List.filled(
      8,
      'Длинное демонстрационное название проекта',
    ).join(' ');
    files['assets/data/project.json'] = jsonEncode(project);
    await showSite(
      tester,
      files: files,
      size: const Size(320, 900),
      textScale: 2,
    );
    expect(tester.takeException(), isNull);
    await tester.ensureVisible(find.text('Общие выводы'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
