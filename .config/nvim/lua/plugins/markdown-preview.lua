return {
    "iamcco/markdown-preview.nvim",
    build = function()
        vim.cmd([[Lazy load markdown-preview.nvim]])
        vim.fn["mkdp#util#install"]()
    end,
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },      
    config = function()
        vim.g.mkdp_auto_start = 0         
        vim.g.mkdp_refresh_slow = 0          
        vim.g.mkdp_browser = "brave"  
    end,
    lazy = true  
}
