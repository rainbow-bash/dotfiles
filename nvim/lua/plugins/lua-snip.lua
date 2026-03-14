return {
	"L3MON4D3/LuaSnip",
	-- follow latest release.
	version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	-- install jsregexp (optional!).
	build = "make install_jsregexp",
}
--return {
--	"L3MON4D3/LuaSnip",
--	version = "v2.*",
--	dependencies = {
--		"hrsh7th/nvim-cmp",
--		"rafamadriz/friendly-snippets",
--		"mlaursen/vim-react-snippets",
--	},
--	config = function()
--		require("vim-react-snippets").lazy_load()
--		local luasnip = require("luasnip")
--	end,
--	---@type LazyKeysSpec[]
--	keys = {
--		{ "<tab>", mode = { "i", "s" }, false },
--		{ "<s-tab>", mode = { "i", "s" }, false },
--		{
--			"<C-Space>",
--			mode = { "i", "s" },
--			function()
--				local ls = require("luasnip")
--				-- need to call ls.expandable() first so that any "cached" snippet is
--				-- correctly refreshed
--				if ls.expandable() then
--					ls.expand({})
--				end
--			end,
--		},
--	},
--}
