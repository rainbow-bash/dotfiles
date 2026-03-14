return {
	"tronikelis/ts-autotag.nvim",
	config = function()
		local autotag = require("ts-autotag")
		autotag.setup({
			filetypes = {
				"svelte",
				"typescript",
				"javascript",
				"typescriptreact",
				"javascriptreact",
				"xml",
				"html",
				"templ",
				"php",
			},
		})
	end,
}
