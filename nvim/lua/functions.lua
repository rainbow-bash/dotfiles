-- TODO: (marcig)
function navigate_lists(arg)
	return function()
		if arg == "n" then
			pcall(vim.cmd, "lnext")
			pcall(vim.cmd, "cn")
		else
			pcall(vim.cmd, "lprev")
			pcall(vim.cmd, "cp")
		end
	end
end

function SaveAll()
	local name = vim.fn.expand("%")
	print(name)
	if name.len == 0 then
		return
	end
	local ext = vim.fn.expand("%:e")
	if ext == "ts" or ext == "tsx" then
		-- local ok, _ = pcall(vim.cmd, "TSToolsAddMissingImports")

		-- if ok == false then
		-- 	print("failed to add missing imports")
		-- end

		-- ok, _ = pcall(vim.cmd, "TSToolsOrganizeImports")
		-- if ok == false then
		-- 	print("failed to organize imports")
		-- end

		ok, _ = pcall(vim.cmd, "wa")
		if ok then
			print("saved files :3")
		end
	else
		if ext == "go" then
			local ok, _ = pcall(vim.cmd, "GoImports")
			if ok then
				print("imported files and saved")
			end
		else
			ok, _ = pcall(vim.cmd, "wa")
			if ok then
				print("saved files :3")
			end
		end
	end
end

function InsertPrint()
	local og_cursor = vim.api.nvim_win_get_cursor(0)
	local pos = vim.api.nvim_win_get_cursor(0)[2]
	local line = vim.api.nvim_get_current_line()
	local ext = vim.fn.expand("%:e")
	local text = "console.log()"
	local jump = 0
	if ext == "c" then
		text = "printf();"
		jump = -1
	elseif ext == "lua" then
		text = "print()"
	elseif ext == "go" then
		text = "fmt.Println()"
	elseif ext == "odin" then
		text = "fmt.println()"
	elseif ext == "py" then
		text = "print()"
	elseif ext == "ts" or ext == "js" or ext == "html" or ext == "svelte" then
		text = "console.log()"
	end

	jump = jump + string.len(text) - 1
	local nline = line:sub(0, pos) .. text .. line:sub(pos + 1)
	vim.api.nvim_set_current_line(nline)
	og_cursor[2] = og_cursor[2] + jump
	vim.api.nvim_win_set_cursor(0, og_cursor)
end

function HotToGo()
	local current_win = vim.api.nvim_get_current_win()
	local current_buf = vim.api.nvim_get_current_buf()
	local cursor_pos = vim.api.nvim_win_get_cursor(current_win)
	vim.cmd.wincmd("w")
	vim.api.nvim_win_set_buf(0, current_buf)
	vim.api.nvim_win_set_cursor(0, cursor_pos)
	vim.lsp.buf.definition()
end

function IsCurrWindowThatOne(wname)
	for _, win in pairs(vim.fn.getwininfo()) do
		if win[wname] == 1 then
			return true
		end
	end
	return false
end

function IsQflOrLocBuf()
	return IsCurrWindowThatOne("loclist") and IsCurrWindowThatOne("quickfix")
end

function named_window_exists(name)
	for _, win in pairs(vim.fn.getwininfo()) do
		if win[name] == 1 then
			return true
		end
	end
	return false
end

function CompilerModeChafoide()
	if not IsQflOrLocBuf() then
		SaveAll()
	end

	pcall(vim.cmd, "ccl")
	local ext = vim.fn.expand("%:e")
	local filename = vim.fn.expand("%")
	local og_cursor = vim.api.nvim_win_get_cursor(0)
	local is_loc_list = named_window_exists("loclist")

	if is_loc_list or ext == "ts" or ext == "tsx" or ext == "js" or ext == "jsx" then
		vim.diagnostic.setloclist({ open = false })
		vim.cmd("botright 10lopen")
	elseif ext == "svelte" then
		vim.cmd("SvelteCheck")
	else
		local results
		if string.find(filename, "test") ~= nil then
			pcall(vim.cmd, "silent make test")
		elseif ext == "rs" then
			pcall(vim.cmd, "silent make rustc")
		else
			pcall(vim.cmd, "silent make compile")
		end
		local qf = vim.fn.getqflist()
		pcall(vim.cmd, "ccl")
		if #qf > 0 then
			pcall(vim.cmd, "botright 10copen")
			pcall(vim.cmd, "cfirst")
			pcall(vim.cmd, "cn")
			print("compilation errors unu")
		else
			pcall(vim.cmd, "cclose")
			pcall(vim.api.nvim_win_set_cursor, 0, og_cursor)
			print("compiled succesfully:3")
		end
	end
end

function GDLVBreak()
	local current_win = vim.api.nvim_get_current_win()
	local path = vim.api.nvim_buf_get_name(0)
	local cursor_pos = vim.api.nvim_win_get_cursor(current_win)
	local debugger_path = path .. ":" .. cursor_pos[1]
	vim.fn.setreg("+", debugger_path)
end

---@param p snacks.Picker
function GetSnacksPickerPrompt(p)
	local source = p.opts.source

	if source == "grep" then
		current = p.input.filter.search
	else
		current = p.input.filter.pattern
		print(source)
	end

	return current
end

function GetParentPath(path)
	local pattern1 = ".*/"
	pattern2 = "^(.+)\\"

	if string.match(path, pattern1) == nil then
		return string.match(path, pattern2)
	else
		return string.match(path, pattern1)
	end
end

function FindDelim()
	local line = vim.api.nvim_get_current_line()
	local delim_pattern = "[(){}<>.,;:%[%]]"
	return line:match(delim_pattern) or "<esc>"
end

function PrintObj(obj, hierarchyLevel)
	if hierarchyLevel == nil then
		hierarchyLevel = 0
	elseif hierarchyLevel == 4 then
		return 0
	end
	local whitespace = ""
	for i = 0, hierarchyLevel, 1 do
		whitespace = whitespace .. "-"
	end
	io.write(whitespace)
	print(obj)
	if type(obj) == "table" then
		for k, v in pairs(obj) do
			io.write(whitespace .. "-")
			if type(v) == "table" then
				PrintObj(v, hierarchyLevel + 1)
			else
				print(v)
			end
		end
	else
		print(obj)
	end
end

function Emacmds(cmd_bufname)
	local height = vim.api.nvim_win_get_height(0)
	local bufname = vim.api.nvim_buf_get_name(0)
	local wins = vim.api.nvim_list_wins()
	for key, value in pairs(wins) do
		local wname = vim.fn.wingetinfo(value)
		print(wname)
	end
	if height >= 48 then
		pcall(vim.cmd, "wincmd s")
	else
		-- if one of the wins already has a
		vim.api.nvim_set_current_win()
	end
	if cmd_bufname ~= bufname then
		pcall(vim.cmd, "n _____output_____.sh")
	end
	pcall(vim.cmd, "%d")
	vim.api.nvim_input(":r! ")
end
