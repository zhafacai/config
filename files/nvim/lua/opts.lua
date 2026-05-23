-- [nfnl] fnl/opts.fnl
if vim.g.neovide then
  vim.g["neovide_opacity"] = 0.8
  vim.g["neovide_floating_blur_amount_x"] = 2
  vim.g["floating_blur_amount_y"] = 2
  vim.g["neovide_fullscreen"] = false
  vim.g["neovide_cursor_animation_length"] = 0.1
  vim.g["neovide_cursor_vfx_mode"] = "ripple"
  vim.opt["guifont"] = "Iosevka SS02:h14"
  vim.opt["scrolloff"] = 0
else
end
vim.g["mapleader"] = " "
vim.g["maplocalleader"] = ","
vim.opt["clipboard"] = "unnamedplus"
vim.opt["completeopt"] = "menuone,noselect"
vim.opt["numberwidth"] = 4
vim.opt["laststatus"] = 3
vim.opt["scrolloff"] = 99
vim.opt["softtabstop"] = 2
vim.opt["tabstop"] = 4
vim.opt["shiftwidth"] = 2
vim.opt["conceallevel"] = 2
vim.opt["whichwrap"] = "h,l"
vim.opt["cmdheight"] = 1
vim.opt["virtualedit"] = "block"
vim.opt["timeoutlen"] = 500
vim.opt["foldlevel"] = 99
vim.opt["foldlevelstart"] = 99
vim.opt["splitkeep"] = "screen"
vim.opt["foldcolumn"] = "1"
vim.opt["jumpoptions"] = "stack"
vim.opt["foldmethod"] = "expr"
vim.opt["foldexpr"] = "nvim_treesitter#foldexpr"
vim.opt["showbreak"] = "  \243\176\152\141"
vim.opt["shell"] = "fish"
vim.opt["shellcmdflag"] = "-c"
vim.opt["shellredir"] = "| save %s"
vim.opt["updatetime"] = 300
vim.opt["mouse"] = "a"
vim.opt["listchars"] = {tab = "\194\187 ", nbsp = "\226\144\163", trail = "\226\128\162"}
vim.opt["guicursor"] = "n-v-sm:block,i-c-ci-ve:ver25,r-cr-o:hor20"
vim.opt["fillchars"] = {vert = "\226\149\145", horiz = "\226\149\144", horizup = "\226\149\169", horizdown = "\226\149\166", vertleft = "\226\149\163", vertright = "\226\149\160", verthoriz = "\226\149\172", foldopen = "\239\145\188", foldclose = "\239\145\160"}
vim.opt.formatoptions:append("r")
vim.opt.shortmess:append({I = true, r = true})
vim.opt.wildignore:append("**/nvim/runtime/colors/*")
vim.opt.diffopt:append("linematch:60")
vim.opt["undofile"] = true
vim.opt["list"] = true
vim.opt["wildignorecase"] = true
vim.opt["ignorecase"] = true
vim.opt["smartcase"] = true
vim.opt["linebreak"] = true
vim.opt["expandtab"] = true
vim.opt["smartindent"] = true
vim.opt["breakindent"] = true
vim.opt["confirm"] = true
vim.opt["title"] = true
vim.opt["splitbelow"] = true
vim.opt["splitright"] = true
vim.opt["termguicolors"] = true
vim.opt["timeout"] = true
vim.opt["exrc"] = true
vim.opt["ruler"] = false
vim.opt["equalalways"] = false
vim.opt["swapfile"] = false
vim.opt["writebackup"] = false
vim.opt["cursorline"] = false
vim.opt["showmode"] = false
return nil
