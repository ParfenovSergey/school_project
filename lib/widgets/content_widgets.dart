import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/site_content.dart';
import '../services/content_service.dart';
import 'story_theme.dart';

/// Заголовок страницы с неограниченным переносом длинных названий.
class PageHeader extends StatelessWidget {
  const PageHeader({
    required this.title,
    this.description,
    this.eyebrow,
    super.key,
  });

  final String title;
  final String? description;
  final String? eyebrow;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 36),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (eyebrow != null) ...[
          Text(eyebrow!, style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 12),
        ],
        Semantics(
          header: true,
          child: Text(
            title,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontSize: MediaQuery.sizeOf(context).width < 600 ? 50 : 64,
            ),
          ),
        ),
        if (description != null) ...[
          const SizedBox(height: 16),
          BodyCopy(description!),
        ],
      ],
    ),
  );
}

/// Раздел страницы с одинаковыми интервалами и семантическим заголовком.
class ContentSectionView extends StatelessWidget {
  const ContentSectionView({
    required this.title,
    required this.child,
    super.key,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 36),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text(title, style: Theme.of(context).textTheme.headlineSmall),
        ),
        const SizedBox(height: 16),
        child,
      ],
    ),
  );
}

/// Основной текст без ограничения количества строк и высоты.
class BodyCopy extends StatelessWidget {
  const BodyCopy(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) =>
      Text(text, style: Theme.of(context).textTheme.bodyLarge);
}

/// Выделенный вопрос, итоговый ответ или короткая справка.
class ContentPanel extends StatelessWidget {
  const ContentPanel({
    required this.title,
    required this.text,
    this.icon = Icons.lightbulb_outline,
    this.highlighted = false,
    super.key,
  });

  final String title;
  final String text;
  final IconData icon;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: highlighted
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: highlighted ? StoryColors.paper : const Color(0xFFFFEDC4),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 27, color: theme.colorScheme.primary),
          ),
          const SizedBox(height: 16),
          Semantics(
            header: true,
            child: Text(title, style: theme.textTheme.titleLarge),
          ),
          const SizedBox(height: 12),
          BodyCopy(text),
        ],
      ),
    );
  }
}

/// Колонки с естественной высотой: длинный текст не обрезается.
class ResponsiveCards extends StatelessWidget {
  const ResponsiveCards({
    required this.children,
    this.maxColumns = 3,
    super.key,
  });

  final List<Widget> children;
  final int maxColumns;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final scaledText = MediaQuery.textScalerOf(context).scale(16);
      final desired = constraints.maxWidth >= 1000
          ? 3
          : constraints.maxWidth >= 560
          ? 2
          : 1;
      final columns = scaledText > 24 ? 1 : desired.clamp(1, maxColumns);
      final width = (constraints.maxWidth - 20 * (columns - 1)) / columns;
      return Wrap(
        spacing: 20,
        runSpacing: 20,
        children: [
          for (final child in children) SizedBox(width: width, child: child),
        ],
      );
    },
  );
}

/// Последовательность этапов, критериев или задач из JSON.
class SectionList extends StatelessWidget {
  const SectionList({required this.sections, this.numbered = false, super.key});

  final List<ContentSection> sections;
  final bool numbered;

  @override
  Widget build(BuildContext context) {
    if (sections.isEmpty) return const EmptyNotice('Пункты пока не добавлены.');
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < sections.length; i++)
          Padding(
            padding: EdgeInsets.only(bottom: i == sections.length - 1 ? 0 : 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (numbered) ...[
                  Container(
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE4A6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('${i + 1}', style: theme.textTheme.labelLarge),
                  ),
                  const SizedBox(width: 16),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sections[i].title,
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      BodyCopy(sections[i].description),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Список ссылок без кнопок для отсутствующих или неверных URL.
class ProductsList extends StatelessWidget {
  const ProductsList({required this.products, super.key});

  final List<InformationProduct> products;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const EmptyNotice('Материалы пока не добавлены.');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final product in products)
          Card.outlined(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  BodyCopy(product.description),
                  const SizedBox(height: 16),
                  if (product.url case final url?)
                    Semantics(
                      link: true,
                      label: '${product.title}. Открыть в новой вкладке.',
                      child: OutlinedButton.icon(
                        onPressed: () => _openUrl(context, url),
                        icon: const Icon(Icons.open_in_new, size: 18),
                        label: const Text('Открыть материал'),
                      ),
                    )
                  else
                    Text(
                      'Ссылка пока не добавлена',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _openUrl(BuildContext context, Uri url) async {
    var opened = false;
    try {
      // Вызов происходит сразу по нажатию, чтобы не блокировать новую вкладку.
      opened = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
        webOnlyWindowName: '_blank',
      );
    } on Exception {
      opened = false;
    }
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Не удалось открыть ссылку. Проверьте адрес и настройки браузера.',
          ),
        ),
      );
    }
  }
}

/// Нейтральное состояние для пустых списков.
class EmptyNotice extends StatelessWidget {
  const EmptyNotice(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: BodyCopy(message),
  );
}

/// Загрузку запускаем один раз на экран, а повторение — только по кнопке.
class AsyncContent<T> extends StatefulWidget {
  const AsyncContent({
    required this.load,
    required this.onRetry,
    required this.builder,
    super.key,
  });

  final Future<T> Function() load;
  final VoidCallback onRetry;
  final Widget Function(T value) builder;

  @override
  State<AsyncContent<T>> createState() => _AsyncContentState<T>();
}

class _AsyncContentState<T> extends State<AsyncContent<T>> {
  late Future<T> _future;

  @override
  void initState() {
    super.initState();
    _future = widget.load();
  }

  void _retry() {
    widget.onRetry();
    setState(() {
      _future = widget.load();
    });
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<T>(
    future: _future,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return ContentError(error: snapshot.error, onRetry: _retry);
      }
      if (snapshot.connectionState != ConnectionState.done) {
        return const ContentLoading();
      }
      return widget.builder(snapshot.data as T);
    },
  );
}

/// Сообщение об ошибке остаётся внутри общего макета сайта.
class ContentError extends StatelessWidget {
  const ContentError({required this.error, required this.onRetry, super.key});

  final Object? error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Semantics(
    liveRegion: true,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.error_outline, size: 36),
        const SizedBox(height: 16),
        Text(
          'Не удалось загрузить содержимое',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        BodyCopy(
          error is ContentException
              ? error.toString()
              : 'Проверьте файлы содержимого и повторите попытку.',
        ),
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
          label: const Text('Повторить'),
        ),
      ],
    ),
  );
}

/// Прогресс без пустого экрана и без неопределённой высоты.
class ContentLoading extends StatelessWidget {
  const ContentLoading({super.key});

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(vertical: 48),
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Загрузка содержимого…'),
        ],
      ),
    ),
  );
}
