{ nixvim, pkgs, inputs, ... }:
{
    programs.nixvim = {
      enable = true;

      extraConfigVim = ''
        set ignorecase
        set smartcase
        set signcolumn
        set background=dark
        set clipboard=unnamedplus
        set completeopt=noinsert,menuone,noselect
        set cursorline
        set hidden
        set inccommand=split
        set mouse=a
        set number
        set splitbelow splitright
        set title
        set ttimeoutlen=0
        set wildmenu
        set laststatus=2

        tnoremap <Esc> <C-\><C-n>
        nnoremap vv <cmd>CHADopen<cr>
        " Tabs size
        set expandtab
        set shiftwidth=2
        set tabstop=2
        filetype plugin indent on

        set conceallevel=0
      '';

      colorschemes.nord.enable = true;
      plugins = {
         telescope.enable = true;
         treesitter.enable = true;
         lightline = {
            enable = true;
            colorscheme = "nord";
         };
         obsidian = {
            enable = true;
            ui.enable = false;
            dir = "~/pc/box/Dropbox/Apps/remotely-save/Zettelkasten main";
            attachments.imgFolder = "999 Media/";
            dailyNotes.folder = "000 Daily notes/";
            dailyNotes.template = "Daily note.md";
            templates.subdir = "999 Templates";
         };
         chadtree = {
            enable = true;
            theme.iconGlyphSet = "ascii";
         };
         cmp = {
            enable = true;
            settings = {
              mapping = {
                __raw = ''
                  cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                  })
                '';
              };
            };
         };
      };
    };
}
