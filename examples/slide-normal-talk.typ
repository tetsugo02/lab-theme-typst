// Sample research talk with slides.normal: every slide type plus the usual
// content of a lab presentation (lists, math, tables, figures, animation).
#import "../lib.typ": slides, lab-colors
#import slides.normal: *

#show: normal-theme.with(
  subtitle: self => utils.display-current-heading(level: 1),
  footer: [研究室ミーティング],
  show-date: true,
  config-info(
    title: [少数ラベルでの画像分類のための\ 自己教師あり事前学習],
    author: [山田 太郎（修士2年）],
    date: datetime(year: 2026, month: 10, day: 18),
  ),
)

// A box in the method diagram.
#let stage(title, body, fill: lab-colors.lt2) = rect(
  width: 100%,
  height: 100%,
  fill: fill,
  radius: 4pt,
  inset: 10pt,
  align(center + horizon, {
    text(size: 20pt, weight: "bold", title)
    linebreak()
    text(size: 16pt, body)
  }),
)

// One bar of the result chart.
#let bar(label, value, fill) = {
  let height = value / 100 * 150pt
  stack(
    dir: ttb,
    spacing: 6pt,
    box(height: 150pt - height),
    align(center, text(size: 16pt, [#value%])),
    rect(width: 56pt, height: height, fill: fill),
    align(center, text(size: 16pt, label)),
  )
}

#title-slide()

#toc-slide()

= はじめに

== 研究背景

- 画像分類の精度は大量のラベル付きデータに支えられている
  - ImageNet: 約 120 万枚のラベル付き画像
- 医療・製造の現場ではラベル付けのコストが大きい
  - 専門家による確認が必要
    - ラベル付きデータは数百枚程度にとどまる

== 本研究の目的

=== 課題

- 少数ラベルでは過学習しやすく、精度が大きく低下する

=== 目的

- ラベルなし画像から有用な表現を事前学習し、#alert[100 枚程度のラベル]で十分な精度を達成する

= 提案手法

== 全体構成

#grid(
  columns: (1fr, auto, 1fr, auto, 1fr),
  rows: 110pt,
  column-gutter: 16pt,
  align: horizon,
  stage[データ拡張][2 種類の変換を適用],
  text(size: 28pt, fill: lab-colors.accent1, sym.arrow.r),
  stage[エンコーダ][ResNet-50],
  text(size: 28pt, fill: lab-colors.accent1, sym.arrow.r),
  stage(fill: lab-colors.accent1)[#text(fill: white)[対照損失]][#text(fill: white)[同じ画像の表現を近づける]],
)

#v(16pt)

- 同じ画像の 2 つの変換を正例とし、ラベルは使わない
  - 事前学習後に少数ラベルで微調整する

#speaker-note[
  図は左から順に説明する。対照損失の直感（同じ画像は近く、異なる画像は遠く）を強調する。
]

== 定式化

- 正例ペア $(z_i, z_j)$ に対する損失

$
  cal(L)_(i,j) = -log frac(
    exp("sim"(z_i, z_j) \/ tau),
    sum_(k=1)^(2N) bb(1)_[k != i] exp("sim"(z_i, z_k) \/ tau)
  )
$

- $"sim"(dot, dot)$: コサイン類似度、$tau$: 温度パラメータ
  - $tau$ を小さくすると難しい負例を重視する

= 実験

== 実験設定

#table(
  columns: (auto, 1fr),
  inset: (x: 12pt, y: 8pt),
  stroke: (x, y) => if y == 0 { (bottom: 1.5pt + lab-colors.accent1) } else { (bottom: 0.5pt + lab-colors.lt2) },
  fill: (x, y) => if y == 0 { lab-colors.accent1 },
  table.header(text(fill: white, weight: "bold")[項目], text(fill: white, weight: "bold")[設定]),
  [データセット], [CIFAR-10（ラベル付き 100 枚 / クラス）],
  [事前学習], [ラベルなし 50,000 枚、200 エポック],
  [比較手法], [教師ありのみ、ImageNet 事前学習],
  [評価指標], [テストデータの分類精度（5 回平均）],
)

== 結果

#slide(composer: (1fr, 1fr))[
  #align(center, stack(
    dir: ltr,
    spacing: 28pt,
    bar([教師あり], 52, lab-colors.accent3),
    bar([ImageNet], 71, lab-colors.accent5),
    bar([提案手法], 84, lab-colors.accent1),
  ))
][
  - 提案手法が最も高い精度
    - 教師ありのみより *+32 ポイント*

  #pause

  - ImageNet 事前学習も上回る
    - #alert[ドメインの近いラベルなしデータ]が有効
]

= まとめ

== まとめと今後の課題

=== まとめ

- ラベルなし画像による事前学習で、少数ラベルでの精度を大きく改善した

=== 今後の課題

+ 医療画像データセットでの検証
+ 必要なラベル数の下限の調査

#blank-slide[
  #align(center + horizon, text(size: 40pt, weight: "bold", fill: lab-colors.accent1)[
    ご清聴ありがとうございました
  ])
]
