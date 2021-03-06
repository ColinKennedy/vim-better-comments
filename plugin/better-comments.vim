" =============================================================================
" File:          plugin/better-comments.vim
" Description:   Create more human-friendly comments in your code!
" Author:        Javier Blanco <http://jbgutierrez.info>
" =============================================================================

if ( exists('g:loaded_bettercomments') && g:loaded_bettercomments ) || v:version < 700 || &cp
  finish
endif
let g:loaded_bettercomments = 1

" Functions

function! s:AddMatchesGroup(name, rules)
  let containedin=join(map(['MultilineComment', 'LineComment', 'DocComment', 'Comment'], 'b:bettercomments_syntax_prefix."".v:val'), ",").',Comment'

  exe 'syn match ' . a:name .
    \ 'LineBetterComments "\(\/\{2\}\|#\{1\}\|\"\{1\}\)' .
    \ '\([0-9A-Za-z_#@\$()!?\.:' . "'" . ' ]\+\)' .
    \ '\(' .  join(a:rules, '\|') .  '\)$" ' .
    \ 'containedin=' . b:bettercomments_syntax_prefix . 'LineComment'
endfunction


function! s:AddMatchesGroup2(name)
  let containedin=join(map(['MultilineComment', 'LineComment', 'DocComment', 'Comment'], 'b:bettercomments_syntax_prefix."".v:val'), ",").',Comment'

  " Regex description:
  "     There can be text before the markers
  "     The start of the markers
  "     There must be text inside the markers
  "     There is no text allowed after the end markers
  "
  exe 'syn match ' . a:name .
    \ 'LineBetterComments "\(\/\{2\}\|#\{1\}\|\"\{1\}\)' .
    \ '\([0-9A-Za-z_#@\$()!?\.:' . "'" . ' ]*\)' .
    \ ' ' .
    \ '(' .
    \ '\([0-9A-Za-z_#@\$()!?\.:' . "'" . ' ]\+\)' .
    \ ')$" ' .
    \ 'containedin=' . b:bettercomments_syntax_prefix . 'LineComment'
endfunction


function! s:BetterComments()
  let language = substitute(&filetype, '\..*', '', '')
  if exists("g:bettercomments_skipped") |
    if index(g:bettercomments_skipped, language) > -1 | return | endif
  endif
  if exists("g:bettercomments_included") |
    if index(g:bettercomments_included, language) == -1 | return | endif
  endif

  let b:bettercomments_syntax_prefix = exists('g:bettercomments_language_aliases[language]') ? g:bettercomments_language_aliases[language] : language

  call s:AddMatchesGroup2("Highlight")
  call s:AddMatchesGroup("Error", [ '!', 'ERROR:', 'DEPRECATED:' ])
  call s:AddMatchesGroup("Question", [ '?', 'QUESTION:' ])
  let containedin=join(map(['LineComment', 'MultilineComment', 'DocComment', 'Comment'], 'b:bettercomments_syntax_prefix."".v:val'), ",").',Comment'
endfunction



" Autocommands

augroup betterCommentsPluginAuto
  autocmd!
  au FileType * call s:BetterComments()
augroup END

"

" Syntax

hi def link ErrorBetterComments WarningMsg
hi def link ErrorLineBetterComments ErrorBetterComments
hi def link HighlightBetterComments Underlined
hi def link HighlightLineBetterComments HighlightBetterComments
hi def link QuestionBetterComments Identifier
hi def link QuestionLineBetterComments QuestionBetterComments
hi def link StrikeoutBetterComments WarningMsg
hi def link TodoBetterComments Type
hi def link TodoLineBetterComments TodoBetterComments
