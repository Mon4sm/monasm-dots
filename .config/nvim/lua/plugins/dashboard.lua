return {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    config = function()
        require('dashboard').setup{
            theme = 'doom',
            config = {
                vertical_center = true,
                disable_move = true,
                header = {   
                    "███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗",
                    "████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║",
                    "██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║",
                    "██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║",
                    "██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║",
                    "╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝",
                    "                                                  "
                },
                center = {
                    {
                        icon = '󰱼  ',
                        desc = 'Find File',
                        key = 'f',
                        action = 'Telescope find_files'
                    },
                    {
                        icon = '󰈚  ',
                        desc = 'Recent Files',
                        key = 'r',
                        action = 'Telescope oldfiles'
                    },
                    {
                        icon = '󰗼  ',
                        desc = 'Quit',
                        key = 'q',
                        action = 'qa'
                    }
                },
                footer = {"Snort! Snort! Snort!"}
            }
        }
        vim.api.nvim_create_autocmd('FileType',{
            pattern = 'dashboard',
            callback = function()
                vim.opt_local.scrolloff = 0
                local nop = function(key)
                    vim.keymap.set('n',key,'<Nop>', { buffer = true, silent = true })
                end
                for _, k in ipairs({
                    '<ScrollWheelUp>', '<ScrollWheelDown>',
                    '<C-d>', '<C-u>', '<C-f>', '<C-b>', '<C-e>', '<C-y>',
                }) do
                    nop(k)
                end
            end,
        })
    end,
    dependencies = {
        {'nvim-tree/nvim-web-devicons'},
        {'nvim-telescope/telescope.nvim'},
        {'nvim-lua/plenary.nvim'}
    }
}
