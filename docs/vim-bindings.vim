" Some basic VIM bindings to run the refactor commands.
"
" This needs to be put into a proper vim plugin bundle but this bit of
" vimscript provides some basic bindings until it is done properly.
"
" INSTALLATION
"
" Either save this file some where safe and add the following line to your
" .vimrc file:
"
" source path/to/this/file
"
" Or simply copy the contents of this file into your .vimrc
"
" USAGE
"
" The file you are refactoring MUST be saved before any refactoring commands
" will work.
"
" - EXTRACT METHOD
"   Go into visual mode and select the code you want to extract to a new
"   method the press <Leader>rem
"
"   You will be prompted for the name of the new method.
"
" - RENAME LOCAL VARIABLE
"   In normal mode move the cursor so it's inside the name of the variable
"   which you want to rename. Press <Leader>rlv
"
"   You will be prompted for the new name of the variable.
"
" - LOCAL VARIABLE TO INSTANCE VARIABLE
"   In normal mode move the cursor so it's inside the name of the variable
"   which you want to rename. Press <Leader>rli
"
" - OPTIMIZE USE
"   Simple press <Leader>rou to run the optimize use refactoring.

let g:php_refactor_command='php /usr/bin/refactor.phar'
let g:php_refactor_patch_command='patch -p1'

func! PhpRefactorExtractMethod()
    " check the file has been saved
    if &modified
        echom 'Cannot refactor; file contains unsaved changes'
        return
    endif

    let startLine = line('v')
    let endLine = line('.')
    let method = input('Enter extracted method name: ')

    " check line numbers are the right way around
    if startLine > endLine
        let temp = startLine
        let startLine = endLine
        let endLine = temp
    endif

    let range = startLine . '-' . endLine

    let args = [range, method]

    call PhpRefactorRunCommand('extract-method', args)

    " todo : exit visual mode
endfunc

func! PhpRefactorLocalVariableToInstanceVariable()
    " check the file has been saved
    if &modified
        echom 'Cannot refactor; file contains unsaved changes'
        return
    endif

    let variable = expand('<cword>')
    let lineNo = line('.')

    let args = [lineNo, variable]

    call PhpRefactorRunCommand('convert-local-to-instance-variable', args)
endfunc

func! PhpRefactorRenameLocalVariable()
    " check the file has been saved
    if &modified
        echom 'Cannot refactor; file contains unsaved changes'
        return
    endif

    let oldName = expand('<cword>')
    let lineNo = line('.')
    let newName = input('Enter new variable name: ')

    let args = [lineNo, oldName, newName]

    call PhpRefactorRunCommand('rename-local-variable', args)
endfunc

func! PhpRefactorOptimizeUse()
    " check the file has been saved
    if &modified
        echom 'Cannot refactor; file contains unsaved changes'
        return
    endif

    call PhpRefactorRunCommand('optimize-use', [])
endfunc

func! PhpRefactorRunCommand(refactoring, args)
    " Enable autoread to stop prompting for reload
    setlocal autoread

    let command = ':!' . g:php_refactor_command
        \ . ' ' . a:refactoring . ' %'

    for arg in a:args
        let command = command . ' ' . arg
    endfor

    exec command .' | '.g:php_refactor_patch_command

    setlocal noautoread
endfunc

vnoremap <expr> <Leader>rem PhpRefactorExtractMethod()
noremap <expr> <Leader>rlv PhpRefactorRenameLocalVariable()
noremap <expr> <Leader>rli PhpRefactorLocalVariableToInstanceVariable()
noremap <expr> <Leader>rou PhpRefactorOptimizeUse()
