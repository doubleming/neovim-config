vim.pack.add({
    { src = "https://github.com/folke/noice.nvim" }
})

require("noice").setup({
  notify = {
    enabled = false,
  },
  -- inputlist()/confirm() 的选择提示必须走 confirm 弹窗。
  -- long_message_to_split 预设把 min_height >= 20 的 msg_show 丢进底部 split
  -- （view = cmdline_output，format = "details"），代码动作一多就会显示成
  -- "msg_show.confirm Code actions:" 这种只读消息，无法选择。用户 routes
  -- 排在预设之前，因此在这里抢回优先级。
  routes = {
    {
      filter = {
        event = "msg_show",
        kind = { "confirm", "confirm_sub", "number_prompt" },
      },
      view = "confirm",
    },
  },
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
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
