// slides.normal: the lab slide theme for Touying, reproducing the PowerPoint
// template ppt_tpl_v7.potx.
//
// Every position and size below comes from the template's slide layouts. They
// are written in EMU (1pt = 12700 EMU) so they can be checked against the
// .potx XML. The page is 13.333in x 7.5in like the template, so font sizes in
// pt match PowerPoint 1:1.
//
// Slide types (PowerPoint layout -> function):
//   タイトル スライド  -> title-slide
//   サブタイトルあり    -> slide(subtitle: [...])
//   サブタイトルなし    -> slide()  (`== Title` in markup)
//   目次               -> toc-slide
//   空白               -> blank-slide()
//   空白_フッターあり   -> blank-slide(footer: true)
//
// Body text levels (PowerPoint level -> Typst markup):
//   level 1: bold navy heading           -> `=== Heading`
//   level 2: navy filled square          -> `- item`
//   level 3: hollow square               -> nested `- item`
//   level 4: arrow (24pt)                -> nested twice
//   level 5: arrow (20pt)                -> nested three times

// Touying is re-exported, so `#import slides.normal: *` is the only import a
// deck needs.
#import "@preview/touying:0.7.3": *
#import "../../common/brand.typ": lab-colors, lab-fonts

#let emu(n) = n * 1pt / 12700


// Line boxes measured from PowerPoint's own output. `top` is the distance from
// the top of a line to its baseline, `bottom` from the baseline down to the
// next line, so `top + bottom` is the line pitch.
#let _spacing-90 = (top: 0.845em, bottom: 0.225em) // lnSpc 90%: titles, footer
#let _spacing-120 = (top: 1.07em, bottom: 0.36em) // lnSpc 120%: body levels

#let _line(spacing) = (top-edge: spacing.top, bottom-edge: -spacing.bottom)

// Placeholder insets (bodyPr lIns/tIns/rIns/bIns defaults)
#let _inset-x = emu(91440)
#let _inset-y = emu(45720)
#let _body-inset-left = emu(90000)

// Body level 2-5 of the content layouts, positions relative to the left edge
// of the text box (marL = text start, bu = bullet start, pct = buSzPct).
#let _levels = (
  (marL: emu(396000), bu: emu(36000), size: 24pt, before: 12pt, marker: "square", pct: 0.85),
  (marL: emu(720000), bu: emu(432000), size: 20pt, before: 6pt, marker: "hollow", pct: 0.85),
  (marL: emu(792000), bu: emu(432000), size: 24pt, before: 4pt, marker: "arrow", pct: 1.0),
  (marL: emu(1080000), bu: emu(756000), size: 20pt, before: 2pt, marker: "arrow", pct: 1.0),
)

// Picture bullets are drawn as vectors, traced from the template's images.
// PowerPoint draws a picture bullet 0.7 * buSzPct of the font size high, with
// its bottom just above the baseline.
#let _marker(kind, height, primary, text-color) = {
  let h = height
  if kind == "square" {
    box(width: h, height: h, place(dx: 0.1 * h, rect(width: 0.8 * h, height: 0.8 * h, fill: primary)))
  } else if kind == "hollow" {
    let side = 0.834 * h
    let t = 0.185 * h
    box(width: h, height: h, place(
      dx: 0.083 * h + t / 2,
      dy: 0.051 * h + t / 2,
      rect(width: side - t, height: side - t, stroke: t + text-color),
    ))
  } else {
    let w = h * 818 / 682
    let pt(x, y) = (x / 818 * w, y / 682 * h)
    box(width: w, height: h, polygon(
      fill: text-color,
      pt(0, 272), pt(578, 272), pt(306, 0), pt(476, 0), pt(818, 341),
      pt(476, 682), pt(306, 682), pt(578, 410), pt(0, 410),
    ))
  }
}

// Renders a list or enum with the template's level styles. `origin` is where
// the list's container starts, relative to the left edge of the text box, so
// nested levels land at the template's absolute positions.
#let _lab-list(self: none, depth: 1, origin: 0pt, it) = {
  let lv = _levels.at(calc.min(depth, _levels.len()) - 1)
  let text-color = self.colors.neutral-darkest
  let is-enum = it.func() == enum
  let n = if is-enum and it.start != auto { it.start } else { 1 }
  let items = for item in it.children {
    let number = if is-enum and type(item.number) == int { item.number } else { n }
    n = number + 1
    let marker = if is-enum {
      text(fill: self.colors.primary, numbering(it.numbering, number))
    } else {
      let h = 0.7 * lv.pct * lv.size
      box(height: _spacing-120.top - 0.042em, align(bottom, _marker(lv.marker, h, self.colors.primary, text-color)))
    }
    block(above: lv.before, below: 0pt, width: 100%, {
      set text(size: lv.size, fill: text-color, .._line(_spacing-120))
      set par(leading: 0pt, spacing: lv.before)
      pad(left: lv.marL - origin, {
        place(top + left, dx: lv.bu - lv.marL, marker)
        show list: _lab-list.with(self: self, depth: depth + 1, origin: lv.marL)
        show enum: _lab-list.with(self: self, depth: depth + 1, origin: lv.marL)
        item.body
      })
    })
  }
  // A top-level list keeps the plain paragraph spacing below it; nested lists
  // leave the gap to their parent's next item.
  block(above: lv.before, below: if depth == 1 { 12pt } else { 0pt }, items)
}

