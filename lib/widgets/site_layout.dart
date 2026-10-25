import 'package:flutter/material.dart';

import '../models/site_content.dart';
import '../services/content_service.dart';
import 'content_widgets.dart';
import 'illustrated_decor.dart';
import 'navigation_menu.dart';
import 'story_theme.dart';

/// Общий иллюстрированный макет сохраняет навигацию и обработку ошибок JSON.
class SiteLayout extends StatefulWidget {
  const SiteLayout({
    required this.service,
    required this.currentPath,
    required this.pageBuilder,
    super.key,
  });

  final ContentService service;
  final String currentPath;
  final Widget Function(ProjectContent project) pageBuilder;

  @override
  State<SiteLayout> createState() => _SiteLayoutState();
}

class _SiteLayoutState extends State<SiteLayout> {
  final _scrollController = ScrollController();
  late Future<ProjectContent> _project;

  @override
  void initState() {
    super.initState();
    _project = widget.service.getProject();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _retry() {
    widget.service.clearCache();
    setState(() {
      _project = widget.service.getProject();
    });
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<ProjectContent>(
    future: _project,
    builder: (context, snapshot) {
      final project = snapshot.data;
      final title = project?.title ?? 'Учебный проект';
      final showHome =
          project != null && !snapshot.hasError && widget.currentPath == '/';
      return Title(
        title: title,
        color: StoryColors.ocean,
        child: Scaffold(
          endDrawer: Drawer(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        tooltip: 'Закрыть меню',
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 12,
                      ),
                      child: Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    NavigationMenu(
                      currentPath: widget.currentPath,
                      keyPrefix: 'drawer-nav-',
                      vertical: true,
                      onNavigate: (path) {
                        Navigator.of(context).pop();
                        openSection(context, path);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: Column(
              children: [
                _SiteHeader(title: title, currentPath: widget.currentPath),
                Expanded(
                  child: Scrollbar(
                    controller: _scrollController,
                    child: SingleChildScrollView(
                      key: const ValueKey('site-scroll'),
                      controller: _scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (showHome)
                            widget.pageBuilder(project)
                          else ...[
                            const SkyRibbon(),
                            ContentWidth(
                              padding: const EdgeInsets.fromLTRB(
                                24,
                                24,
                                24,
                                48,
                              ),
                              child: snapshot.hasError
                                  ? ContentError(
                                      error: snapshot.error,
                                      onRetry: _retry,
                                    )
                                  : project == null
                                  ? const ContentLoading()
                                  : widget.pageBuilder(project),
                            ),
                          ],
                          if (project != null)
                            _SiteFooter(
                              project: project,
                              currentPath: widget.currentPath,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

class _SiteHeader extends StatelessWidget {
  const _SiteHeader({required this.title, required this.currentPath});

  final String title;
  final String currentPath;

  @override
  Widget build(BuildContext context) => Material(
    color: StoryColors.deepOcean,
    child: ContentWidth(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide =
              constraints.maxWidth >= 1020 &&
              MediaQuery.textScalerOf(context).scale(14) <= 18;
          return Row(
            children: [
              Semantics(
                link: true,
                child: IconButton.filledTonal(
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.12),
                    foregroundColor: const Color(0xFFFFD273),
                  ),
                  tooltip: 'На главную',
                  onPressed: () => openSection(context, '/'),
                  icon: const Icon(Icons.auto_stories_outlined, size: 27),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Tooltip(
                  message: title,
                  child: Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              if (wide)
                NavigationMenu(
                  currentPath: currentPath,
                  keyPrefix: 'header-nav-',
                  inverse: true,
                  onNavigate: (path) => openSection(context, path),
                )
              else
                Builder(
                  builder: (context) => IconButton(
                    key: const ValueKey('open-menu'),
                    tooltip: 'Открыть меню',
                    color: Colors.white,
                    onPressed: () => Scaffold.of(context).openEndDrawer(),
                    icon: const Icon(Icons.menu),
                  ),
                ),
            ],
          );
        },
      ),
    ),
  );
}

class _SiteFooter extends StatelessWidget {
  const _SiteFooter({required this.project, required this.currentPath});

  final ProjectContent project;
  final String currentPath;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final identity = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(project.title, style: theme.textTheme.titleLarge),
        const SizedBox(height: 10),
        Text(project.academicYear, style: theme.textTheme.bodyMedium),
        const SizedBox(height: 12),
        Text(project.footerNote, style: theme.textTheme.bodySmall),
      ],
    );
    final navigation = NavigationMenu(
      currentPath: currentPath,
      keyPrefix: 'footer-nav-',
      onNavigate: (path) => openSection(context, path),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const BotanicalTrim(),
        ColoredBox(
          color: const Color(0xFFEAF4E0),
          child: ContentWidth(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
            child: LayoutBuilder(
              builder: (context, constraints) =>
                  constraints.maxWidth >= 900 &&
                      MediaQuery.textScalerOf(context).scale(14) <= 18
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: identity),
                        const SizedBox(width: 48),
                        Expanded(flex: 2, child: navigation),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        identity,
                        const SizedBox(height: 24),
                        navigation,
                      ],
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
