command -nargs=+ -complete=highlight
            \ BufDrawMapInit call s:init_buf_draw(<f-args>)
"command BufDrawClear call s:clear_buf_draw() " TODO
let g:buf_draw_count = 0

function! s:init_buf_draw(mapkey, color) abort
    let g:buf_draw_count += 1
    let name = 'bufdrawDraw'.g:buf_draw_count
    execute $'hi link {name} {a:color}'

    let keys = $'<cmd>call <SID>draw_visual(''{name}'')<cr>'

    execute $'nnoremap <buffer> {a:mapkey} {keys}'
    execute $'xnoremap <buffer> {a:mapkey} {keys}<esc>'
endfunction

function! s:draw_visual(color) abort
    let [start, end] = sort([col('.'), col('v')])

    if line('.') != line('v')
        echoerr 'draw_visual unsupported multi-line draw'
        return
    endif

    if mode() !~# '^v\|^n$'
        echoerr $'draw_visual unsupported mode: `{mode}`'
        return
    endif

    execute $'syntax match {a:color} /\v%{line('.')}l%(%{start}c|%{end}c|%>{start}c%<{end}c)./'
endfunction
