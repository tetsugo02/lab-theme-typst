# lab-theme-typst

研究室のPowerPointテンプレート（`ppt_tpl_v7.potx`）をTypstで再現したテーマ集です。
スライドは [Touying](https://github.com/touying-typ/touying) のテーマとして使えます。

```
lab-theme-typst/
├── lib.typ              # パッケージの入口（slides 名前空間と共通の色・フォント）
├── common/brand.typ     # 研究室の配色・フォント（全テーマ共通）
├── slide/
│   ├── lib.typ          # スライドテーマの一覧
│   └── normal/          # slides.normal: 通常の発表用テーマ
├── template/main.typ    # 新しい発表資料の雛形
├── examples/            # 開発用のデモ
└── scripts/install.sh   # ローカルパッケージとして登録
```

## インストール

```sh
git clone <this repository> ~/workspace/lab-theme-typst
~/workspace/lab-theme-typst/scripts/install.sh
```

`install.sh` はこのリポジトリを Typst のローカルパッケージ
（macOS では `~/Library/Application Support/typst/packages/local/lab-theme/0.1.0`）
にシンボリックリンクします。リポジトリを更新すれば、そのまま反映されます。

### フォント

テンプレートと同じ表示にするには次のフォントが必要です。

- [Roboto](https://fonts.google.com/specimen/Roboto)（欧文）
- [源ノ角ゴシック JP / Source Han Sans JP](https://github.com/adobe-fonts/source-han-sans)（和文）

源ノ角ゴシックが無い環境では Noto Sans CJK JP（字形は同じ）が使われます。

## 使い方

```typst
#import "@local/lab-theme:0.1.0": slides
#import slides.normal: *   // Touying もまとめて読み込まれます

#show: normal-theme.with(
  config-info(title: [研究タイトル], author: [氏名], date: datetime.today()),
)

#title-slide()

= はじめに

== 背景

=== 見出し

- 項目
  - 詳細
```

`template/main.typ` をコピーして書き始めるのが手軽です。

### ページの種類（slides.normal）

| PowerPoint のレイアウト | Typst |
|---|---|
| タイトル スライド | `#title-slide()` |
| サブタイトルなし | `== タイトル`（または `#slide()`） |
| サブタイトルあり | `#slide(subtitle: [...])` |
| 目次 | `#toc-slide()`（本文を省略すると `=` のセクション一覧） |
| 空白 / 空白_フッターあり | `#blank-slide()` / `#blank-slide(footer: true)` |

### 本文のレベル

| PowerPoint | Typst | 見た目 |
|---|---|---|
| レベル1 | `=== 見出し` | 28pt 太字・紺、マークなし |
| レベル2 | `- 項目` | 24pt・紺の塗り四角 |
| レベル3 | 入れ子の `- 項目` | 20pt・白抜き四角 |
| レベル4 | 2段入れ子 | 24pt・矢印 |
| レベル5 | 3段入れ子 | 20pt・矢印 |

番号付きリスト（`+`）も同じレベル設定で番号を付けて表示します。

### オプション

```typst
#show: normal-theme.with(
  subtitle: self => utils.display-current-heading(level: 1), // 全スライドの小見出しにセクション名
  footer: [研究室ミーティング],   // フッター中央の文字
  show-date: true,                // 左下に config-info の日付
  show-slide-number: true,        // 右下の紺の四角に番号
)
```

色は `lab-colors.accent1` などで参照できます（`#alert` は `accent2` の赤）。

## テーマの追加

新しい種類は名前空間として追加します。

- スライドテーマ: `slide/<name>/<name>.typ` を作り、`slide/lib.typ` に
  `#import "<name>/<name>.typ" as <name>` を追加 → `slides.<name>` で利用
- ポスターなど: `poster/lib.typ` を作り、`lib.typ` に
  `#import "poster/lib.typ" as posters` を追加

色やフォントは `common/brand.typ` から読み込んでください。

## 既知の差異

- PowerPoint の「はみ出したら縮小」（自動調整）は再現していません。長いタイトルは枠からはみ出します。
- テンプレートではタイトルスライドが0番なので、タイトルスライドには番号を表示しません。
- 中身のない `=` 見出しが続くと空のスライドができます（Touying の仕様）。