// Sets up the body text of a content placeholder. `base` is where paragraph
// text starts relative to the text box: the content layouts align level 1 and
// plain paragraphs with the level 2 text, the TOC layout starts near the edge.
#let _body-setting(self, base) = body => {
  set text(size: 24pt, fill: self.colors.neutral-darkest, .._line(_spacing-120))
  set par(leading: 0pt, spacing: 12pt)
  show heading.where(level: 3): it => block(above: 20pt, below: 12pt, text(
    size: 28pt,
    weight: "bold",
    fill: self.colors.primary,
    it.body,
  ))
  show heading.where(level: 4): it => block(above: 12pt, below: 12pt, text(
    size: 24pt,
    weight: "bold",
    fill: self.colors.primary,
    it.body,
  ))
  show list: _lab-list.with(self: self, origin: base)
  show enum: _lab-list.with(self: self, origin: base)
  pad(left: base, body)
}

// A text placeholder: a box at EMU position with the template's insets and
// vertical anchor.
#let _placeholder(x, y, w, h, anchor: horizon, align: left, inset-left: _inset-x, body) = place(
  top + left,
  dx: emu(x),
  dy: emu(y),
  box(
    width: emu(w),
    height: emu(h),
    inset: (left: inset-left, right: _inset-x, y: _inset-y),
    std.align(anchor + align, body),
  ),
)

#let _title-text(self, size: 32pt, body) = {
  set text(size: size, fill: self.colors.neutral-lightest, .._line(_spacing-90))
  set par(leading: 0pt)
  body
}

// Date, footer and slide number, shared by the content layouts. They go in the
// page foreground: it is laid out after the body, so the slide counter has
// already been stepped for this slide.
#let _footer-items(self, date-color: auto, number: true) = {
  let small(fill, body) = text(size: 12pt, fill: fill, .._line(_spacing-90), body)
  if self.store.show-date and self.info.date != none {
    let c = if date-color == auto { lab-colors.footer } else { date-color }
    _placeholder(477982, 6470115, 1401618, 365125, small(c, utils.display-info-date(self)))
  }
  if self.store.footer != none {
    _placeholder(1924048, 6470115, 8343900, 365125, align: center, small(
      lab-colors.footer,
      utils.call-or-display(self, self.store.footer),
    ))
  }
  if number {
    place(top + left, dx: emu(11760385), dy: emu(6426200), rect(
      width: emu(431615),
      height: emu(431800),
      fill: self.colors.primary,
    ))
    if self.store.show-slide-number {
      _placeholder(11760385, 6470115, 431615, 365125, align: center, text(
        size: 14pt,
        fill: self.colors.neutral-lightest,
        .._line(_spacing-90),
        context utils.slide-counter.display(),
      ))
    }
  }
}

#let _default-title = utils.display-current-heading(level: 2)

/// Content slide: サブタイトルあり when a subtitle is given, else サブタイトルなし.
///
/// - title (auto, content): the slide title. `auto` uses the `== heading`.
/// - subtitle (auto, none, content, function): the small line above the title.
///   `auto` uses the theme's `subtitle` option.
#let slide(
  title: auto,
  subtitle: auto,
  config: (:),
  repeat: auto,
  setting: body => body,
  composer: auto,
  ..bodies,
) = touying-slide-wrapper(self => {
  let title = if title == auto { _default-title } else { title }
  let subtitle = if subtitle == auto { self.store.subtitle } else { subtitle }
  if type(subtitle) == function { subtitle = subtitle(self) }
  let with-subtitle = subtitle != none
  let (band, title-y, body-y) = if with-subtitle {
    (1498599, 741713, 1825625)
  } else {
    (1235220, 361700, 1596920)
  }
  let background = {
    place(top + left, rect(width: 100%, height: emu(band), fill: self.colors.primary))
    if with-subtitle {
      _placeholder(477982, 298270, 11236036, 448787, anchor: top, _title-text(self, size: 24pt, subtitle))
    }
    _placeholder(477981, title-y, 11236035, 569205, _title-text(self, title))
  }
  self = utils.merge-dicts(self, config-page(
    background: background,
    foreground: _footer-items(self),
    margin: (
      left: emu(477982) + _body-inset-left,
      top: emu(body-y) + _inset-y,
      right: emu(12192000 - 477982 - 11236034) + _inset-x,
      bottom: emu(6858000 - 6176963) + _inset-y,
    ),
  ))
  let new-setting = body => {
    show: _body-setting(self, emu(396000))
    show: setting
    body
  }
  // List bullets hang 28pt left of the text, more than Touying's 1em column
  // gutter, so columns get a wider gap.
  let composer = if composer == auto or type(composer) in (array, int) {
    components.side-by-side.with(columns: composer, gutter: 2em)
  } else {
    composer
  }
  touying-slide(self: self, config: config, repeat: repeat, setting: new-setting, composer: composer, ..bodies)
})

