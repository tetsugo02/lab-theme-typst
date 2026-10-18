// Development demo: imports the package from this checkout. A deck outside
// the repository uses `#import "@local/lab-theme:0.1.0": slides` instead.
#import "../lib.typ": slides
#import slides.normal: *

#show: normal-theme.with(
  footer: [フッター Footer],
  show-date: true,
  config-info(
    title: [研究タイトル Research Title],
    author: [氏名 Taro Yamada],
    date: datetime(year: 2026, month: 10, day: 16),
  ),
)

#title-slide()

= はじめに Introduction

#slide(title: [スライドタイトル Slide Title], subtitle: [サブタイトル Subtitle])[
  === レベル1 Level one 見出し

  - レベル2 Level two 本文テキスト
    - レベル3 Level three 詳細
      - レベル4 Level four 結論
        - レベル5 Level five 補足
  - 二つ目の項目 Second item
]

== スライドタイトル Slide Title

=== レベル1 Level one 見出し

- レベル2 Level two 本文テキスト
  - レベル3 Level three 詳細
    - レベル4 Level four 結論
      - レベル5 Level five 補足
- 二つ目の項目 Second item

#toc-slide(title: [スライドタイトル Slide Title])

= 関連研究 Related Work

== 関連研究

- 先行研究 A
- 先行研究 B

= 提案手法 Method

== 提案手法

+ 手順 1
+ 手順 2
  + 詳細

#blank-slide[]

#blank-slide(footer: true)[]
