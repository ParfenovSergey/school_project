import 'package:flutter/material.dart';

import '../models/site_content.dart';
import '../services/content_service.dart';
import '../widgets/content_widgets.dart';
import '../widgets/group_card.dart';

/// Адаптивный список из любого количества записей groups.json.
class GroupsPage extends StatelessWidget {
  const GroupsPage({required this.project, required this.service, super.key});

  final ProjectContent project;
  final ContentService service;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      PageHeader(title: 'Работы групп', description: project.workOrganization),
      AsyncContent<List<ResearchGroup>>(
        load: service.getGroups,
        onRetry: service.clearCache,
        builder: (groups) => groups.isEmpty
            ? const EmptyNotice('Исследовательские группы пока не добавлены.')
            : ResponsiveCards(
                children: [for (final group in groups) GroupCard(group: group)],
              ),
      ),
    ],
  );
}
