import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'pages/conclusions_page.dart';
import 'pages/group_details_page.dart';
import 'pages/groups_page.dart';
import 'pages/home_page.dart';
import 'pages/not_found_page.dart';
import 'pages/project_page.dart';
import 'pages/teacher_page.dart';
import 'services/content_service.dart';
import 'widgets/site_layout.dart';
import 'widgets/story_theme.dart';

void main() => runApp(const SchoolProjectApp());

/// Приложение без стороннего роутера и контейнеров состояния.
/// Hash-стратегия Flutter Web включена по умолчанию.
class SchoolProjectApp extends StatefulWidget {
  const SchoolProjectApp({this.contentService, this.initialRoute, super.key});

  final ContentService? contentService;
  final String? initialRoute;

  @override
  State<SchoolProjectApp> createState() => _SchoolProjectAppState();
}

class _SchoolProjectAppState extends State<SchoolProjectApp> {
  late final ContentService _service;

  @override
  void initState() {
    super.initState();
    _service = widget.contentService ?? ContentService();
  }

  Route<void> _route(RouteSettings settings) {
    final requested = settings.name ?? '/';
    final uri = Uri.tryParse(requested);
    var path = uri?.path ?? requested;
    if (path.isEmpty) path = '/';
    if (path.length > 1 && path.endsWith('/')) {
      path = path.substring(0, path.length - 1);
    }
    final groupMatch = RegExp(r'^/groups/([a-z0-9]+(?:-[a-z0-9]+)*)$')
        .firstMatch(path);
    // Разделы информационного сайта переключаются без анимации масштабирования.
    return PageRouteBuilder<void>(
      settings: settings,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      pageBuilder: (context, animation, secondaryAnimation) => SiteLayout(
        service: _service,
        currentPath: path,
        pageBuilder: (project) {
          switch (path) {
            case '/':
              return HomePage(project: project, service: _service);
            case '/project':
              return ProjectPage(project: project);
            case '/groups':
              return GroupsPage(project: project, service: _service);
            case '/conclusions':
              return ConclusionsPage(project: project, service: _service);
            case '/teacher':
              return TeacherPage(service: _service);
            default:
              if (groupMatch != null) {
                return GroupDetailsPage(
                  groupId: groupMatch.group(1)!,
                  service: _service,
                );
              }
              return NotFoundPage(isGroup: path.startsWith('/groups/'));
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Учебный проект',
    locale: const Locale('ru'),
    supportedLocales: const [Locale('ru')],
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    theme: buildStoryTheme(),
    initialRoute: widget.initialRoute,
    // Прямая ссылка создаёт только нужный экран, без промежуточных страниц.
    onGenerateInitialRoutes: (name) => [_route(RouteSettings(name: name))],
    onGenerateRoute: _route,
  );
}
