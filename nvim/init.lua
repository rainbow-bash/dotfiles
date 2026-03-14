require("config.lazy")
require("mappings")
require("options")
vim.cmd.colorscheme("vague")
vim.lsp.config("gdscript", {})
vim.lsp.enable({ "gdscript" })
-- vim.cmd("TSEnable highlight")
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "svelte", "go", "ts", "tsx", "odin", "c", "lua", "rs" },
	callback = function()
		vim.treesitter.start()
	end,
})

print("nya init")
