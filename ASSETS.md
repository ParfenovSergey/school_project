# Иллюстрации и шрифты

Визуальные материалы подготовлены для версии 0.2.0. Иллюстрации служат декоративным образом исследования и путешествия; они не изображают реальных участников и не являются результатами учебных исследований.

## Иллюстрации

Созданы встроенным инструментом **Imagegen** по пользовательскому стилевому референсу. Использован встроенный режим, без CLI и отдельного API-ключа. В проект включены оптимизированные WebP; прозрачность главной иллюстрации сохранена. Тексты интерфейса и заголовки отрисовываются Flutter отдельно от рисунков.

| Назначение | Путь |
| --- | --- |
| Главная сцена с исследователем | `assets/images/project/explorer-hero.webp` |
| Телескоп и звёзды | `assets/images/groups/telescope.webp` |
| Записная книжка и лупа | `assets/images/groups/field-notebook.webp` |
| Лодка, карта и компас | `assets/images/groups/paper-boat.webp` |

Изображения подключены через `project.json` и `groups.json`. Исходный референс не требуется для запуска сайта и в исходный комплект не включён.

### Промты создания

**assets/images/project/explorer-hero.webp**

Прозрачный фон: да.

```text
Use case: illustration-story. Create an ORIGINAL polished 2D editorial storybook illustration for a Russian school research project website. The attached image is a STYLE REFERENCE ONLY: take its lively flat cut-paper shapes, elegant silhouettes, turquoise and golden-orange palette, playful illustrated adventure feeling and light hand-painted texture. Do not reproduce its exact character, branding, text or website. No lettering, no words, no watermark, no logos. This is an illustration asset, NOT a screenshot or UI mockup. Asset: main hero artwork, isolated on a genuinely transparent background, wide 4:3 composition. A friendly androgynous young explorer with a teal coat and warm orange scarf sits in a whimsical wooden-and-paper sailing boat riding a few sculptural white clouds, holding an open folded map. A golden telescope, a small stack of books and botanical leaves suggest curiosity and discovery. The full boat and sail fit inside the image with a small clear margin, no hard rectangular background, no cast floor shadow. Warm cream sail, terracotta hull, teal coat, saffron accents, deep ink outlines. Make the face expressive and the silhouette memorable, with sophisticated large graphic shapes. The artwork will sit on a turquoise gradient to the right of live website text.
```

**assets/images/groups/telescope.webp**

Прозрачный фон: нет.

```text
Use case: illustration-story. Create an ORIGINAL polished 2D editorial storybook illustration for a Russian school research project website. The attached image is a STYLE REFERENCE ONLY: take its lively flat cut-paper shapes, elegant silhouettes, turquoise and golden-orange palette, playful illustrated adventure feeling and light hand-painted texture. Do not reproduce its exact character, branding, text or website. No lettering, no words, no watermark, no logos. This is an illustration asset, NOT a screenshot or UI mockup. Asset: landscape 3:2 illustration for a research group card. A large golden telescope on a tripod on a plum-colored dreamy hill, a tiny open notebook beside it, an elegant crescent moon and stylized constellations in a deep aubergine and indigo sky. A few cut-paper cloud and leaf shapes, no people, no letters. Simple bold close-up composition, beautiful crop-safe central subject, restrained printed-paper texture.
```

**assets/images/groups/field-notebook.webp**

Прозрачный фон: нет.

```text
Use case: illustration-story. Create an ORIGINAL polished 2D editorial storybook illustration for a Russian school research project website. The attached image is a STYLE REFERENCE ONLY: take its lively flat cut-paper shapes, elegant silhouettes, turquoise and golden-orange palette, playful illustrated adventure feeling and light hand-painted texture. Do not reproduce its exact character, branding, text or website. No lettering, no words, no watermark, no logos. This is an illustration asset, NOT a screenshot or UI mockup. Asset: landscape 3:2 illustration for a research group card. An open research notebook with blank cream pages, a large magnifying glass and lively stylized fern leaves, on a warm saffron and apricot background. Teal and dark olive accents, coral leaf shapes, no people, no letters, no symbols pretending to be text. Simple bold close-up composition with the objects filling the frame, beautiful crop-safe central subject, restrained printed-paper texture.
```

**assets/images/groups/paper-boat.webp**

Прозрачный фон: нет.

```text
Use case: illustration-story. Create an ORIGINAL polished 2D editorial storybook illustration for a Russian school research project website. The attached image is a STYLE REFERENCE ONLY: take its lively flat cut-paper shapes, elegant silhouettes, turquoise and golden-orange palette, playful illustrated adventure feeling and light hand-painted texture. Do not reproduce its exact character, branding, text or website. No lettering, no words, no watermark, no logos. This is an illustration asset, NOT a screenshot or UI mockup. Asset: landscape 3:2 illustration for a research group card. A cream paper sailboat on broad graphic turquoise waves with a folded blank map and golden compass, a tiny distant cloud, bright turquoise and sea-green background. Saffron and coral accents, no people, no letters. Simple bold close-up composition with a beautiful crop-safe central subject, restrained printed-paper texture.
```

## Шрифты

Шрифты включены локально и проверены на наличие кириллицы. Сохранены исходные файлы лицензий SIL Open Font License.

| Семейство | Файлы | Источник |
| --- | --- | --- |
| Amatic SC | `assets/fonts/amaticsc/AmaticSC-Regular.ttf`, `AmaticSC-Bold.ttf` | [Google Fonts](https://github.com/google/fonts/tree/main/ofl/amaticsc) |
| Nunito | `assets/fonts/nunito/Nunito-Variable.ttf` | [Google Fonts](https://github.com/google/fonts/tree/main/ofl/nunito) |

Лицензии: `assets/fonts/amaticsc/OFL.txt` и `assets/fonts/nunito/OFL.txt`. При распространении комплекта сохраняйте эти файлы.

## Декоративные элементы

Облака, птицы и листья — адаптивные `CustomPainter` в `lib/widgets/illustrated_decor.dart`. Иконки интерфейса — Material Icons из Flutter SDK. Значок сайта создан из локального векторного файла `web/icons/project.svg`; его PNG-версии включены в каталог `web/`.

