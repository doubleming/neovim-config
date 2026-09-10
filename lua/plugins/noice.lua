vim.pack.add({
    { src = "https://github.com/folke/noice.nvim" }
})

require("noice").setup({
  notify = {
    enabled = false,
  },
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
    },
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = true, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = false, -- add a border to hover docs and signature help
  },
})

-- Patch: bail on UI events without a `_` separator (restart, suspend, resume,
-- flush, update, stop). noice@main's get_handler unconditionally concatenates
-- event_type which is nil for these events. See:
-- https://github.com/folke/noice.nvim/issues/1111
do
  local ok, noice_ui = pcall(require, "noice.ui")
  if ok and not noice_ui.__noice_get_handler_patched then
    local original = noice_ui.get_handler
    noice_ui.get_handler = function(event, ...)
      if type(event) ~= "string" or not event:find("_", 1, true) then
        return nil
      end
      return original(event, ...)
    end
    noice_ui.__noice_get_handler_patched = true
  end
end
