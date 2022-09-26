local M = {}
local fn = vim.fn

function M.setup(opts)
    -- Automatically install packer
    local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        PACKER_BOOTSTRAP = fn.system({
            "git",
            "clone",
            "--depth",
            "1",
            "https://github.com/wbthomason/packer.nvim",
            install_path,
        })
        print("Installing packer close and reopen Neovim...")
        vim.cmd("packadd packer.nvim")
    end

    -- Use a protected call so we don't error out on first use
    local status_ok, packer = pcall(require, "packer")
    if not status_ok then
        return
    end

    packer.startup(function(use)
        -- The package manager
        use("wbthomason/packer.nvim")

        for _, m in pairs(opts.modules) do
            require(m).plugins(use)
        end
    end)
end

return M
