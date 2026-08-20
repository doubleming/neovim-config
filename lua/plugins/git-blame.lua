
vim.pack.add({
    { src = "https://github.com/f-person/git-blame.nvim" }
})

require('gitblame').setup({
     --Note how the `gitblame_` prefix is omitted in `setup`
    enabled = true,
    message_template = " <summary> • <date> • <author> • <<sha>>", -- template for the blame message, check the Message template section for more options
    date_format = "%m-%d-%Y %H:%M:%S", -- template for the date, check Date format section for more options
    virtual_text_column = 1,  -- virtual text start column, check Start virtual text at column section for more options
})
