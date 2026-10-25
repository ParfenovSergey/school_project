# Школьный исследовательский проект · Flutter Web

Версия **0.2.0** — иллюстрированное оформление по предоставленному референсу: бирюзовое небо, облачные переходы, тёплые акценты, главный персонаж, рисунки на карточках и растительный орнамент в подвале.

Готовый информационный сайт для представления школьного исследования, работ всех групп, общих выводов класса и методических материалов для учителя. Данные хранятся в четырёх локальных JSON-файлах и включаются в статическую сборку.

Пять основных страниц: **Главная**, **О проекте**, **Работы групп**, **Итоги проекта**, **Учителю**. Для всех групп используется одна универсальная страница подробностей. Отдельного раздела «Наша группа» нет, все группы равноправны.

Демонстрационные названия обозначены явно. Каждый самостоятельный описательный блок содержит два предложения Lorem ipsum. Реальные сведения о школе, детях, педагогах и достижениях не добавлены. Ссылки на `https://example.com/` — примеры, которые нужно заменить перед публикацией настоящих материалов.

## Быстрый запуск

После установки Flutter распакуйте архив и откройте папку, в которой находится `pubspec.yaml`:

```powershell
cd .\school_project
flutter pub get
flutter run -d edge
```

В VS Code также доступна конфигурация **Run and Debug → Flutter Web: Edge**. Для Chrome предусмотрена вторая конфигурация.

## Возможности и стек

- Material 3, бирюзовая палитра с золотистыми акцентами, единая шапка и подвал.
- Оригинальная главная иллюстрация и три обложки групп; локальные шрифты Amatic SC и Nunito с кириллицей.
- Облака и листья рисуются средствами Flutter и сохраняют чёткость при масштабировании.
- Сетка групп из трёх, двух или одной колонки в зависимости от доступной ширины. При крупном масштабе текста используется одна колонка.
- Перенос текста карточек без фиксированной высоты.
- Горизонтальная навигация на широком экране и выдвижное меню на небольшом.
- Прямые hash-ссылки, обновление страницы с сохранением маршрута, обработка неизвестных групп и адресов.
- Типизированные модели, проверка обязательных полей, типов и уникальности идентификаторов.
- Сообщения об ошибках и кнопка повторения; поддержка пустых списков и отсутствующих URL.
- Клавиатурная навигация, подписи элементов управления и семантические заголовки.
- Проверки и автоматическая публикация через GitHub Pages.

Проверенное окружение: **Flutter 3.47.8 Stable**, **Dart 3.13.7**. Зависимости приложения: Flutter SDK, `flutter_localizations` из SDK и `url_launcher`. Для разработки используются `flutter_test` и `flutter_lints`. База данных, серверный API, авторизация и административная панель отсутствуют. Для обновления содержимого редактируются JSON и выполняется новая сборка.

Flutter Web — клиентское приложение с ограничениями для поисковой индексации. Не следует ожидать SEO, аналогичного статическому HTML-сайту. Hash-страницы не создают отдельные HTML-документы с индивидуальными метаданными. В `web/index.html` и `web/manifest.json` оставлены общие технические подписи. Название приложения после загрузки берётся из JSON.

## Установка Flutter на Windows 10

