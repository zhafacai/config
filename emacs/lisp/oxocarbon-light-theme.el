;;; oxocarbon-light-theme.el --- Oxocarbon, a light theme derived from the Ef themes  -*- lexical-binding: t; -*-

;;; Commentary:

;; Light counterpart of `oxocarbon-theme' with the same Ef machinery and
;; the same IBM-Carbon-inspired "oxocarbon" accent identity (pink / teal /
;; blue / purple) on a light background.

;;; Code:

(require 'ef-themes)

(defconst oxocarbon-light-palette-partial
  '(
    ;; Structural
    (cursor          "#2a5fc0")
    (bg-main         "#f2f4f8")
    (bg-dim          "#e8ebf1")
    (bg-alt          "#dde2ea")
    (fg-main         "#161616")
    (fg-dim          "#4a5058")
    (fg-alt          "#5f6772")
    (bg-active       "#ccd3de")
    (bg-inactive     "#e4e8ee")
    (border          "#b8c0cc")

    ;; Red / pink — darker versions of the oxocarbon.nvim pinks
    (red             "#c21f5a")
    (red-warmer      "#d63384")
    (red-cooler      "#a81c50")
    (red-faint       "#cf6b9a")

    ;; Green / teal
    (green           "#1a7f3c")
    (green-warmer    "#2a9050")
    (green-cooler    "#0f6f6a")
    (green-faint     "#5a9e72")

    ;; Yellow — pink, matching the dark theme (no true yellow)
    (yellow          "#d63384")
    (yellow-warmer   "#cf6b9a")
    (yellow-cooler   "#c21f5a")
    (yellow-faint    "#cf6b9a")

    ;; Blue / sky
    (blue            "#2f5fd0")
    (blue-warmer     "#1a8bd0")
    (blue-cooler     "#2452a8")
    (blue-faint      "#5a80c8")

    ;; Magenta
    (magenta         "#7a4fd0")
    (magenta-warmer  "#8f5fe0")
    (magenta-cooler  "#6a42b8")
    (magenta-faint   "#9a82da")

    ;; Cyan
    (cyan            "#008f8a")
    (cyan-warmer     "#0a8a84")
    (cyan-cooler     "#005f5a")
    (cyan-faint      "#3f948f")

    ;; Tinted backgrounds
    (bg-red-intense   "#eec2cc")
    (bg-green-intense "#b8e4c2")
    (bg-yellow-intense "#e8b8c8")
    (bg-blue-intense  "#bccdf0")
    (bg-magenta-intense "#d9c2ec")
    (bg-cyan-intense  "#b4e0dc")
    (bg-red-subtle    "#f6d6de")
    (bg-green-subtle  "#d2ecd8")
    (bg-yellow-subtle "#f0c8d6")
    (bg-blue-subtle   "#d4e0f4")
    (bg-magenta-subtle "#e4d8ee")
    (bg-cyan-subtle   "#cce8e4")
    (bg-red-nuanced   "#fae8ec")
    (bg-green-nuanced "#e4f2e8")
    (bg-yellow-nuanced "#f4dce4")
    (bg-blue-nuanced  "#e2e8f6")
    (bg-magenta-nuanced "#ece2f2")
    (bg-cyan-nuanced  "#e0eeec")

    ;; Git / diff
    (bg-added         "#d2ecd8")
    (bg-added-faint   "#e2f2e6")
    (bg-added-refine  "#b8e0c2")
    (fg-added         "#1a7f3c")
    (bg-changed       "#f0c8d6")
    (bg-changed-faint "#f4dce4")
    (bg-changed-refine "#e8b8c8")
    (fg-changed       "#c21f5a")
    (bg-removed       "#f6d6de")
    (bg-removed-faint "#fae4e8")
    (bg-removed-refine "#eebec8")
    (fg-removed       "#a81c50")

    ;; UI
    (bg-mode-line-active "#dde2ea")
    (fg-mode-line-active "#161616")
    (bg-completion    "#bccdf0")
    (bg-popup         "#e8ebf1")
    (bg-hover         "#c2e4cc")
    (bg-hover-secondary "#eedcba")
    (bg-hl-line       "#e4e8ee")
    (bg-paren-match   "#b4e0dc")
    (bg-err           "#f6d6de")
    (bg-warning       "#f0c8d6")
    (bg-info          "#d2ecd8")
    (bg-region        "#ccd3de")))

(defconst oxocarbon-light-palette-mappings-partial
  '(
    ;; Error / warning / info — no true yellow, so warnings are the lighter
    ;; pink and errors the deeper pink (mirrors the dark theme).
    (err red)
    (warning yellow)
    (info green)

    (fg-link green-cooler)
    (fg-link-visited magenta)
    (name red)
    (keybind magenta)
    (identifier red-warmer)
    (fg-prompt red)

    ;; oxocarbon.nvim roles: keywords purple, strings sky-blue, functions
    ;; green, constants blue, classes pink, variables cyan.
    (builtin green-cooler)
    (comment fg-dim)
    (constant blue)
    (fnname green)
    (fnname-call green)
    (keyword magenta)
    (preprocessor magenta-cooler)
    (docstring blue-faint)
    (string blue-warmer)
    (type red)
    (variable cyan)
    (variable-use cyan)
    (rx-backslash yellow)
    (rx-construct cyan-cooler)

    (accent-0 green)
    (accent-1 red)
    (accent-2 cyan)
    (accent-3 magenta)

    (date-common green)
    (date-deadline red)
    (date-deadline-subtle red-faint)
    (date-event fg-alt)
    (date-holiday red-warmer)
    (date-now fg-main)
    (date-range fg-alt)
    (date-scheduled yellow)
    (date-scheduled-subtle yellow-faint)
    (date-weekday green-cooler)
    (date-weekend red)

    (fg-prose-code magenta)
    (prose-done green)
    (fg-prose-macro red-warmer)
    (prose-metadata fg-dim)
    (prose-metadata-value fg-alt)
    (prose-table fg-alt)
    (prose-table-formula info)
    (prose-tag cyan)
    (prose-todo yellow)
    (fg-prose-verbatim blue-warmer)

    (mail-cite-0 green-cooler)
    (mail-cite-1 green)
    (mail-cite-2 red)
    (mail-cite-3 red-warmer)
    (mail-part green)
    (mail-recipient red-faint)
    (mail-subject red)
    (mail-other red-warmer)

    (bg-search-static bg-warning)
    (bg-search-current bg-yellow-intense)
    (bg-search-lazy bg-blue-intense)
    (bg-search-replace bg-red-intense)

    (bg-search-rx-group-0 bg-magenta-intense)
    (bg-search-rx-group-1 bg-green-intense)
    (bg-search-rx-group-2 bg-red-subtle)
    (bg-search-rx-group-3 bg-cyan-subtle)

    (bg-space-err bg-yellow-intense)

    (rainbow-0 green)
    (rainbow-1 red-faint)
    (rainbow-2 green-cooler)
    (rainbow-3 yellow)
    (rainbow-4 blue-warmer)
    (rainbow-5 cyan-cooler)
    (rainbow-6 magenta-cooler)
    (rainbow-7 red-cooler)
    (rainbow-8 cyan)))

(defcustom oxocarbon-light-palette-overrides nil
  "Overrides for the `oxocarbon-light' palette.

Mirror the elements of the aforementioned palette, overriding their
value.  For overrides shared across all Ef themes refer to
`modus-themes-common-palette-overrides'."
  :group 'ef-themes
  :package-version '(ef-themes . "1.0.0")
  :type '(repeat (list symbol (choice symbol string)))
  :link '(info-link "(ef-themes) Palette overrides"))

(defconst oxocarbon-light-palette
  (modus-themes-generate-palette
   oxocarbon-light-palette-partial
   nil
   nil
   (append oxocarbon-light-palette-mappings-partial ef-themes-palette-common)))

;;;###theme-autoload
(modus-themes-theme
 'oxocarbon-light
 'ef-themes
 "Oxocarbon — a light theme derived from the Ef themes with the IBM-Carbon-inspired oxocarbon.nvim palette."
 'light
 'oxocarbon-light-palette
 nil
 'oxocarbon-light-palette-overrides)

(provide 'oxocarbon-light-theme)

;;; oxocarbon-light-theme.el ends here
