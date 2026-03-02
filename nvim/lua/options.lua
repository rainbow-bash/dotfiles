vim.g.is_cmp_open = false
local autocmd = vim.api.nvim_create_autocmd

-- @returns a "clear = true" augroup
local function augroup(name)
	return vim.api.nvim_create_augroup("sergio-lazyvim_" .. name, { clear = true })
end

autocmd("BufReadPost", {
	group = augroup("restore_position"),
	callback = function()
		local exclude = { "gitcommit" }
		local buf = vim.api.nvim_get_current_buf()
		if vim.tbl_contains(exclude, vim.bo[buf].filetype) then
			return
		end

		local mark = vim.api.nvim_buf_get_mark(buf, '"')
		local line_count = vim.api.nvim_buf_line_count(buf)
		if mark[1] > 0 and mark[1] <= line_count then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
			vim.api.nvim_feedkeys("zvzz", "n", true)
		end
	end,
	desc = "Restore cursor position after reopening file",
})
vim.api.nvim_create_autocmd("VimLeavePre", {
	pattern = "*",
	callback = function()
		if vim.g.savesession then
			vim.api.nvim_command("mks!")
		end
	end,
})
vim.lsp.set_log_level("OFF") -- turn complely off when not during 'debug'
vim.g.mapleader = " "
vim.opt.clipboard = "unnamedplus"
vim.opt.number = true
vim.opt.breakindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.undofile = true
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.wo.relativenumber = true
local tabs = 2
vim.o.tabstop = tabs
vim.o.shiftwidth = tabs
vim.o.softtabstop = tabs
vim.opt.swapfile = false
vim.opt.inccommand = "split"
vim.opt.splitright = true
vim.opt.showmode = false -- We don't need to see things like -- INSERT -- anymore
-- vim.opt.hlsearch = false -- No search highlight
vim.opt.splitbelow = true
vim.g.python_host_prog = "/usr/sbin/python"
-- vim.opt.iskeyword:remove("_") -- Add - to be part of word
vim.g.python3_host_prog = "/usr/sbin/python"
-- python3 -m venv ~/venvs/.nvim-venv && source ~/venvs/.nvim-venv/bin/activate && python3 -m pip install pynvim
vim.diagnostic.enable(false)
vim.api.nvim_set_hl(0, "MiniPickNormal", { bg = "#cf2224", default = true })
vim.opt.sessionoptions = "curdir,folds,globals,help,tabpages,terminal,winsize"
vim.opt.iminsert = 1

local gdproject = io.open(vim.fn.getcwd() .. "/project.godot", "r")
if gdproject then
	io.close(gdproject)
	vim.fn.serverstart("./godothost")
end
