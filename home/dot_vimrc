" vi互換をオフにする
set nocompatible

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#rc(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

" add plugins
NeoBundle 'w0ng/vim-hybrid'
NeoBundle 'sudo.vim'
" ステータスラインの表示内容強化
NeoBundle 'itchyny/lightline.vim'

filetype plugin on

NeoBundleCheck


" □や◯文字が崩れなくする
set ambiwidth=double

" 文字コード・改行コード
set encoding=utf-8

" 行番号を表示する
set number
" カーソルの行数、列数を表示する
set ruler
" 編集中のファイル名を表示
set title
" 括弧入力時の対応する括弧を表示
set showmatch
" コードの色分け
colorscheme hybrid
syntax on
" インデントをスペース4つ分に設定
set tabstop=4
" オートインデント
set smartindent

" 大文字・小文字の区別なく検索
set ignorecase
" 検索文字列に大文字が含まれている場合は区別して検索
set smartcase
" 検索時に最後まで行ったら最初に戻る
set wrapscan

" カーソルの左右移動で行末から次の行の行頭への移動が可能になる
set whichwrap=b,s,h,l,<,>,[,],~
" カーソル行ハイライト
set cursorline
" バックスペースでインデントや改行を削除できるようにする
set backspace=indent,eol,start

" コマンドモードの補完
set wildmenu
" 保存するコマンド履歴の数
set history=5000

"" itchyny/lightline.vim settings
set laststatus=2 " ステータスラインを常に表示
set showmode " 現在のモードを表示
set showcmd " 打ったコマンドをステータスラインの下に表示
set ruler " ステータスラインの右側にカーソルの位置を表示する

" ペースト時のインデントをよしなにする
if &term =~ "xterm"
  let &t_SI .= "\e[?2004h"
  let &t_EI .= "\e[?2004l"
  let &pastetoggle = "\e[201~"

  function XTermPasteBegin(ret)
    set paste
	return a:ret
  endfunction

  inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
endif
