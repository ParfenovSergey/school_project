/// Именованный текстовый блок; порядок блоков определяется порядком в JSON.
class ContentSection {
  const ContentSection({required this.title, required this.description});

  factory ContentSection.fromJson(Object? value, {String path = r'$'}) {
    final json = _Json(value, path);
    return ContentSection(
      title: json.text('title'),
      description: json.text('description'),
    );
  }

  final String title;
  final String description;
}

/// Демонстрационные или реальные сведения о классе.
class ClassInfo {
  const ClassInfo({
    required this.title,
    required this.school,
    required this.description,
  });

  factory ClassInfo.fromJson(Object? value, {String path = r'$'}) {
    final json = _Json(value, path);
    return ClassInfo(
      title: json.text('title'),
      school: json.text('school'),
      description: json.text('description'),
    );
  }

  final String title;
  final String school;
  final String description;
}

/// Тексты первого экрана; название и вопрос берутся из ProjectContent.
class HeroContent {
  const HeroContent({
    required this.eyebrow,
    required this.description,
    this.imageAsset,
  });

  factory HeroContent.fromJson(Object? value, {String path = r'$'}) {
    final json = _Json(value, path);
    return HeroContent(
      eyebrow: json.text('eyebrow'),
      description: json.text('description'),
      imageAsset: json.optionalText('imageAsset'),
    );
  }

  final String eyebrow;
  final String description;
  final String? imageAsset;
}

/// Общие сведения о проекте из project.json.
class ProjectContent {
  const ProjectContent({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.fundamentalQuestion,
    required this.annotation,
    required this.relevance,
    required this.goal,
    required this.tasks,
    required this.academicYear,
    required this.classInfo,
    required this.workOrganization,
    required this.stages,
    required this.expectedResults,
    required this.hero,
    required this.footerNote,
  });

  factory ProjectContent.fromJson(Object? value, {String path = r'$'}) {
    final json = _Json(value, path);
    return ProjectContent(
      id: json.slug('id'),
      title: json.text('title'),
      subtitle: json.text('subtitle'),
      fundamentalQuestion: json.text('fundamentalQuestion'),
      annotation: json.text('annotation'),
      relevance: json.text('relevance'),
      goal: json.text('goal'),
      tasks: json.sections('tasks'),
      academicYear: json.text('academicYear'),
      classInfo: ClassInfo.fromJson(
        json.field('classInfo'),
        path: json.at('classInfo'),
      ),
      workOrganization: json.text('workOrganization'),
      stages: json.sections('stages'),
      expectedResults: json.sections('expectedResults'),
      hero: HeroContent.fromJson(json.field('hero'), path: json.at('hero')),
      footerNote: json.text('footerNote'),
    );
  }

  final String id;
  final String title;
  final String subtitle;
  final String fundamentalQuestion;
  final String annotation;
  final String relevance;
  final String goal;
  final List<ContentSection> tasks;
  final String academicYear;
  final ClassInfo classInfo;
  final String workOrganization;
  final List<ContentSection> stages;
  final List<ContentSection> expectedResults;
  final HeroContent hero;
  final String footerNote;
}

/// Информационный продукт, источник или методический материал.
/// Отсутствующий или некорректный HTTP(S) URL не превращается в кнопку.
class InformationProduct {
  const InformationProduct({
    required this.title,
    required this.description,
    this.url,
  });

  factory InformationProduct.fromJson(Object? value, {String path = r'$'}) {
    final json = _Json(value, path);
    final rawUrl = json.optionalText('url');
    final parsed = rawUrl == null ? null : Uri.tryParse(rawUrl);
    final isValid =
        parsed != null &&
        (parsed.scheme == 'https' || parsed.scheme == 'http') &&
        parsed.host.isNotEmpty &&
        parsed.userInfo.isEmpty &&
        !rawUrl!.contains(RegExp(r'\s'));
    return InformationProduct(
      title: json.text('title'),
      description: json.text('description'),
      url: isValid ? parsed : null,
    );
  }

  final String title;
  final String description;
  final Uri? url;
}

/// Одна группа; все группы используют общий экран подробностей.
class ResearchGroup {
  const ResearchGroup({
    required this.id,
    required this.title,
    required this.question,
    required this.summary,
    required this.relevance,
    required this.goal,
    required this.hypothesis,
    required this.methods,
    required this.stages,
    required this.results,
    required this.conclusion,
    required this.products,
    this.imageAsset,
  });

  factory ResearchGroup.fromJson(Object? value, {String path = r'$'}) {
    final json = _Json(value, path);
    return ResearchGroup(
      id: json.slug('id'),
      title: json.text('title'),
      question: json.text('question'),
      summary: json.text('summary'),
      relevance: json.text('relevance'),
      goal: json.text('goal'),
      hypothesis: json.text('hypothesis'),
      methods: json.sections('methods'),
      stages: json.sections('stages'),
      results: json.text('results'),
      conclusion: json.text('conclusion'),
      products: json.products('products'),
      imageAsset: json.optionalText('imageAsset'),
    );
  }

