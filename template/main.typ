#import "@local/lab-theme:0.1.0": slides
#import slides.normal: *

#show: normal-theme.with(
  // subtitle: self => utils.display-current-heading(level: 1),
  // footer: [研究室ミーティング],
  // show-date: true,
  config-info(
    title: [研究タイトル],
    author: [氏名],
    date: datetime.today(),
  ),
)

#title-slide()

#toc-slide()

= はじめに

== 背景

=== 見出し

- 項目
  - 詳細
    - 結論

= 提案手法

== 手法の概要

+ 手順 1
+ 手順 2
