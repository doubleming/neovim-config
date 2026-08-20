-- Vue SFC：行选择时让 mini.surround 把 `<!--` / `-->` 放在独立行，
-- 得到真正的块级注释（内容会整体缩进一级，`sd-` 删除时会还原）
vim.b.minisurround_config = {
	respect_selection_type = true,
}
