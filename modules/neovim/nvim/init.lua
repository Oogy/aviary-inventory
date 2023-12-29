vim.g.mapleader = " "
vim.opt.clipboard = "unnamedplus"
vim.wo.relativenumber = true

--- Windows
vim.keymap.set('n', '<leader>wv', '<cmd>vsplit<cr>') 
vim.keymap.set('n', '<leader>ws', '<cmd>split<cr>') 

--- Edit
vim.keymap.set('n', '<leader>ei', '<cmd>e ~/.config/nvim/init.lua<cr>') 
vim.keymap.set('n', '<leader>etmp', '<cmd>e `mktemp`<cr>') 

--- Filesystem Navigation
vim.keymap.set('n', '<leader>o', '<cmd>e .<cr>') 

--- Editor Navigation
vim.keymap.set('n', '<leader>h', '<cmd>HopCamelCase<cr>')

--- Terminals/Execution/Job Management
vim.keymap.set('n', '<leader>t', '<cmd>term<cr>')

--- Buffers
vim.keymap.set('n', '<leader>bl', '<cmd>buffers<cr>')

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  use {
    'smoka7/hop.nvim',
    tag = '*', -- optional but strongly recommended
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    end
  }

  use 'nvim-tree/nvim-web-devicons'

  use {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    config = function()
      require('dashboard').setup {
	      config = {
		      week_header = {
			      enable = true
		      },
		      footer = {}
		}
      }
    end,
    requires = {'nvim-tree/nvim-web-devicons'}
  }

  use({
    "L3MON4D3/LuaSnip",
    tag = "v2.*", 
    run = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets" }
  })

  use { "rafamadriz/friendly-snippets" }

  use {
    "williamboman/mason.nvim"
  }

  use {
    "neovim/nvim-lspconfig"
  }

  use {
	  'eandrju/cellular-automaton.nvim',
	  requires = 'nvim-treesitter/nvim-treesitter'
  }

use {
  'nvim-lualine/lualine.nvim',
  requires = { 'nvim-tree/nvim-web-devicons', opt = true }
}

use {
    "nvim-neorg/neorg",
    config = function()
        require('neorg').setup {
            load = {
                ["core.defaults"] = {}, -- Loads default behaviour
                ["core.concealer"] = {}, -- Adds pretty icons to your documents
                ["core.dirman"] = { -- Manages Neorg workspaces
                    config = {
                        workspaces = {
                            notes = "~/notes",
                        },
                    },
                },
		["core.export"] = {},
            },
        }
    end,
    run = ":Neorg sync-parsers",
    requires = "nvim-lua/plenary.nvim",
}

  use "nvim-lua/plenary.nvim"

  if packer_bootstrap then
    require('packer').sync()
  end
end)

--- <Snippets>
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_vscode").lazy_load({ paths = { "~/.config/nvim/snippets/friendly-snippets/snippets" } })
local ls = require 'luasnip'
vim.keymap.set({"i"}, "<C-K>", function() ls.expand() end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump( 1) end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-J>", function() ls.jump(-1) end, {silent = true})

vim.keymap.set({"i", "s"}, "<C-E>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, {silent = true})
--- </Snippets>

require("mason").setup()
require('lualine').setup()
