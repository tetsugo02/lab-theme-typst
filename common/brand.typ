// Lab colors and fonts, taken from the PowerPoint template ppt_tpl_v7.potx.
// Shared by every theme in this package.

/// Theme colors of the template (ユーザー定義 1).
#let lab-colors = (
  dk1: rgb("#212121"),
  lt1: rgb("#ffffff"),
  dk2: rgb("#44546a"),
  lt2: rgb("#e7e6e6"),
  accent1: rgb("#001e61"),
  accent2: rgb("#c63427"),
  accent3: rgb("#737373"),
  accent4: rgb("#f1c300"),
  accent5: rgb("#5b9bd5"),
  accent6: rgb("#70ad47"),
  hlink: rgb("#0563c1"),
  fol-hlink: rgb("#954f72"),
  // tx1 with 75% tint, used by the date and footer placeholders
  footer: rgb("#8c8c8c"),
)

/// Fonts of the template (roboto_and_gennokaku). Noto Sans CJK JP has the same
/// glyphs as 源ノ角ゴシック and is the fallback when it is not installed.
#let lab-fonts = ("Roboto", "Source Han Sans JP", "Noto Sans CJK JP")
