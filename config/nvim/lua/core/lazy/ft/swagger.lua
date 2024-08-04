return {
  "vinnymeller/swagger-preview.nvim",
  ft = "yaml",
  config = function()
    -- swagger-ui-watcherがなければ、npm install -g swagger-ui-watcherを実行


    require("swagger-preview").setup({
      port = 8003,
      host = "localhost",
    })
  end,
}
