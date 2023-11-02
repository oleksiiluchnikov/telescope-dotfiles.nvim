local has_telescope = pcall(require, "telescope")
if not has_telescope then
    error("telescope-dotfiles.nvim requires telescope.nvim - https://github.com/nvim-telescope/telescope.nvim")
end

local configs = function()
    require("telescope-dotfiles").configs(require("telescope.themes").get_dropdown({}))
end

return require("telescope").register_extension {
    setup = function(ext_config, config)
        -- access extension config and user config
    end,
    exports = {
        configs = configs,
    },
}
