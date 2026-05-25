return {
  {
    "windwp/nvim-ts-autotag",
    dir = "@nvimTsAutotag@",
    event = "InsertEnter",
    config = function()
      require("nvim-ts-autotag").setup({
        autotag = { enable = true },
      })
    end,
  },
}
