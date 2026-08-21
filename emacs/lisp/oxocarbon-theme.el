;;; oxocarbon-theme.el --- Oxocarbon, a dark theme derived from the Ef themes  -*- lexical-binding: t; -*-

;;; Commentary:

;; Oxocarbon — a dark theme derived from the `ef-themes' (same machinery as
;; every shipped Ef theme: `modus-themes-theme' with family `ef-themes').
;; The palette is the oxocarbon.nvim one (IBM Carbon): a near-black
;; background, an off-white foreground and pink / teal / blue / purple
;; accents.  The semantic mappings follow oxocarbon.nvim's own highlighting
;; (keywords purple, strings sky-blue, functions green, constants blue,
;; classes pink, variables cyan).

;;; Code:

(require 'ef-themes)

(defconst oxocarbon-dark-palette-partial
  '(
    ;; Structural (IBM Carbon / oxocarbon.nvim)
    (cursor          "#eeffff")
    (bg-main         "#161616")
    (bg-dim          "#1c1c1c")
    (bg-alt          "#262626")
    (fg-main         "#eeffff")
    (fg-dim          "#dde1e6")
    (fg-alt          "#b8bcc2")
    (bg-active       "#393939")
    (bg-inactive     "#262626")
    (border          "#525252")

    ;; Red / pink (oxocarbon.nvim base0A / base0C)
    (red             "#ee5396")
    (red-warmer      "#ff7eb6")
    (red-cooler      "#ee5396")
    (red-faint       "#ff7eb6")

    ;; Green / teal (base0D / base07)
    (green           "#42be65")
    (green-warmer    "#42be65")
    (green-cooler    "#08bdba")
    (green-faint     "#42be65")

    ;; Yellow — oxocarbon.nvim has no yellow; the pink accent carries the
    ;; "warm" warning role (lighter than the deeper error pink).
    (yellow          "#ff7eb6")
    (yellow-warmer   "#ff7eb6")
    (yellow-cooler   "#ee5396")
    (yellow-faint    "#ff7eb6")

    ;; Blue / sky (base09 / base0B)
    (blue            "#78a9ff")
    (blue-warmer     "#33b1ff")
    (blue-cooler     "#78a9ff")
    (blue-faint      "#82cfff")

    ;; Magenta (base0E / base0F)
    (magenta         "#be95ff")
    (magenta-warmer  "#be95ff")
    (magenta-cooler  "#82cfff")
    (magenta-faint   "#be95ff")

    ;; Cyan (base08 / base07)
    (cyan            "#3ddbd9")
    (cyan-warmer     "#08bdba")
    (cyan-cooler     "#3ddbd9")
    (cyan-faint      "#3ddbd9")

    ;; Tinted backgrounds
    (bg-red-intense   "#5a1e3a")
    (bg-green-intense "#1f5230")
    (bg-yellow-intense "#4f2034")
    (bg-blue-intense  "#1f3a6e")
    (bg-magenta-intense "#3a2a5c")
    (bg-cyan-intense  "#1a4a4a")
    (bg-red-subtle    "#3a1226")
    (bg-green-subtle  "#0f3520")
    (bg-yellow-subtle "#341428")
    (bg-blue-subtle   "#16284a")
    (bg-magenta-subtle "#261a3a")
    (bg-cyan-subtle   "#0f3333")
    (bg-red-nuanced   "#26101c")
    (bg-green-nuanced "#0a2618")
    (bg-yellow-nuanced "#200c18")
    (bg-blue-nuanced  "#101c33")
    (bg-magenta-nuanced "#1a1226")
    (bg-cyan-nuanced  "#0a2424")

    ;; Git / diff
    (bg-added         "#0f3520")
    (bg-added-faint   "#0a2818")
    (bg-added-refine  "#1a5230")
    (fg-added         "#42be65")
    (bg-changed       "#341428")
    (bg-changed-faint "#200c18")
    (bg-changed-refine "#4f2034")
    (fg-changed       "#ff7eb6")
    (bg-removed       "#3a1226")
    (bg-removed-faint "#2a0c1a")
    (bg-removed-refine "#5a1e3a")
    (fg-removed       "#ee5396")

    ;; UI
    (bg-mode-line-active "#262626")
    (fg-mode-line-active "#eeffff")
    (bg-completion    "#1f3a6e")
    (bg-popup         "#1c1c1c")
    (bg-hover         "#2a4a46")
    (bg-hover-secondary "#4a3a24")
    (bg-hl-line       "#262626")
    (bg-paren-match   "#1a4a4a")
    (bg-err           "#3a1226")
    (bg-warning       "#341428")
    (bg-info          "#0f3520")
    (bg-region        "#393939")))

(defconst oxocarbon-palette-mappings-partial
  '(
    ;; Error / warning / info — oxocarbon.nvim has no yellow, so warnings
    ;; are the lighter pink and errors the deeper pink.
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

(defcustom oxocarbon-palette-overrides nil
  "Overrides for the `oxocarbon' and `oxocarbon-light' palettes.

Mirror the elements of the aforementioned palettes, overriding their
value.  For overrides shared across all Ef themes refer to
`modus-themes-common-palette-overrides'."
  :group 'ef-themes
  :package-version '(ef-themes . "1.0.0")
  :type '(repeat (list symbol (choice symbol string)))
  :link '(info-link "(ef-themes) Palette overrides"))

(defconst oxocarbon-dark-palette
  (modus-themes-generate-palette
   oxocarbon-dark-palette-partial
   nil
   nil
   (append oxocarbon-palette-mappings-partial ef-themes-palette-common)))

;;;###theme-autoload
(modus-themes-theme
 'oxocarbon
 'ef-themes
 "Oxocarbon — a dark theme derived from the Ef themes with the IBM-Carbon-inspired oxocarbon.nvim palette."
 'dark
 'oxocarbon-dark-palette
 nil
 'oxocarbon-palette-overrides)

(provide 'oxocarbon-theme)

;;; oxocarbon-theme.el ends here