  /// Проверяет массив целиком, включая уникальность адресуемых идентификаторов.
  static List<ResearchGroup> listFromJson(Object? value) {
    if (value is! List<Object?>) {
      throw const FormatException(r'$: ожидается массив групп.');
    }
    final groups = <ResearchGroup>[];
    final ids = <String>{};
    for (var index = 0; index < value.length; index++) {
      final path = '\$[$index]';
      final group = ResearchGroup.fromJson(value[index], path: path);
      if (!ids.add(group.id)) {
        throw FormatException(
          '$path.id: идентификатор ${group.id} повторяется.',
        );
      }
      groups.add(group);
    }
    return List.unmodifiable(groups);
  }

  final String id;
  final String title;
  final String question;
  final String summary;
  final String relevance;
  final String goal;
  final String hypothesis;
  final List<ContentSection> methods;
  final List<ContentSection> stages;
  final String results;
  final String conclusion;
  final List<InformationProduct> products;
  final String? imageAsset;
}

/// Итоги класса; основополагающий вопрос здесь не дублируется.
class ConclusionsContent {
  const ConclusionsContent({
    required this.summary,
    required this.mainFindings,
    required this.answer,
    required this.practicalSignificance,
    required this.futureWork,
  });

  factory ConclusionsContent.fromJson(Object? value, {String path = r'$'}) {
    final json = _Json(value, path);
    return ConclusionsContent(
      summary: json.text('summary'),
      mainFindings: json.sections('mainFindings'),
      answer: json.text('answer'),
      practicalSignificance: json.text('practicalSignificance'),
      futureWork: json.sections('futureWork'),
    );
  }

  final String summary;
  final List<ContentSection> mainFindings;
  final String answer;
  final String practicalSignificance;
  final List<ContentSection> futureWork;
}

/// Самостоятельный методический раздел из teacher.json.
class TeacherContent {
  const TeacherContent({
    required this.description,
    required this.overview,
    required this.targetAudience,
    required this.subjects,
    required this.educationalGoals,
    required this.learningOutcomes,
    required this.preparation,
    required this.methodicalRecommendations,
    required this.groupWork,
    required this.stages,
    required this.assessmentCriteria,
    required this.reflection,
    required this.sources,
    required this.additionalMaterials,
  });

  factory TeacherContent.fromJson(Object? value, {String path = r'$'}) {
    final json = _Json(value, path);
    return TeacherContent(
      description: json.text('description'),
      overview: json.text('overview'),
      targetAudience: json.text('targetAudience'),
      subjects: json.sections('subjects'),
      educationalGoals: json.sections('educationalGoals'),
      learningOutcomes: json.sections('learningOutcomes'),
      preparation: json.sections('preparation'),
      methodicalRecommendations: json.text('methodicalRecommendations'),
      groupWork: json.text('groupWork'),
      stages: json.sections('stages'),
      assessmentCriteria: json.sections('assessmentCriteria'),
      reflection: json.text('reflection'),
      sources: json.products('sources'),
      additionalMaterials: json.products('additionalMaterials'),
    );
  }

  final String description;
  final String overview;
  final String targetAudience;
  final List<ContentSection> subjects;
  final List<ContentSection> educationalGoals;
  final List<ContentSection> learningOutcomes;
  final List<ContentSection> preparation;
  final String methodicalRecommendations;
  final String groupWork;
  final List<ContentSection> stages;
  final List<ContentSection> assessmentCriteria;
  final String reflection;
  final List<InformationProduct> sources;
  final List<InformationProduct> additionalMaterials;
}

// Все проверки типов и обращения к нетипизированному JSON сосредоточены здесь.
class _Json {
  _Json(Object? value, this.path) {
    if (value is! Map<String, Object?>) {
      throw FormatException('$path: ожидается JSON-объект.');
    }
    _value = value;
  }

  final String path;
  late final Map<String, Object?> _value;

  String at(String key) => '$path.$key';

  Object? field(String key) {
    if (!_value.containsKey(key)) {
      throw FormatException('${at(key)}: отсутствует обязательное поле.');
    }
    return _value[key];
  }

  String text(String key) {
    final value = field(key);
    if (value is! String || value.trim().isEmpty) {
      throw FormatException('${at(key)}: ожидается непустая строка.');
    }
    return value.trim();
  }

  String slug(String key) {
    final value = text(key);
    if (!RegExp(r'^[a-z0-9]+(?:-[a-z0-9]+)*$').hasMatch(value)) {
      throw FormatException(
        '${at(key)}: используйте латиницу a–z, цифры и дефис.',
      );
    }
    return value;
  }

  String? optionalText(String key) {
    final value = _value[key];
    if (value == null) return null;
    if (value is! String) {
      throw FormatException('${at(key)}: ожидается строка или null.');
    }
    return value.trim().isEmpty ? null : value.trim();
  }

  List<T> items<T>(
    String key,
    T Function(Object? value, String path) parse, {
    bool optional = false,
  }) {
    if (optional && (!_value.containsKey(key) || _value[key] == null)) {
      return List<T>.unmodifiable(<T>[]);
    }
    final value = field(key);
    if (value is! List<Object?>) {
      throw FormatException('${at(key)}: ожидается массив.');
    }
    return List<T>.unmodifiable([
      for (var i = 0; i < value.length; i++) parse(value[i], '${at(key)}[$i]'),
    ]);
  }

  List<ContentSection> sections(String key) =>
      items(key, (value, path) => ContentSection.fromJson(value, path: path));

  List<InformationProduct> products(String key) => items(
    key,
    (value, path) => InformationProduct.fromJson(value, path: path),
    optional: true,
  );
}
