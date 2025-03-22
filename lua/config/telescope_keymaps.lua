local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local sorters = require("telescope.sorters")

local function convert_keymap(lhs)
    if not lhs then return "" end
    if lhs:sub(1, 1) == " " then
        return "<Leader>" .. lhs:sub(2)
    end
    return lhs
end

local function get_all_keymaps()
    local modes = { "n", "i", "v", "x", "s", "o", "c", "t" }
    local all_keymaps = {}
    for _, mode in ipairs(modes) do
        local keymaps = vim.api.nvim_get_keymap(mode)
        for _, keymap in ipairs(keymaps) do
            local display_key = convert_keymap(keymap.lhs)
            -- Extract file path from the `rhs` (command) field if it contains one
            local file_path = nil
            if keymap.rhs and keymap.rhs:match("e%s*(%S+)") then
                file_path = keymap.rhs:match("e%s*(%S+)")  -- Extract file path after `:e`
            end

            table.insert(all_keymaps, {
                display_key = display_key,
                cmd = keymap.rhs or (type(keymap.callback) == "function" and "[Function]" or "[Unknown]"),
                desc = keymap.desc or "[No Description]",
                mode = mode,
                file = file_path  -- Store the file path if present
            })
        end
    end
    return all_keymaps
end

local function show_keymaps(opts)
    opts = opts or {}

    -- Create a custom sorter that sorts alphabetically (ascending)
    local custom_sorter = sorters.Sorter:new({
        scoring_function = function(_, prompt, line)
            if prompt == "" then
                return line:byte() or 0
            end
            return sorters.get_generic_fuzzy_sorter(opts):scoring_function(prompt, line)
        end
    })

    pickers.new(opts, {
        prompt_title = "Keymaps",
        finder = finders.new_table({
            results = get_all_keymaps(),
            entry_maker = function(entry)
                local desc = entry.desc or "[No Description]"
                local display = string.format("%s: %s (%s)", desc, entry.display_key, entry.mode)
                return {
                    value = entry,
                    display = display,
                    ordinal = display:lower(),
                    file = entry.file
                }
            end
        }),
        sorter = custom_sorter,
        attach_mappings = function(prompt_bufnr, map)
            map("i", "<CR>", function()
                local selected = action_state.get_selected_entry()
                actions.close(prompt_bufnr)
                if selected and selected.value.file then
                    -- Jump to the file associated with the key binding
                    vim.schedule(function()
                        vim.cmd("edit " .. selected.value.file)
                    end)
                end
            end)
            return true
        end,
    }):find()
end

vim.api.nvim_create_user_command("ShowKeymaps", show_keymaps, {})
return show_keymaps