1. Подготовьте Windows 10 x64, [Git for Windows](https://git-scm.com/downloads/win), [VS Code](https://code.visualstudio.com/) и Microsoft Edge либо Google Chrome.
2. Откройте [официальную инструкцию](https://docs.flutter.dev/install/manual) и [архив Flutter SDK](https://docs.flutter.dev/install/archive). Скачайте Windows x64 **Stable**. Комплект проверен с Flutter **3.47.8**, включающим Dart **3.13.7**. Отдельная установка Dart не требуется.
3. Распакуйте SDK, например в `C:\src\flutter`. Используйте доступный для записи путь без пробелов, вне `Program Files`.
4. В Windows откройте **Изменение переменных среды текущего пользователя → Path → Изменить → Создать**. Добавьте `C:\src\flutter\bin`.
5. Перезапустите PowerShell и VS Code. Установите расширение **Flutter** от Dart Code; оно также подключит поддержку Dart.
6. Проверьте окружение:

```powershell
git --version
flutter --version
flutter doctor
flutter devices
```

В устройствах должен быть Edge или Chrome. Для веб-проекта Android SDK и средства сборки Windows desktop не требуются; соответствующие замечания `flutter doctor` не блокируют запуск в браузере. Если веб-поддержка была отключена, выполните `flutter config --enable-web`.

Для перехода с другого канала на текущий Stable:

```powershell
flutter channel stable
flutter upgrade
```

После смены SDK заново выполните проверки. Минимальный Dart SDK в `pubspec.yaml` — `^3.13.7`; версия Flutter в workflow закреплена для воспроизводимости.

## Создание и запуск проекта

Архив уже содержит проект, созданный командой `flutter create`, включая `web/`, `.metadata` и настоящий `pubspec.lock`. Следующая команда нужна только для создания новой основы, а не для запуска полученного комплекта:

```powershell
flutter create --empty --platforms=web --project-name=school_project school_project
```

В готовом комплекте достаточно:

```powershell
flutter pub get
flutter run -d edge
```

Для другого браузера используйте `flutter run -d chrome`. Остановка — `q` в терминале. После изменения JSON выполните hot restart (`R`) или перезапустите приложение: сервис кэширует содержимое.

Храните `pubspec.lock` в Git. Он сформирован командой `flutter pub get`. Проверка зависимостей без изменения lock-файла: `flutter pub get --enforce-lockfile`.

## Структура

```text
school_project/
├── .github/workflows/deploy.yml
├── .vscode/launch.json
├── assets/
│   ├── data/
│   │   ├── project.json
│   │   ├── groups.json
│   │   ├── conclusions.json
│   │   └── teacher.json
│   ├── fonts/
│   │   ├── amaticsc/
│   │   └── nunito/
│   ├── images/project/
│   ├── images/groups/
│   └── documents/
├── lib/
│   ├── main.dart
│   ├── models/site_content.dart
│   ├── services/content_service.dart
│   ├── pages/
│   │   ├── home_page.dart
│   │   ├── project_page.dart
│   │   ├── groups_page.dart
│   │   ├── group_details_page.dart
│   │   ├── conclusions_page.dart
│   │   ├── teacher_page.dart
│   │   └── not_found_page.dart
│   └── widgets/
│       ├── site_layout.dart
│       ├── navigation_menu.dart
│       ├── group_card.dart
│       ├── illustrated_decor.dart
│       ├── story_theme.dart
│       └── content_widgets.dart
├── test/
│   ├── content_service_test.dart
│   ├── widget_test.dart
│   └── fixtures.dart
├── web/
├── .gitignore
├── .metadata
├── analysis_options.yaml
├── pubspec.yaml
├── pubspec.lock
├── README.md
├── ASSETS.md
└── VERIFICATION.md
```

В `assets/images/project/` находится главная иллюстрация, в `assets/images/groups/` — обложки групп. Эти каталоги и `assets/data/` зарегистрированы в `pubspec.yaml`. Шрифты находятся в `assets/fonts/` вместе с лицензиями OFL и подключены локально. Папка `assets/documents/` оставлена для будущего расширения.

## Настройка иллюстрированного оформления

- Палитра, типографика и кнопки: `lib/widgets/story_theme.dart`.
- Облачные разделители, небо, листья и обработка отсутствующих изображений: `lib/widgets/illustrated_decor.dart`.
- Главный рисунок задаётся необязательным полем `hero.imageAsset` в `project.json`.
- Обложка группы задаётся необязательным полем `imageAsset` у объекта группы в `groups.json`.
- Пути указываются относительно проекта, например `assets/images/project/explorer-hero.webp`.

Чтобы заменить рисунок, поместите новый файл в зарегистрированный каталог и обновите соответствующий путь в JSON. После добавления файла выполните hot restart или пересоберите сайт. Если поле отсутствует, равно `null`, содержит пустую строку или файл не найден, интерфейс показывает нейтральное оформление с иконкой. Изображение не является обязательным условием отображения содержимого.

На главной карточки показывают краткое введение в исследования; полные карточки с результатами находятся в разделе «Работы групп». Внутренние страницы используют те же цвета, заголовки и облачные переходы, сохраняя светлый фон для длинных текстов.

Сведения об иллюстрациях, точные промты их создания и источники шрифтов приведены в `ASSETS.md`. Подключение новых Flutter-пакетов для оформления не потребовалось. При открытии сайта шрифты и иллюстрации загружаются из его собственных assets.

## Формат JSON

Сохраняйте файлы в **UTF-8**. Имена полей чувствительны к регистру. Комментарии и запятая после последнего элемента недопустимы. Обязательные строки должны быть непустыми.

| Файл | Содержимое |
| --- | --- |
| `project.json` | `id`, `title`, `subtitle`, `fundamentalQuestion`, `annotation`, `relevance`, `goal`, `tasks`, `academicYear`, `classInfo`, `workOrganization`, `stages`, `expectedResults`, `hero`, `footerNote` |
| `groups.json` | Массив групп: `id`, `title`, `question`, `summary`, `relevance`, `goal`, `hypothesis`, `methods`, `stages`, `results`, `conclusion`, `products` |
| `conclusions.json` | `summary`, `mainFindings`, `answer`, `practicalSignificance`, `futureWork` |
| `teacher.json` | `description`, `overview`, `targetAudience`, `subjects`, `educationalGoals`, `learningOutcomes`, `preparation`, `methodicalRecommendations`, `groupWork`, `stages`, `assessmentCriteria`, `reflection`, `sources`, `additionalMaterials` |

`classInfo` содержит `title`, `school`, `description`. `hero` содержит `eyebrow`, `description` и необязательное `imageAsset`; название и вопрос берутся из общих данных проекта. У группы также может быть необязательное `imageAsset`. Основополагающий вопрос хранится **только в `project.json`**. Поля `mainGroupId` нет.

Задачи, методы, этапы, выводы, предметы и критерии — массивы однотипных блоков:

```json
{
  "title": "Название пункта",
  "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."
}
```

Порядок элементов массива определяет порядок на странице. Добавляйте и удаляйте элементы без изменения Dart-кода. Поля массивов текстовых блоков обязательны, даже если массив пуст; пустые списки показывают нейтральное сообщение.

## Добавление группы

1. Откройте `assets/data/groups.json` и скопируйте один объект массива со всеми полями.
2. Задайте уникальный `id`, например `group-4`. Допускаются строчные латинские буквы, цифры и дефисы между частями; без пробелов, кириллицы и `/`.
3. Измените название, вопрос, описания, методы, этапы, результаты и выводы.
4. Заполните `products` либо оставьте `[]`.
5. Проверьте JSON и выполните тесты. Карточка появится автоматически, подробности будут доступны по `/#/groups/group-4`.

Главная показывает первые три записи как предварительный просмотр. «Работы групп» показывает весь массив. Для удаления группы удалите её объект: старая ссылка покажет «Группа не найдена». Отдельный Dart-файл создавать не нужно.

## Информационные продукты

Добавьте объект в `products` выбранной группы:

```json
{
  "title": "Название информационного продукта",
  "description": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
  "url": "https://example.com/product"
}
```

HTTP(S)-ссылки открываются в новой вкладке. Для материалов на внешнем сервисе отдельно настройте доступ на этом сервисе. При неудачной попытке открыть адрес показывается сообщение.

`url` можно удалить, задать как `null` или пустую строку: останутся название, описание и подпись «Ссылка пока не добавлена», без кнопки. Неверный адрес и неподдерживаемая схема также не создают кнопку. Число или объект вместо строки считаются ошибкой типов. Массивы `products`, `sources`, `additionalMaterials` можно опустить, задать как `null` или оставить пустыми.

В демонстрации у первой группы есть пример URL, у второй — продукт без URL, у третьей — пустой список продуктов. Доступность и содержание внешних сайтов автоматически не проверяются.

## Обновление раздела «Учителю»

Редактируйте `teacher.json`. Характеристика, аудитория, рекомендации, организация работы и рефлексия — строки. Предметы, цели, результаты, подготовка, этапы и критерии — массивы `title` + `description`. Источники `sources` и материалы `additionalMaterials` имеют формат информационных продуктов с необязательным URL.

Важные разделы видны сразу, без скрытых раскрывающихся панелей. Добавление пунктов в существующие массивы не требует изменения интерфейса. Для принципиально нового раздела потребуется дополнить модель и страницу.

## Проверки

```powershell
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

Автоматическое применение форматирования: `dart format lib test`.

Проверяются модели, обязательные и вложенные поля, типы, отсутствие файла, синтаксис JSON, повторяющиеся идентификаторы, кэш, повторная загрузка, пустые продукты и URL, страницы и переходы, прямой вход, неизвестные адреса, мобильное меню и клавиатура. Компоновка проверяется на ширинах **320, 768 и 1440 px**, длинное название — при масштабе текста **200%**.

UI-тесты используют отдельные данные из `test/fixtures.dart`, поэтому изменение текстов и числа групп не требует переписывать тесты. Дополнительный тест проверяет актуальные четыре файла `assets/data/` на совместимость с моделями. Два предложения Lorem ipsum — условие начального демонстрационного комплекта; настоящие тексты можно свободно заменить.

## Release-сборка

Для корня домена:

```powershell
flutter build web --release --base-href / --no-web-resources-cdn
```

Для `https://USERNAME.github.io/school-project/`:

```powershell
flutter build web --release --base-href /school-project/ --no-web-resources-cdn
```

Базовый путь должен начинаться и заканчиваться `/`. Результат — `build/web`. Флаг `--no-web-resources-cdn` включает ресурсы веб-движка в локальную сборку. Папка `build/` не хранится в исходном репозитории.

Используйте Flutter или статический HTTP(S)-хостинг. Двойной щелчок по `index.html` с открытием через `file://` не является корректным запуском Flutter Web.

## Маршруты

| Страница | Адрес относительно корня сайта |
| --- | --- |
| Главная | `/#/` |
| О проекте | `/#/project` |
| Работы групп | `/#/groups` |
| Отдельная группа | `/#/groups/group-1` |
| Итоги проекта | `/#/conclusions` |
| Учителю | `/#/teacher` |

В репозитории GitHub Pages перед hash добавляется путь: `https://USERNAME.github.io/REPOSITORY/#/groups/group-1`. Используются стандартная hash-стратегия Flutter Web и `MaterialApp.onGenerateRoute`. При прямом входе и обновлении сервер отдаёт корневой документ сайта, а экран выбирает Flutter. Не включайте `usePathUrlStrategy` без отдельного решения маршрутизации на хостинге.

## GitHub Pages

1. Создайте репозиторий GitHub. Для простого размещения выберите публичный; доступность Pages для частных зависит от тарифа GitHub.
2. Поместите **содержимое** `school_project` в корень репозитория: `pubspec.yaml` и `.github` должны лежать непосредственно в нём.
3. В терминале проекта выполните, заменив `USERNAME` и `REPOSITORY`:

```powershell
git init
git add .
git commit -m "feat: add school research website"
git branch -M main
git remote add origin https://github.com/USERNAME/REPOSITORY.git
```

4. На GitHub откройте **Settings → Pages → Build and deployment → Source → GitHub Actions**.
5. Отправьте проект:

```powershell
git push -u origin main
```

6. Во вкладке **Actions** дождитесь успешного `Verify and deploy Flutter Web`. URL появится в задании `deploy` и в Settings → Pages.
7. Откройте сайт и прямую ссылку на группу; обновите страницу.

Если первая попытка началась до настройки Pages, включите нужный источник и запустите workflow через **Run workflow**. Среда `github-pages` должна разрешать публикацию ветки `main`.

### Работа GitHub Actions

Workflow `.github/workflows/deploy.yml` запускается при push в `main` и вручную. Этап `build` устанавливает Flutter Stable 3.47.8, получает зависимости с проверкой lock-файла, проверяет формат, запускает анализатор и тесты. `configure-pages` определяет базовый путь, Flutter создаёт release-сборку, `upload-pages-artifact` загружает `build/web`. Этап `deploy` публикует результат только после успешной сборки.

Закреплены SHA проверенных основных версий Actions: checkout v7, configure-pages v6, upload-pages-artifact v5, deploy-pages v5. Flutter устанавливается из официального Git-репозитория по тегу стабильного выпуска 3.47.8. Этот способ установки SDK использован при фактической проверке комплекта. Используется встроенный механизм GitHub Pages: `pages: write` и `id-token: write` предоставлены только заданию публикации. Персональный токен и собственные секреты не нужны.

Путь берётся из `steps.pages.outputs.base_path`, затем добавляется завершающий `/`. Имя обычного репозитория не требуется вписывать в workflow. Необязательная переменная репозитория **PAGES_BASE_PATH** позволяет явно переопределить путь.

При обновлении Flutter измените `FLUTTER_VERSION` в workflow, при необходимости `environment` в `pubspec.yaml`, выполните `flutter pub get`, проверки и сохраните новый `pubspec.lock`. При обновлении Actions меняйте закреплённые SHA на соответствующие версии.

### Корневой репозиторий и собственный домен

- Для репозитория `USERNAME.github.io` метаданные Pages дают пустой путь, а сборка получает `/`. Код менять не нужно.
- Для собственного домена настройте **Settings → Pages → Custom domain**, DNS и HTTPS по [инструкции GitHub](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site). В **Settings → Secrets and variables → Actions → Variables** задайте `PAGES_BASE_PATH` равным `/`, чтобы явно собрать сайт для корня домена. Затем снова запустите workflow.
- При возвращении к `USERNAME.github.io/REPOSITORY/` удалите переопределение `PAGES_BASE_PATH`, чтобы использовать метаданные Pages.

### Обновление содержимого после публикации

Отредактируйте JSON, выполните проверки и отправьте commit в `main`:

```powershell
flutter test
git add assets/data
git commit -m "docs: update project content"
git push
```

GitHub Actions автоматически соберёт и опубликует новую версию. На сайте нет формы редактирования. JSON включаются в сборку; после публикации обновите вкладку браузера.

## Диагностика

| Симптом | Что проверить |
| --- | --- |
| `flutter` не найден | `C:\src\flutter\bin` в пользовательском Path; откройте новый терминал |
| Edge не обнаружен | Установка Edge, `flutter devices`, запуск на Windows; попробуйте Chrome |
| Не найден `pubspec.yaml` | Перейдите в папку с этим файлом, а не в родительский каталог |
| Зависимости не разрешаются | Доступность pub.dev, версии Flutter/Dart и lock-файла; при намеренном обновлении выполните `flutter pub get` и сохраните `pubspec.lock` |
| «Файл … недоступен» | Имя, наличие файла и раздел `flutter.assets`, затем перезапуск |
| «Ошибка в … $.stages[0].description» | Синтаксис, обязательное поле или тип по указанному пути |
| «Группа не найдена» | Совпадение `id` и URL, формат и уникальность идентификаторов |
| Нет кнопки материала | URL отсутствует, пуст или не является абсолютным HTTP(S)-адресом с именем хоста |
| JSON изменён, экран прежний | Hot restart вместо hot reload; после публикации — обновление страницы |
| Pages отдаёт 404 | Источник GitHub Actions, структура корня репозитория, статус workflow и адрес |
| Белый экран до запуска Flutter / 404 ресурсов | Базовый путь сборки, Network и Console; не используйте `file://` |
| Workflow остановился на формате | Выполните `dart format lib test`, commit и push |
| Ошибка `configure-pages` или `deploy` | Включён ли Pages, выбран ли GitHub Actions, разрешена ли ветка `main` в `github-pages` |
| Устаревший текст после публикации | Последний workflow, правильный URL, принудительное обновление и кеш браузера |

## Результаты проверки

Фактически выполненные проверки и их границы перечислены в `VERIFICATION.md`. Публикацию в свой репозиторий GitHub выполняет владелец по приведённой инструкции.

## Официальные материалы

- [Установка Flutter](https://docs.flutter.dev/install/manual)
- [Стратегии URL](https://docs.flutter.dev/ui/navigation/url-strategies)
- [Веб-сборка Flutter](https://docs.flutter.dev/deployment/web)
- [Flutter Web и индексация](https://docs.flutter.dev/platform-integration/web/faq)
- [url_launcher](https://pub.dev/packages/url_launcher)
- [GitHub Pages: собственные workflows](https://docs.github.com/en/pages/getting-started-with-github-pages/using-custom-workflows-with-github-pages)
