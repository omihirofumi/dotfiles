return {
  {
    "vim-denops/denops.vim",
    init = function(p)
      vim.g["denops#server#deno_args"] = { "-q", "--no-lock", "-A", "--unstable-kv" }
    end,
  },
}
