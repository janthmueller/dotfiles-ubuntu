local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local results = { "red", "green", "blue", "yellow", "purple" }

local function build_picker(opts)
	opts = opts or {}

	return pickers.new(opts, {
		prompt_title = "Reorder Items",
		finder = finders.new_table({
			results = results,
			entry_maker = function(entry)
				return {
					value = entry,
					display = entry,
					ordinal = entry,
				}
			end,
		}),
		sorter = conf.generic_sorter(opts),

		attach_mappings = function(_, map)
			for i = 1, 9 do
				local key = "<C-" .. i .. ">"
				map("i", key, function(prompt_bufnr)
					local selection = action_state.get_selected_entry()
					local idx = vim.tbl_index_of(results, selection.value)
					if idx and idx > 0 then
						local entry = table.remove(results, idx)
						table.insert(results, i, entry)

						actions.close(prompt_bufnr)
						build_picker(opts):find()
					end
				end)
			end
			return true
		end,
	})
end
build_picker():find()
