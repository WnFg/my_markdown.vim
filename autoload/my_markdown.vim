" markdown插入图片链接的快捷键
let g:imgPath = "~/Downloads/"

function __findPos(pos, step, lineStr, lineLen)
  let symbol = ""
  if (a:step < 0)
    let symbol = "["
  else
    let symbol = "]"
  endif

  let pos = a:pos - 1
  while pos >= 0 && pos < a:lineLen
    "if (strcharpart(a:lineStr, pos, 1) == symbol)
    if (a:lineStr[pos] == symbol)
      return pos
    endif
    let pos += a:step
  endwhile
  return -1
endfunction

function __getImgName(lineStr)
  let pos = col(".")
  let lineLen = strlen(a:lineStr)
  let l = __findPos(pos, -1, a:lineStr, lineLen)
  let r = __findPos(pos, 1, a:lineStr, lineLen)
  return [strpart(a:lineStr, l + 1, r - l - 1), l, r]
endfunction

function __genImgPath()
  let strline = getline(".")
  let imgname = __getImgName(strline)
  let @a = "(/img/{{ page.folder }}/" . imgname[0] . ".jpg)"
  let cur_pos = ""
  if (imgname[1] == -1 || imgname[2] == -1)
    let cur_pos = "fuY"
  else
    let cur_pos = ":call cursor(" . line(".") . "," . (imgname[2] + 1) . ")\<CR>"
  endif
  return cur_pos
endfunction

function __mvImg()
  let strline = getline(".")
  let imgname = __getImgName(strline)
  let img_src = g:imgPath . imgname[0] . ".jpg"
  if (imgname[1] == -1 || imgname[2] == -1)
    return "fuY"
  endif
  return  ":!mv " . img_src . " " . g:img_post_dst . "\<CR>\<CR>"
endfunction

function __set_img_post_path()
  let post_name = expand("%")
  let post_base_name = strpart(post_name, 0, strridx(post_name, "."))
  let g:img_post_dst = "~/Blog/WnFg.github.io/img/" . post_base_name . "/" 
endfunction

autocmd BufNewFile,BufRead *.md,*.markdown call __set_img_post_path()

"" 快捷键为 img
let mapleader="\\"
autocmd BufNewFile,BufRead *.md,*.markdown nmap <expr> <leader>img __genImgPath() . "\"ap" 
autocmd BufNewFile,BufRead *.md echo "already_open_preview"
autocmd BufNewFile,BufRead *.md,*.markdown nmap <leader>mo :MarkdownPreview<CR>
autocmd BufNewFile,BufRead *.md,*.markdown nmap <leader>mf :MarkdownPreviewStop<CR>
autocmd BufNewFile,BufRead *.md,*.markdown nmap <expr> <leader>mmg __mvImg()
autocmd BufNewFile,BufRead *.md,*.markdown nmap <expr> <leader>omg __mvImg() . "\\img"
autocmd BufNewFile,BufRead *.md,*.markdown imap <leader>b <br> 
