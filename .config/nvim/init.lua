-- try to use sep. lua config for nvim?

-- recommended to start learning lua config:
-- https://github.com/nvim-lua/kickstart.nvim/blob/master/init.lua - could also first try with their Dockerfile
-- https://vonheikemen.github.io/devlog/tools/neovim-plugins-to-get-started/

-- https://github.com/NvChad/NvChad - 18.3k, looks nice, but not much docs/whichkey, try via Docker: https://nvchad.com/quickstart/install#try-in-docker-container
  -- [The (almost) perfect Neovim setup for Node.js](https://www.youtube.com/watch?v=CVCBHHFXWNE)
-- https://github.com/lunarvim/lunarvim - 15.3k, also nice, terminals and color themes not as nice as NvChad, but nicer doc and grouping of keys with whichkey, try via Docker or sep. lvim command: https://www.lunarvim.org/docs/installation
-- https://github.com/AstroNvim/AstroNvim - 10k, TODO, try via Docker: https://astronvim.com
-- https://github.com/LazyVim/LazyVim - 6.1k, TODO, try via Docker: https://www.lazyvim.org/installation, discussion: https://news.ycombinator.com/item?id=36753225
  -- YouTube watched until 26:38 https://www.youtube.com/watch?v=fFHlfbKVi30

-- TODO copy comments on lunarvim from ~/notes.md

-- comparisons:
-- [I tried Neovim Distributions so you don't have to](https://www.youtube.com/watch?v=bbHtl0Pxzj8)

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Example using a list of specs with the default options
vim.g.mapleader = " " -- Make sure to set `mapleader` before lazy so your mappings are correct

require("lazy").setup({
  "folke/which-key.nvim",
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  }
})

-- plugins:
-- https://github.com/lewis6991/gitsigns.nvim instead of git-gutter
