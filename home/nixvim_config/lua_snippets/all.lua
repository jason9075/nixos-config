-- Generated using ultisnips_to_luasnip.py

local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet
local k = require("luasnip.nodes.key_indexer").new_key

local io = require("io")

local ls = require("luasnip")
local util = require("luasnip.util.util")
local events = require("luasnip.util.events")
local f = ls.function_node
local t = ls.text_node
local k = require("luasnip.nodes.key_indexer").new_key
local rundir = debug.getinfo(1).source:match("@?(.*/)")

local python_helper_loaded = false


local filetype_includes = {}
local filetype_mapping_fp = io.open(rundir .. '../filetype_includes.txt')
if filetype_mapping_fp ~= nil then
	while true do
		local line = filetype_mapping_fp:read('*line')
		if line == nil then
			break
		end
		filetype = nil
		aliases = {}
		for word in line:gmatch("[^%s]+") do
			if filetype == nil then
				filetype = word
			else
				table.insert(aliases, word)
			end
		end
		if filetype ~= nil then
			filetype_includes[filetype] = aliases
		end
	end
	filetype_mapping_fp:close()
end

local function script_path()
	local str = debug.getinfo(2, "S").source:sub(2)
	return str:match("(.*/)") .. '../'
end

local function copy_helper(args)
	return args[1]
end

-- Copy node
local function copy(num)
	return f(copy_helper, k('i' .. num))
end

-- Join text
local function join_text(args, indent)
	local parts = {}
	for i, part in ipairs(args) do
		if type(part) == 'table' then
			part = table.concat(part, '\n')
		end
		table.insert(parts, part)
	end

	local text = table.concat(parts)
	local lines = {}

	if indent == nil then
		indent = ''
	end

	local line_num = 1
	for line in text:gmatch("[^\r\n]+") do
		if line_num == 1 then
			table.insert(lines, line)
		else
			table.insert(lines, indent .. line)
		end
		line_num = line_num + 1
	end

	return lines
end


-- Transform node
local function transform(num, search, replace)
	local jsregexp_ok, jsregexp = pcall(require, "luasnip-jsregexp")
	if jsregexp_ok then
		search = jsregexp.compile(search)
	else
		search = nil
	end

	local function transform_helper(args)
		if search then
			return join_text({search:replace(table.concat(args[1]), replace)})
		else
			return args[1]
		end
	end

	return f(transform_helper, k('i' .. num))
end

local function regex_transform(text, search, replace)
	local jsregexp_ok, jsregexp = pcall(require, "luasnip-jsregexp")
	if jsregexp_ok then
		search = jsregexp.compile(search)
	else
		search = nil
	end

	if search then
		return join_text({search:replace(table.concat(text), replace)})
	else
		return text
	end
end

-- New line
local new_line = function() return t{"", ""} end

local function ft_func(num)
	return vim.split(vim.bo.filetype, ".", true)
end

local function vis()
	return f(function(_, snip)
		return snip.env.TM_SELECTED_TEXT[1] or {}
	end, {})
end

local function split_at_whitespace(text)
	local words = {}
	local position = 1
	for space in string.gmatch(text, '()%s') do
		table.insert(words, string.sub(text, position, space - 1))
		position = space + 1
	end
	table.insert(words, string.sub(text, position))

	return words
end

function arrays_equal(a, b)
	if #a ~= #b then
		return false
	end

	for i = 1, #a do
		if a[i] ~= b[i] then
			return false
		end
	end

	return true
end

function str_strip(s, chars)
	return string.gsub(s, '^[%s]*(.-)[%s]*$', '%1')
end