/// Title slide (タイトル スライド). The subtitle line shows `subtitle` from
/// config-info, or the author when there is no subtitle.
#let title-slide(config: (:), ..args) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(self, config-common(freeze-slide-counter: true), config)
  let info = self.info + args.named()
  let subtitle = if info.at("subtitle", default: none) != none {
    info.subtitle
  } else if type(info.author) == array {
    info.author.join(h(1em))
  } else {
    info.author
  }
  let background = {
    place(top + left, rect(width: emu(381000), height: 100%, fill: self.colors.primary))
    place(top + left, dx: emu(1220503), dy: emu(3641393), line(
      length: emu(9768922),
      stroke: 1pt + self.colors.primary,
    ))
    _placeholder(1090866, 1840899, 10025368, 1655762, anchor: bottom, {
      set text(size: 48pt, weight: "bold", fill: self.colors.primary, .._line(_spacing-90))
      set par(leading: 0pt)
      info.title
    })
    _placeholder(1090865, 3904736, 10025369, 578036, anchor: top, {
      set text(size: 24pt, fill: self.colors.neutral-darkest, .._line(_spacing-90))
      set par(leading: 0pt)
      subtitle
    })
  }
  self = utils.merge-dicts(self, config-page(
    background: background,
    foreground: _footer-items(self, number: false),
    margin: 0pt,
  ))
  touying-slide(self: self, [])
})

/// Table of contents slide (目次): title in the left panel, body on the right.
/// Without a body it lists the sections (`= heading`) as level-1 entries.
#let toc-slide(title: [目次], config: (:), body: auto) = touying-slide-wrapper(self => {
  let background = {
    place(top + left, rect(width: emu(2775859), height: 100%, fill: self.colors.primary))
    _placeholder(478475, 741714, 1818904, 1446316, anchor: top, _title-text(self, title))
  }
  self = utils.merge-dicts(self, config-page(
    background: background,
    foreground: _footer-items(self, date-color: self.colors.neutral-lightest),
    margin: (
      left: emu(3254334) + _body-inset-left,
      top: emu(741714) + _inset-y,
      right: emu(12192000 - 3254334 - 8459681) + _inset-x,
      bottom: emu(6858000 - 6176964) + _inset-y,
    ),
  ))
  let content = if body == auto {
    show outline.entry: it => block(above: 20pt, below: 0pt, link(
      it.element.location(),
      text(size: 28pt, weight: "bold", fill: self.colors.primary, it.element.body),
    ))
    outline(title: none, depth: 1)
  } else {
    body
  }
  // Level 1 starts right after PowerPoint's invisible bullet here.
  touying-slide(self: self, config: config, setting: _body-setting(self, 3pt), content)
})

/// Blank slide (空白), or 空白_フッターあり with `footer: true`. The body uses
/// the whole page unless `config: config-page(margin: ...)` says otherwise.
#let blank-slide(footer: false, config: (:), ..bodies) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(self, config-page(
    foreground: if footer { _footer-items(self) },
    margin: 0pt,
  ))
  touying-slide(self: self, config: config, ..bodies)
})

/// The normal lab slide theme.
///
/// - subtitle (none, content, function): default subtitle above every slide
///   title, e.g. `self => utils.display-current-heading(level: 1)` for the
///   current section.
/// - footer (none, content, function): text of the footer placeholder.
/// - show-date (bool): show `config-info(date: ...)` at the bottom left.
/// - show-slide-number (bool): show the number in the bottom-right square.
#let normal-theme(
  subtitle: none,
  footer: none,
  show-date: false,
  show-slide-number: true,
  ..args,
  body,
) = {
  show: touying-slides.with(
    config-page(width: emu(12192000), height: emu(6858000), margin: 0pt),
    config-common(
      slide-fn: slide,
      new-section-slide-fn: none,
      datetime-format: "[year]/[month padding:none]/[day padding:none]",
    ),
    config-methods(
      init: (self: none, body) => {
        set text(font: lab-fonts, lang: "ja", cjk-latin-spacing: none, fill: self.colors.neutral-darkest)
        show link: set text(fill: lab-colors.hlink)
        body
      },
      alert: (self: none, it) => text(fill: self.colors.secondary, it),
    ),
    config-colors(
      primary: lab-colors.accent1,
      secondary: lab-colors.accent2,
      tertiary: lab-colors.accent3,
      neutral-lightest: lab-colors.lt1,
      neutral-light: lab-colors.lt2,
      neutral-dark: lab-colors.dk2,
      neutral-darkest: lab-colors.dk1,
    ),
    config-store(
      subtitle: subtitle,
      footer: footer,
      show-date: show-date,
      show-slide-number: show-slide-number,
    ),
    ..args,
  )
  body
}
