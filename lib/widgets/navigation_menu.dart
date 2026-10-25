import 'package:flutter/material.dart';

import 'story_theme.dart';

/// Единый набор разделов для шапки, мобильного меню и подвала.
const siteDestinations = <SiteDestination>[
  SiteDestination('/', 'Главная', Icons.home_outlined),
  SiteDestination('/project', 'О проекте', Icons.info_outline),
  SiteDestination('/groups', 'Работы групп', Icons.groups_outlined),
  SiteDestination('/conclusions', 'Итоги проекта', Icons.fact_check_outlined),
  SiteDestination('/teacher', 'Учителю', Icons.school_outlined),
];

/// Описание пункта меню, не связанное с содержимым исследования.
class SiteDestination {
  const SiteDestination(this.path, this.label, this.icon);

  final String path;
  final String label;
  final IconData icon;

  bool isActive(String currentPath) =>
      currentPath == path ||
      (path == '/groups' && currentPath.startsWith('/groups/'));
}

/// Именованные переходы сохраняют hash-маршруты Flutter Web.
void openSection(BuildContext context, String path) {
  if (ModalRoute.of(context)?.settings.name != path) {
    Navigator.of(context).pushNamed(path);
  }
}

/// Навигация с поддержкой клавиатуры и выделением текущего раздела.
class NavigationMenu extends StatelessWidget {
  const NavigationMenu({
    required this.currentPath,
    required this.onNavigate,
    required this.keyPrefix,
    this.vertical = false,
    this.inverse = false,
    super.key,
  });

  final String currentPath;
  final ValueChanged<String> onNavigate;
  final String keyPrefix;
  final bool vertical;
  final bool inverse;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final items = [
      for (final destination in siteDestinations)
        Semantics(
          selected: destination.isActive(currentPath),
          link: true,
          child: vertical
              ? ListTile(
                  key: ValueKey('$keyPrefix${destination.path}'),
                  leading: Icon(destination.icon),
                  title: Text(destination.label),
                  selected: destination.isActive(currentPath),
                  selectedTileColor: colors.primaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onTap: () => onNavigate(destination.path),
                )
              : TextButton(
                  key: ValueKey('$keyPrefix${destination.path}'),
                  style: TextButton.styleFrom(
                    foregroundColor: destination.isActive(currentPath)
                        ? inverse
                              ? StoryColors.warmInk
                              : colors.primary
                        : inverse
                        ? Colors.white
                        : colors.onSurfaceVariant,
                    backgroundColor: destination.isActive(currentPath)
                        ? inverse
                              ? StoryColors.gold
                              : colors.primaryContainer
                        : Colors.transparent,
                    minimumSize: const Size(48, 48),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                  onPressed: () => onNavigate(destination.path),
                  child: Text(destination.label),
                ),
        ),
    ];
    return vertical
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: items,
          )
        : Wrap(spacing: 4, runSpacing: 4, children: items);
  }
}