local function words_for_line(trigger, before, num_words)
	-- Gets the final 'num_words' words from 'before'.
	-- If num_words is nil, then use the number of words in 'trigger'.
	if num_words == nil then
		num_words = #split_at_whitespace(trigger)
	end

	word_list = split_at_whitespace(before)
	if #word_list <= num_words then
		return str_strip(before)
	else
		local before_words = before:reverse()
		for i = 1, num_words do
			local left = before_words:find(word_list[#word_list - i + 1]:reverse(), 1, true)
			if left then
				before_words = before_words:sub(#word_list[#word_list - i + 1] + left)
			end
		end
		return str_strip(before:sub(#before_words + 1))
	end
end


local function is_keyword_char(char)
	local is_keyword = vim.fn.search("\\<" .. char .. "\\>", "nw")
	return is_keyword ~= 0
end


local regex_matchers = {}
local match_context = {}


function remove_named_regex_groups(py_regex)
	local named_group_pattern = "%(%?P<%w+>(.-)%)"
	return py_regex:gsub(named_group_pattern, "(%1)")
end


local function trig_engine(opts)
	local function engine(trigger)
		local function matcher(line_to_cursor, trigger)
			match_context = {}
			--local trigger_words = split_at_whitespace(trigger)
			local words = words_for_line(trigger, line_to_cursor)
			local matched = nil
			local first_char = 0
			local last_char = 0

			if opts:find('r') ~= nil then
				local rx = regex_matchers[trigger]
				if rx == nil then
					local jsregexp_ok, jsregexp = pcall(require, "luasnip-jsregexp")
					if jsregexp_ok then
						rx = jsregexp.compile(remove_named_regex_groups(trigger))
						regex_matchers[trigger] = rx
					end
				end
				if rx ~= nil then
					local matches = rx(line_to_cursor)
					for i, match in ipairs(matches) do
						if match.end_ind == #line_to_cursor then
							matched = line_to_cursor:sub(match.begin_ind, match.end_ind)
							first_char = match.begin_ind
							last_char = match.end_ind
							match_context = {regex=trigger, line=line_to_cursor}
						end
					end
				end
			elseif opts:find('w') ~= nil then
				local words_len = #trigger
				local words_prefix = string.sub(words, 1, -words_len - 1)
				local words_suffix = string.sub(words, -words_len)
				local match = words_suffix == trigger
				if match and #words_prefix > 0 then
					match = vim.fn.match(string.sub(words_prefix, -1), '\\k') == -1
				end

				if match then
					matched = trigger
					first_char = #line_to_cursor - line_to_cursor:reverse():find(trigger:reverse(), 1, true) - #trigger
					last_char = first_char + #trigger
				end
			elseif opts:find("i") ~= nil then
				local match = words:sub(-#trigger) == trigger
				if match then
					matched = trigger
					last_char = #line_to_cursor
					first_char = last_char - #trigger
				end
			else
				local match = words == trigger
				if match then
					matched = trigger
					last_char = #line_to_cursor - line_to_cursor:reverse():find(trigger:reverse(), 1, true) + 1
					first_char = last_char - #trigger
				end
			end

			-- only on beginning of line or only whitespace before trigger
			if matched ~= nil and opts:find('b') ~= nil then
				local content_before_trigger = line_to_cursor:gsub("%s*$", ""):sub(1, -string.len(matched) - 1)
				if content_before_trigger:gsub("[%s\t]+", "") ~= '' then
					match_context = {}
					return nil
				end
			end

			if matched ~= nil then
				return matched, {first_char, last_char}
			end
		end
		return matcher
	end
	return engine
end

local load_ft_func_base = require("luasnip.extras.filetype_functions").extend_load_ft(filetype_includes)
local function load_ft_func(bufnr)
	local res = load_ft_func_base(bufnr)
	vim.list_extend(res, filetype_includes['all'])
	return res
end

local function load_python_helper()
	if not python_helper_loaded then
		python_helper_loaded = true
		vim.cmd('python3 import luasnip_snippets_python_helper')
	end
end

local function call_python(python_function_name, opts)
	load_python_helper()
	vim.g.snip_utils_kwargs = opts
	local result = vim.fn.py3eval('luasnip_snippets_python_helper.' .. python_function_name .. '(**(__import__("vim").vars.get("snip_utils_kwargs", {})))')
	vim.g.snip_utils_kwargs = nil
	return result
end

local function code_python(id, node_code, global_code, args, snip, indent, tabstops_idx)
	while snip.parent do
		snip = snip.parent
	end
	local ctx = {}
	for k, v in pairs(match_context) do
		ctx[k] = v
	end
	local position = vim.api.nvim_win_get_cursor(0)
	ctx['start'] = {position[1], position[2] + 1}
	return call_python("execute_code", {node_id=id, node_code=node_code, global_code=global_code or {}, tabstops=args, env=snip.env or {}, indent=indent, match_context=ctx, tabstops_idx=tabstops_idx})
end

local function code_viml(code)
	return join_text({vim.api.nvim_eval(code), ''})
end

-- Remove new line at end of the string
local function chomp(string)
	if string:sub(-1) == "\n" then
		string = string:sub(1, -2)
	end
	if string:sub(-1) == "\r" then
		string = string:sub(1, -2)
	end
	return string
end


local function run_shell_command(cmd)
	local handle = io.popen(cmd, 'r')
	local output = handle:read("*a")
	handle:close()
	return chomp(output)
end


local function code_shell(code)
	return join_text({run_shell_command(code)})
end


local function setup()
	if vim.g.snips_email == nil then vim.g.snips_email = 'yourname@email.com' end
	if vim.g.snips_github == nil then vim.g.snips_github = 'https://github.com/yourname' end
	if vim.g.snips_company == nil then vim.g.snips_company = 'company' end

	local ls = require('luasnip')
	local module_path = script_path()
	require("luasnip.loaders.from_lua").lazy_load({
		paths = { vim.fn.stdpath("config") .. "/lua/luasnip_snippets", module_path }
	})

	for filetype, extends in pairs(filetype_includes) do
		ls.filetype_extend(filetype, extends)
	end
end


local action_node_context = {}


local function make_actions(actions, max_placeholder)
	-- actions: pre_expand, post_expand, jump
	local callbacks = {}
	callbacks[-1] = {
		[events.pre_expand] = function(snippet, event_args)
			action_node_context[snippet.id] = { index = 0 }
		end
	}

	local function on_enter(index)
		return function(snippet, event_args)
			local main = snippet
			while main.id == nil and main.parent do
				main = main.parent
			end
			local previous_index = action_node_context[main.id].index
			action_node_context[main.id].index = index
		end
	end

	for i = 1, max_placeholder do
		callbacks[i] = {
			[events.enter] = on_enter(i)
		}
	end
	return {callbacks=callbacks}
end


local cp = copy
local tr = transform
local rx_tr = regex_transform
local jt = join_text
local nl = new_line
local te = trig_engine
local c_py = code_python
local c_viml = code_viml
local c_shell = code_shell
local make_actions = make_actions
ls.add_snippets("all", {
	s({ trig = "c)", descr = "(c))", priority = -1000, trigEngine = te("w") }, {
		t("Copyright "),
		f(function(args, snip)
			return c_viml('&enc[:2] == "utf" ? "©" : "(c)"')
		end),
		t(" "),
		f(function(args, snip)
			return c_viml('strftime("%Y")')
		end),
		t(" "),
		t(". All Rights Reserved."),
	}),
	s({ trig = "date", descr = '(date) "YYYY-MM-DD"', priority = -60, trigEngine = te("w") }, {
		f(function(args, snip)
			return c_viml('strftime("%Y-%m-%d")')
		end),
	}),
	s({ trig = "ddate", descr = '(ddate) "Month DD, YYYY"', priority = -60, trigEngine = te("w") }, {
		f(function(args, snip)
			return c_viml('strftime("%b %d, %Y")')
		end),
	}),
	s({ trig = "diso", descr = '(diso) "ISO format datetime"', priority = -60, trigEngine = te("w") }, {
		f(function(args, snip)
			return c_viml('strftime("%Y-%m-%d %H:%M:%S%z")')
		end),
	}),
	s({ trig = "time", descr = '(time) "hh:mm"', priority = -60, trigEngine = te("w") }, {
		f(function(args, snip)
			return c_viml('strftime("%H:%M")')
		end),
	}),
	s({ trig = "datetime", descr = '(datetime) "YYYY-MM-DD hh:mm"', priority = -60, trigEngine = te("w") }, {
		f(function(args, snip)
			return c_viml('strftime("%Y-%m-%d %H:%M")')
		end),
	}),
	s({ trig = "lorem", descr = "(lorem)", priority = -1000, trigEngine = te("w") }, {
		t(
			"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
		),
	}),
	s({ trig = "GPL2", descr = "(GPL2)", priority = -1000, trigEngine = te("w") }, {
		i(1, "One line to give the program's name and a brief description.", { key = "i1" }),
		nl(),
		t("Copyright "),
		f(function(args, snip)
			return c_viml('&enc[:2] == "utf" ? "©" : "(c)"')
		end),
		t(" "),
		f(function(args, snip)
			return c_viml('strftime("%Y")')
		end),
		t(" "),
		nl(),
		nl(),
		t("This program is free software; you can redistribute it and/or modify"),
		nl(),
		t("it under the terms of the GNU General Public License as published by"),
		nl(),
		t("the Free Software Foundation; either version 2 of the License, or"),
		nl(),
		t("(at your option) any later version."),
		nl(),
		nl(),
		t("This program is distributed in the hope that it will be useful,"),
		nl(),
		t("but WITHOUT ANY WARRANTY; without even the implied warranty of"),
		nl(),
		t("MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the"),
		nl(),
		t("GNU General Public License for more details."),
		nl(),
		nl(),
		t("You should have received a copy of the GNU General Public License"),
		nl(),
		t("along with this program; if not, see <http://www.gnu.org/licenses/>."),
		nl(),
		i(0, "", { key = "i0" }),
	}),
	s({ trig = "LGPL2", descr = "(LGPL2)", priority = -1000, trigEngine = te("w") }, {
		i(1, "One line to give the program's name and a brief description.", { key = "i1" }),
		nl(),
		t("Copyright "),
		f(function(args, snip)
			return c_viml('&enc[:2] == "utf" ? "©" : "(c)"')
		end),
		t(" "),
		f(function(args, snip)
			return c_viml('strftime("%Y")')
		end),
		t(" "),
		nl(),
		nl(),
		t("This library is free software; you can redistribute it and/or modify"),
		nl(),
		t("it under the terms of the GNU Lesser General Public License as published"),
		nl(),
		t("by the Free Software Foundation; either version 2.1 of the License, or"),
		nl(),
		t("(at your option) any later version."),
		nl(),
		nl(),
		t("This library is distributed in the hope that it will be useful,"),
		nl(),
		t("but WITHOUT ANY WARRANTY; without even the implied warranty of"),
		nl(),
		t("MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the"),
		nl(),
		t("GNU Lesser General Public License for more details."),
		nl(),
		nl(),
		t("You should have received a copy of the GNU Lesser General Public License"),
		nl(),
		t("along with this library; if not, see <http://www.gnu.org/licenses/>."),
		nl(),
		i(0, "", { key = "i0" }),
	}),
	s({ trig = "GPL3", descr = "(GPL3)", priority = -1000, trigEngine = te("w") }, {
		i(1, "one line to give the program's name and a brief description.", { key = "i1" }),
		nl(),
		t("Copyright "),
		f(function(args, snip)
			return c_viml('&enc[:2] == "utf" ? "©" : "(c)"')
		end),
		t(" "),
		f(function(args, snip)
			return c_viml('strftime("%Y")')
		end),
		t(" "),
		nl(),
		nl(),
		t("This program is free software: you can redistribute it and/or modify"),
		nl(),
		t("it under the terms of the GNU General Public License as published by"),
		nl(),
		t("the Free Software Foundation, either version 3 of the License, or"),
		nl(),
		t("(at your option) any later version."),
		nl(),
		nl(),
		t("This program is distributed in the hope that it will be useful,"),
		nl(),
		t("but WITHOUT ANY WARRANTY; without even the implied warranty of"),
		nl(),
		t("MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the"),
		nl(),
		t("GNU General Public License for more details."),
		nl(),
		nl(),
		t("You should have received a copy of the GNU General Public License"),
		nl(),
		t("along with this program.  If not, see <http://www.gnu.org/licenses/>."),
		nl(),
		i(0, "", { key = "i0" }),
	}),
	s({ trig = "LGPL3", descr = "(LGPL3)", priority = -1000, trigEngine = te("w") }, {
		i(1, "One line to give the program's name and a brief description.", { key = "i1" }),
		nl(),
		t("Copyright "),
		f(function(args, snip)
			return c_viml('&enc[:2] == "utf" ? "©" : "(c)"')
		end),
		t(" "),
		f(function(args, snip)
			return c_viml('strftime("%Y")')
		end),
		t(" "),
		nl(),
		nl(),
		t("This library is free software; you can redistribute it and/or modify"),
		nl(),
		t("it under the terms of the GNU Lesser General Public License as published"),
		nl(),
		t("by the Free Software Foundation; either version 3 of the License, or"),
		nl(),
		t("(at your option) any later version."),
		nl(),
		nl(),
		t("This library is distributed in the hope that it will be useful,"),
		nl(),
		t("but WITHOUT ANY WARRANTY; without even the implied warranty of"),
		nl(),
		t("MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the"),
		nl(),
		t("GNU Lesser General Public License for more details."),
		nl(),
		nl(),
		t("You should have received a copy of the GNU Lesser General Public License"),
		nl(),
		t("along with this library; if not, see <http://www.gnu.org/licenses/>."),
		nl(),
		i(0, "", { key = "i0" }),
	}),
	s({ trig = "AGPL3", descr = "(AGPL3)", priority = -1000, trigEngine = te("w") }, {
		i(1, "one line to give the program's name and a brief description.", { key = "i1" }),
		nl(),
		t("Copyright "),
		f(function(args, snip)
			return c_viml('&enc[:2] == "utf" ? "©" : "(c)"')
		end),
		t(" "),
		f(function(args, snip)
			return c_viml('strftime("%Y")')
		end),
		t(" "),
		nl(),
		nl(),
		t("This program is free software: you can redistribute it and/or modify"),
		nl(),
		t("it under the terms of the GNU Affero General Public License as"),
		nl(),
		t("published by the Free Software Foundation, either version 3 of the"),
		nl(),
		t("License, or (at your option) any later version."),
		nl(),
		nl(),
		t("This program is distributed in the hope that it will be useful,"),
		nl(),
		t("but WITHOUT ANY WARRANTY; without even the implied warranty of"),
		nl(),
		t("MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the"),
		nl(),
		t("GNU Affero General Public License for more details."),
		nl(),
		nl(),
		t("You should have received a copy of the GNU Affero General Public License"),
		nl(),
		t("along with this program.  If not, see <http://www.gnu.org/licenses/>."),
		nl(),
		i(0, "", { key = "i0" }),
	}),
	s({ trig = "GMGPL", descr = "(GMGPL) linking exception", priority = -1000, trigEngine = te("w") }, {
		t("As a special exception, if other files instantiate generics from"),
		nl(),
		t("this unit, or you link this unit with other files to produce an"),
		nl(),
		t("executable, this unit does not by itself cause the resulting"),
		nl(),
		t("executable to be covered by the GNU General Public License."),
		nl(),
		t("This exception does not however invalidate any other reasons why the"),
		nl(),
		t("executable file might be covered by the GNU Public License."),
		nl(),
		nl(),
		i(0, "", { key = "i0" }),
	}),
	s({ trig = "BSD2", descr = "(BSD2)", priority = -1000, trigEngine = te("w") }, {
		i(1, "one line to give the program's name and a brief description", { key = "i1" }),
		nl(),
		t("Copyright "),
		f(function(args, snip)
			return c_viml('&enc[:2] == "utf" ? "©" : "(c)"')
		end),
		t(" "),
		f(function(args, snip)
			return c_viml('strftime("%Y")')
		end),
		t(" "),
		nl(),
		t("All rights reserved."),
		nl(),
		nl(),
		t("Redistribution and use in source and binary forms, with or without"),
		nl(),
		t("modification, are permitted provided that the following conditions are met:"),
		nl(),
		t("1. Redistributions of source code must retain the above copyright"),
		nl(),
		t("notice, this list of conditions and the following disclaimer."),
		nl(),
		t("2. Redistributions in binary form must reproduce the above copyright"),
		nl(),
		t("notice, this list of conditions and the following disclaimer in the"),
		nl(),
		t("documentation and/or other materials provided with the distribution."),
		nl(),
		nl(),
		t("THIS SOFTWARE IS PROVIDED BY "),
		cp(2),
		t(" ''AS IS'' AND ANY"),
		nl(),
		t("EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED"),
		nl(),
		t("WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE"),
		nl(),
		t("DISCLAIMED. IN NO EVENT SHALL "),
		cp(2),
		t(" BE LIABLE FOR ANY"),
		nl(),
		t("DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES"),
		nl(),
		t("(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;"),
		nl(),
		t("LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND"),
		nl(),
		t("ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT"),
		nl(),
		t("(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS"),
		nl(),
		t("SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."),
		nl(),
		nl(),
		t("The views and conclusions contained in the software and documentation"),
		nl(),
		t("are those of the authors and should not be interpreted as representing"),
		nl(),
		t("official policies, either expressed or implied, of "),
		cp(2),
		t("."),
		nl(),
		i(0, "", { key = "i0" }),
	}),
	s({ trig = "BSD3", descr = "(BSD3)", priority = -1000, trigEngine = te("w") }, {
		i(1, "one line to give the program's name and a brief description", { key = "i1" }),
		nl(),
		t("Copyright "),
		f(function(args, snip)
			return c_viml('&enc[:2] == "utf" ? "©" : "(c)"')
		end),
		t(" "),
		f(function(args, snip)
			return c_viml('strftime("%Y")')
		end),
		t(" "),
		nl(),
		t("All rights reserved."),
		nl(),
		nl(),
		t("Redistribution and use in source and binary forms, with or without"),
		nl(),
		t("modification, are permitted provided that the following conditions are met:"),
		nl(),
		t("1. Redistributions of source code must retain the above copyright"),
		nl(),
		t("notice, this list of conditions and the following disclaimer."),
		nl(),
		t("2. Redistributions in binary form must reproduce the above copyright"),
		nl(),
		t("notice, this list of conditions and the following disclaimer in the"),
		nl(),
		t("documentation and/or other materials provided with the distribution."),
		nl(),
		t("3. Neither the name of the "),
		i(3, "organization", { key = "i3" }),
		t(" nor the"),
		nl(),
		t("names of its contributors may be used to endorse or promote products"),
		nl(),
		t("derived from this software without specific prior written permission."),
		nl(),
		nl(),
		t("THIS SOFTWARE IS PROVIDED BY "),
		cp(2),
		t(" ''AS IS'' AND ANY"),
		nl(),
		t("EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED"),
		nl(),
		t("WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE"),
		nl(),
		t("DISCLAIMED. IN NO EVENT SHALL "),
		cp(2),
		t(" BE LIABLE FOR ANY"),
		nl(),
		t("DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES"),
		nl(),
		t("(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;"),
		nl(),
		t("LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND"),
		nl(),
		t("ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT"),
		nl(),
		t("(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS"),
		nl(),
		t("SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."),
		nl(),
		i(0, "", { key = "i0" }),
	}),
	s({ trig = "BSD4", descr = "(BSD4)", priority = -1000, trigEngine = te("w") }, {
		i(1, "one line to give the program's name and a brief description", { key = "i1" }),
		nl(),
		t("Copyright "),
		f(function(args, snip)
			return c_viml('&enc[:2] == "utf" ? "©" : "(c)"')
		end),
		t(" "),
		f(function(args, snip)
			return c_viml('strftime("%Y")')
		end),
		t(" "),
		nl(),
		t("All rights reserved."),
		nl(),
		nl(),
		t("Redistribution and use in source and binary forms, with or without"),
		nl(),
		t("modification, are permitted provided that the following conditions are met:"),
		nl(),
		t("1. Redistributions of source code must retain the above copyright"),
		nl(),
		t("notice, this list of conditions and the following disclaimer."),
		nl(),
		t("2. Redistributions in binary form must reproduce the above copyright"),
		nl(),
		t("notice, this list of conditions and the following disclaimer in the"),
		nl(),
		t("documentation and/or other materials provided with the distribution."),
		nl(),
		t("3. All advertising materials mentioning features or use of this software"),
		nl(),
		t("must display the following acknowledgement:"),
		nl(),
		t("This product includes software developed by the "),
		i(3, "organization", { key = "i3" }),
		t("."),
		nl(),
		t("4. Neither the name of the "),
		cp(3),
		t(" nor the"),
		nl(),
		t("names of its contributors may be used to endorse or promote products"),
		nl(),
		t("derived from this software without specific prior written permission."),
		nl(),
		nl(),
		t("THIS SOFTWARE IS PROVIDED BY "),
		cp(2),
		t(" ''AS IS'' AND ANY"),
		nl(),
		t("EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED"),
		nl(),
		t("WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE"),
		nl(),
		t("DISCLAIMED. IN NO EVENT SHALL "),
		cp(2),
		t(" BE LIABLE FOR ANY"),
		nl(),
		t("DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES"),
		nl(),
		t("(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;"),
		nl(),
		t("LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND"),
		nl(),
		t("ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT"),
		nl(),
		t("(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS"),
		nl(),
		t("SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."),
		nl(),
		i(0, "", { key = "i0" }),
	}),
	s({ trig = "MIT", descr = "(MIT)", priority = -1000, trigEngine = te("w") }, {
		i(1, "one line to give the program's name and a brief description", { key = "i1" }),
		nl(),
		t("Copyright "),
		f(function(args, snip)
			return c_viml('&enc[:2] == "utf" ? "©" : "(c)"')
		end),
		t(" "),
		f(function(args, snip)
			return c_viml('strftime("%Y")')
		end),
		t(" "),
		nl(),
		nl(),
		t("Permission is hereby granted, free of charge, to any person obtaining"),
		nl(),
		t('a copy of this software and associated documentation files (the "Software"),'),
		nl(),
		t("to deal in the Software without restriction, including without limitation"),
		nl(),
		t("the rights to use, copy, modify, merge, publish, distribute, sublicense,"),
		nl(),
		t("and/or sell copies of the Software, and to permit persons to whom the"),
		nl(),
		t("Software is furnished to do so, subject to the following conditions:"),
		nl(),
		nl(),
		t("The above copyright notice and this permission notice shall be included"),
		nl(),
		t("in all copies or substantial portions of the Software."),
		nl(),
		nl(),
		t('THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,'),
		nl(),
		t("EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES"),
		nl(),
		t("OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT."),
		nl(),
		t("IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,"),
		nl(),
		t("DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,"),
		nl(),
		t("TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE"),
		nl(),
		t("OR THE USE OR OTHER DEALINGS IN THE SOFTWARE."),
		nl(),
		i(0, "", { key = "i0" }),
	}),
	s({ trig = "APACHE", descr = "(APACHE)", priority = -1000, trigEngine = te("w") }, {
		i(1, "one line to give the program's name and a brief description", { key = "i1" }),
		nl(),
		t("Copyright "),
		f(function(args, snip)
			return c_viml('strftime("%Y")')
		end),
		t(" "),
		nl(),
		nl(),
		t('Licensed under the Apache License, Version 2.0 (the "License");'),
		nl(),
		t("you may not use this file except in compliance with the License."),
		nl(),
		t("You may obtain a copy of the License at"),
		nl(),
		nl(),
		t("\thttp://www.apache.org/licenses/LICENSE-2.0"),
		nl(),
		nl(),
		t("Unless required by applicable law or agreed to in writing, software"),
		nl(),
		t('distributed under the License is distributed on an "AS IS" BASIS,'),
		nl(),
		t("WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied."),
		nl(),
		t("See the License for the specific language governing permissions and"),
		nl(),
		t("limitations under the License."),
		nl(),
		i(0, "", { key = "i0" }),
	}),
	s({ trig = "BEERWARE", descr = "(BEERWARE)", priority = -1000, trigEngine = te("w") }, {
		i(1, "one line to give the program's name and a brief description", { key = "i1" }),
		nl(),
		t("Copyright "),
		f(function(args, snip)
			return c_viml('strftime("%Y")')
		end),
		t(" "),
		nl(),
		nl(),
		t('Licensed under the "THE BEER-WARE LICENSE" (Revision 42):'),
		nl(),
		cp(2),
		t(" wrote this file. As long as you retain this notice you"),
		nl(),
		t("can do whatever you want with this stuff. If we meet some day, and you think"),
		nl(),
		t("this stuff is worth it, you can buy me a beer or coffee in return"),
		nl(),
		i(0, "", { key = "i0" }),
	}),
	s({ trig = "WTFPL", descr = "(WTFPL)", priority = -1000, trigEngine = te("w") }, {
		t("\t\tDO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE"),
		nl(),
		t("\t\t\t\tVersion 2, December 2004"),
		nl(),
		nl(),
		t("Copyright "),
		f(function(args, snip)
			return c_viml('strftime("%Y")')
		end),
		t(" "),
		nl(),
		nl(),
		t("Everyone is permitted to copy and distribute verbatim or modified"),
		nl(),
		t("copies of this license document, and changing it is allowed as long"),
		nl(),
		t("as the name is changed."),
		nl(),
		nl(),
		t("\t\tDO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE"),
		nl(),
		t("TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION"),
		nl(),
		nl(),
		t(" 0. You just DO WHAT THE FUCK YOU WANT TO."),
		nl(),
		nl(),
		cp(0),
	}),
	s({ trig = "MPL2", descr = "(MPL2)", priority = -1000, trigEngine = te("w") }, {
		t("This Source Code Form is subject to the terms of the Mozilla Public"),
		nl(),
		t("License, v. 2.0. If a copy of the MPL was not distributed with this"),
		nl(),
		t("file, You can obtain one at http://mozilla.org/MPL/2.0/."),
		nl(),
		i(0, "", { key = "i0" }),
	}),
	s({ trig = "AGPL", descr = "(AGPL)", priority = -1000, trigEngine = te("w") }, {
		i(1, "One line to give the program's name and a brief description.", { key = "i1" }),
		nl(),
		t("Copyright "),
		f(function(args, snip)
			return c_viml('&enc[:2] == "utf" ? "©" : "(c)"')
		end),
		t(" "),
		f(function(args, snip)
			return c_viml('strftime("%Y")')
		end),
		t(" "),
		nl(),
		nl(),
		t("This program  is free software: you can redistribute it and/or modify"),
		nl(),
		t("it under the terms of the GNU Affero General Public License as"),
		nl(),
		t("published by the Free Software Foundation, either version 3 of the"),
		nl(),
		t("License, or (at your option) any later version."),
		nl(),
		nl(),
		t("This program is distributed in the hope that it will be useful,"),
		nl(),
		t("but WITHOUT ANY WARRANTY; without even the implied warranty of"),
		nl(),
		t("MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the"),
		nl(),
		t("GNU Affero General Public License for more details."),
		nl(),
		nl(),
		t("You should have received a copy of the GNU Affero General Public License"),
		nl(),
		t("along with this program. If not, see <http://www.gnu.org/licenses/>."),
	}),
	s({ trig = "ISC", descr = "(ISC)", priority = -1000, trigEngine = te("w") }, {
		i(1, "one line to give the program's name and a brief description", { key = "i1" }),
		nl(),
		t("Copyright "),
		f(function(args, snip)
			return c_viml('&enc[:2] == "utf" ? "©" : "(c)"')
		end),
		t(" "),
		f(function(args, snip)
			return c_viml('strftime("%Y")')
		end),
		t(", "),
		nl(),
		nl(),
		t(
			"Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted, provided that the above copyright notice and this permission notice appear in all copies."
		),
		nl(),
		nl(),
		t(
			'THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.'
		),
		nl(),
		i(0, "", { key = "i0" }),
	}),
	s({
		trig = "box",
		descr = '(box) "A nice box with the current comment symbol"',
		priority = -60,
		trigEngine = te("b"),
	}, {
		f(function(args, snip)
			return c_py(
				{ "all", 24 },
				"\nbox = make_box(len(t[1]))\nsnip.rv = box[0]\nsnip += box[1]\n",
				python_globals,
				args,
				snip,
				"",
				{ 1 }
			)
		end, { k("i1") }),
		d(1, function(args, snip)
			return sn(nil, { i(1, jt({ snip.env.LS_SELECT_DEDENT or {} }, ""), { key = "i1" }) })
		end),
		f(function(args, snip)
			return c_py(
				{ "all", 24 },
				"\nbox = make_box(len(t[1]))\nsnip.rv = box[2]\nsnip += box[3]",
				python_globals,
				args,
				snip,
				"",
				{ 1 }
			)
		end, { k("i1") }),
		nl(),
		i(0, "", { key = "i0" }),
	}),
	s({ trig = "bbox", descr = '(bbox) "A nice box over the full width"', priority = -60, trigEngine = te("b") }, {
		f(function(args, snip)
			return c_py(
				{ "all", 25 },
				"\nif not snip.c:\n\twidth = int(vim.eval(\"&textwidth - (virtcol('.') == 1 ? 0 : virtcol('.'))\")) or 71\nbox = make_box(len(t[1]), width)\nsnip.rv = box[0]\nsnip += box[1]\n",
				python_globals,
				args,
				snip,
				"",
				{ 1 }
			)
		end, { k("i1") }),
		d(1, function(args, snip)
			return sn(nil, { i(1, jt({ snip.env.LS_SELECT_DEDENT or {} }, ""), { key = "i1" }) })
		end),
		f(function(args, snip)
			return c_py(
				{ "all", 25 },
				"\nbox = make_box(len(t[1]), width)\nsnip.rv = box[2]\nsnip += box[3]",
				python_globals,
				args,
				snip,
				"",
				{ 1 }
			)
		end, { k("i1") }),
		nl(),
		i(0, "", { key = "i0" }),
	}),
	s({ trig = "fold", descr = '(fold) "Insert a vim fold marker"', priority = -60, trigEngine = te("b") }, {
		f(function(args, snip)
			return c_py({ "all", 26 }, "snip.rv = get_comment_format()[0]", python_globals, args, snip, "", {})
		end),
		t(" "),
		i(1, "Fold description", { key = "i1" }),
		t(" "),
		f(function(args, snip)
			return c_py({ "all", 26 }, "snip.rv = foldmarker()[0]", python_globals, args, snip, "", {})
		end),
		i(2, "1", { key = "i2" }),
		t(" "),
		f(function(args, snip)
			return c_py({ "all", 26 }, "snip.rv = get_comment_format()[2]", python_globals, args, snip, "", {})
		end),
	}),
	s({ trig = "foldc", descr = '(foldc) "Insert a vim fold close marker"', priority = -60, trigEngine = te("b") }, {
		f(function(args, snip)
			return c_py({ "all", 27 }, "snip.rv = get_comment_format()[0]", python_globals, args, snip, "", {})
		end),
		t(" "),
		i(1, "1", { key = "i2" }),
		f(function(args, snip)
			return c_py({ "all", 27 }, "snip.rv = foldmarker()[1]", python_globals, args, snip, "", {})
		end),
		t(" "),
		f(function(args, snip)
			return c_py({ "all", 27 }, "snip.rv = get_comment_format()[2]", python_globals, args, snip, "", {})
		end),
	}),
	s({ trig = "foldp", descr = '(foldp) "Insert a vim fold marker pair"', priority = -60, trigEngine = te("b") }, {
		f(function(args, snip)
			return c_py({ "all", 28 }, "snip.rv = get_comment_format()[0]", python_globals, args, snip, "", {})
		end),
		t(" "),
		i(1, "Fold description", { key = "i1" }),
		t(" "),
		f(function(args, snip)
			return c_py({ "all", 28 }, "snip.rv = foldmarker()[0]", python_globals, args, snip, "", {})
		end),
		t(" "),
		f(function(args, snip)
			return c_py({ "all", 28 }, "snip.rv = get_comment_format()[2]", python_globals, args, snip, "", {})
		end),
		nl(),
		d(2, function(args, snip)
			return sn(nil, { i(1, jt({ snip.env.LS_SELECT_DEDENT or {} }, ""), { key = "i2" }) })
		end),
		nl(),
		f(function(args, snip)
			return c_py({ "all", 28 }, "snip.rv = get_comment_format()[0]", python_globals, args, snip, "", {})
		end),
		t(" "),
		f(function(args, snip)
			return c_py({ "all", 28 }, "snip.rv = foldmarker()[1]", python_globals, args, snip, "", {})
		end),
		t(" "),
		cp(1),
		t(" "),
		f(function(args, snip)
			return c_py({ "all", 28 }, "snip.rv = get_comment_format()[2]", python_globals, args, snip, "", {})
		end),
	}),
	s({
		trig = "lorem(([1-4])?[0-9])?",
		descr = '(lorem(([1-4])?[0-9])?) "Lorem Ipsum"',
		priority = -60,
		trigEngine = te("r"),
		regTrig = true,
	}, {
		f(function(args, snip)
			return c_py(
				{ "all", 29 },
				'snip.rv = " ".join(LOREM.split()[:int(match.group(1))]) if match.group(1) else LOREM',
				python_globals,
				args,
				snip,
				"",
				{}
			)
		end),
	}),
	s({ trig = "modeline", descr = '(modeline) "Vim modeline"', priority = -60, trigEngine = te("") }, {
		t("vim"),
		f(function(args, snip)
			return c_viml(
				"':set '. (&expandtab ? printf('et sw=%i ts=%i', &sw, &ts) : printf('noet sts=%i sw=%i ts=%i', &sts, &sw, &ts)) . (&tw ? ' tw='. &tw : '') . ':'"
			)
		end),
	}),
	s({ trig = "todo", descr = '(todo) "TODO comment"', priority = -60, trigEngine = te("bw") }, {
		f(function(args, snip)
			return c_py({ "all", 31 }, "snip.rv=get_comment_format()[0]", python_globals, args, snip, "", {})
		end),
		t(" "),
		i(1, "TODO", { key = "i2" }),
		t(": "),
		i(0, "", { key = "i0" }),
		c(2, {
			{
				t(" <"),
				d(1, function(args, snip)
					return sn(nil, { i(1, jt({ c_viml("strftime('%d-%m-%y')") }, " "), { key = "i4" }) })
				end),
				t(">"),
			},
			{
			},
		}, { key = "i3" }),
		t(" "),
		f(function(args, snip)
			return c_py({ "all", 31 }, "snip.rv=get_comment_format()[2]", python_globals, args, snip, "", {})
		end),
	}),
	s({ trig = "uuid", descr = '(uuid) "Random UUID"', priority = -60, trigEngine = te("w") }, {
		f(function(args, snip)
			return c_py(
				{ "all", 32 },
				"if not snip.c: import uuid; snip.rv = str(uuid.uuid4())",
				python_globals,
				args,
				snip,
				"",
				{}
			)
		end),
	}),
})
