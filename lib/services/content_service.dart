import 'dart:convert';

import 'package:flutter/foundation.dart' show FlutterError;
import 'package:flutter/services.dart';

import '../models/site_content.dart';

/// Понятная пользователю ошибка загрузки или структуры содержимого.
class ContentException implements Exception {
  const ContentException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Читает четыре локальных файла и кэширует Future до явного повторения.
/// AssetBundle можно подменить в тестах, не обращаясь к сети.
class ContentService {
  ContentService({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;
  Future<ProjectContent>? _project;
  Future<List<ResearchGroup>>? _groups;
  Future<ConclusionsContent>? _conclusions;
  Future<TeacherContent>? _teacher;

  Future<ProjectContent> getProject() =>
      _project ??= _read('assets/data/project.json', ProjectContent.fromJson);

  Future<List<ResearchGroup>> getGroups() =>
      _groups ??= _read('assets/data/groups.json', ResearchGroup.listFromJson);

  Future<ResearchGroup?> getGroup(String id) async {
    for (final group in await getGroups()) {
      if (group.id == id) return group;
    }
    return null;
  }

  Future<ConclusionsContent> getConclusions() => _conclusions ??= _read(
    'assets/data/conclusions.json',
    ConclusionsContent.fromJson,
  );

  Future<TeacherContent> getTeacher() =>
      _teacher ??= _read('assets/data/teacher.json', TeacherContent.fromJson);

  /// Позволяет заново загрузить данные после нажатия «Повторить».
  void clearCache() {
    _project = null;
    _groups = null;
    _conclusions = null;
    _teacher = null;
  }

  Future<T> _read<T>(String asset, T Function(Object? value) parse) async {
    try {
      final source = await _bundle.loadString(asset, cache: false);
      return parse(jsonDecode(source));
    } on FormatException catch (error) {
      throw ContentException('Ошибка в $asset. ${error.message}');
    } on FlutterError {
      throw ContentException(
        'Файл $asset недоступен. Проверьте его наличие и раздел assets в pubspec.yaml.',
      );
    } on Exception {
      throw ContentException('Не удалось загрузить $asset. Повторите попытку.');
    }
  }
}
