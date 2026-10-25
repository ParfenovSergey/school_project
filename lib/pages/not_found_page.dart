import 'package:flutter/material.dart';

import '../widgets/content_widgets.dart';
import '../widgets/navigation_menu.dart';

/// Ошибка маршрута или неизвестный идентификатор группы без белого экрана.
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({this.isGroup = false, super.key});

  final bool isGroup;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      PageHeader(
        title: isGroup ? 'Группа не найдена' : 'Страница не найдена',
        description: isGroup
            ? 'Проверьте ссылку или выберите исследовательскую группу из общего списка.'
            : 'Проверьте адрес или откройте один из разделов сайта.',
      ),
      FilledButton.icon(
        onPressed: () => openSection(context, isGroup ? '/groups' : '/'),
        icon: const Icon(Icons.arrow_back),
        label: Text(isGroup ? 'К списку групп' : 'На главную'),
      ),
    ],
  );
}
