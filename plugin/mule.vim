" Check plugin is already loaded.
if exists('g:mule_loaded') | finish | endif
let g:mule_loaded = 1

" Default version to run commands
let g:mule_python_command = 'python3'
" Get absolute path of manage.py
let g:mule_manage_filename = fnamemodify(findfile('manage.py', '.;'), ':p')
" Root directory of the Django project.
let g:mule_project_path = ''

" Check manage.py is exists.
if !empty(glob(g:mule_manage_filename))
    " Get directory of manage.py and set as project root.
    let g:mule_project_path = fnamemodify(g:mule_manage_filename, ':h')

    " Get absolue path of the settings.
    let g:mule_settings_filename = system('find ' . g:mule_project_path . ' -name settings.py')
else
    echo 'MULE: Unable to find manage.py'
endif


" Try to activate virtual environment when execute manage.py commands.
" If not set, open by default.
if !exists('g:mule_auto_env')
    let g:mule_auto_env = 1
endif

" If user does not set, auto mappings are True by default.
if !exists('g:mule_no_hotkeys')
    let g:mule_no_hotkeys = 0
endif

if exists('g:mule_auto_env')
    " If user allow auto environment.
    if g:mule_auto_env != 0
        " Get parent directory of the project root.
        let s:mule_project_parent = fnamemodify(g:mule_project_path, ':h:p')
        " Search for `activate` binary, to activate virtual environment.
        let g:mule_virtual_env = system('find ' . s:mule_project_parent . ' -name activate')

        " Delete variable if virtual environment does not found.
        if g:mule_virtual_env == ''
            unlet g:mule_virtual_env
        endif
    endif
endif

" Try to use CtrlP or FzF to jump to templates, by default.
if !exists('g:mule_use_ctrlp_or_fzf')
    let g:mule_use_ctrlp_or_fzf = 1
endif

" Highlight selected file in NERDTree,
" If the plugin is installed.
function! RefreshNERDTree()
    if exists(':NERDTreFind')
        execute ':NERDTreeFind'
    endif
endfunction

" Switches between application files.
function! DjangoSwitch()
    " Get absolute directory of current buffer.
    let s:app_path = expand('%:p:h')
    " Check current file in an application.
    let s:is_app_valid = filereadable(s:app_path . '/__init__.py')

    if !s:is_app_valid
        echo 'You are not in application.'
        return
    endif

    " Extract application name from the absolute path.
    let s:app_name = fnamemodify(s:app_path, ':t')

    let s:choice = confirm('[' . s:app_name . '] Go to related file:', "&views\n&models\n&forms\n&admin\n&urls\n&tests\n&managers\n&serializers")

    " Abort if the user does not select any option.
    if s:choice == 0
        return
    endif

    let s:choices = {
        \ '1': 'views.py',
        \ '2': 'models.py',
        \ '3': 'forms.py',
        \ '4': 'admin.py',
        \ '5': 'urls.py',
        \ '6': 'tests.py',
        \ '7': 'managers.py',
        \ '8': 'serializers.py'
        \ }

    let s:target_name = s:choices[s:choice]
    let s:target_path = s:app_path . '/' . s:target_name
    execute ':silent! edit ' . s:target_path

    execute ':silent! call RefreshNERDTree()'
endfunction


" Opens closest settings.py to the project root.
function! DjangoSettings()
    execute 'edit ' . g:mule_settings_filename
endfunction

" Runs manage.py with the given arguments.
" And tries to activate virtual environment.
function! DjangoManage(command)
    " Build full manage command.
    " e.g python3 manage.p runserver.
    let l:line = g:mule_python_command . ' ' . g:mule_manage_filename . ' ' . a:command
    " If user is not inside of any virtual envrionment.
    if !exists($VIRTUAL_ENV)
        " If user let the activate auto activate virtual environment,
        " And vim-plug can find `activate` binary.
        if exists('g:mule_auto_env') && exists('g:mule_virtual_env')
            " Add virtual environment activation command to full command.
            let l:line = 'source ' . g:mule_virtual_env . ' && ' . l:line
            " Remove new line character from the command line.
            let l:line = substitute(l:line, '\n', '\1', '')
        endif
    endif
    " Finally, run command.
    execute '!' . l:line
endfunction
" Command line completor for DjangoManage function.
function! DjangoManageCompletor(arg, line, pos)
    let s:items = [
        \'check', 'compilemessages', 'createcachetable', 'dbshell', 'dumpdata',
        \'diffmessages', 'flush', 'inspectdb', 'loaddata', 'makemigrations', 'test', 'testserver',
        \'makemessages', 'migrate', 'runserver', 'startapp', 'startproject', 'showmigrations', 'sendtestmail', 'shell',
        \'sqlflush', 'sqlmigrate', 'sqlsequencereset', 'squashmigrations',
    \]
    for item in s:items
        " Check item is starts with argument.
        if item =~ '^' . a:arg
            return item
        endif
    endfor
endfunction


function! IsApplication(idx, path)
    return filereadable(fnamemodify(a:path, ':p:h') . '/__init__.py')
endfunction

function! DjangoJump(...)
    let l:command = a:1
    let l:app_name = a:2

    if a:0 > 1
        let s:app_path = g:mule_project_path . '/' . l:app_name

        " Check given argument is a real application.
        if !IsApplication(0, s:app_path)
            echo 'There is no application named: ' . l:app_name
            return
        endif

        execute ':silent! edit ' . s:app_path . '/' . l:command . '.py'
        execute ':silent! call RefreshNERDTree()'
    endif
endfunction
" Command line completor for DjangoJump function
function! DjangoJumpCompletor(arg, line, pos)
    " Get sub directories of the project root.
    let s:dirs = filter(split(globpath(g:mule_project_path, '*'), '\n'),'isdirectory(v:val)')
    " Check sub directories are they application?
    let s:apps = filter(s:dirs, function('IsApplication'))

    for app_path in s:apps
        " Get directory name as application name.
        let l:app_name = fnamemodify(app_path, ':p:h:t')
        " Check item is starts with argument.
        if l:app_name =~ '^' . a:arg
            return l:app_name
        endif
    endfor
endfunction

" Tries to find 'templates' directory,
" And executes CtrlP or FzF command with this directory as root.
function! DjangoTemplates(command)
    let g:mule_templates_path = g:mule_project_path . '/templates'
    " Check templates directory is exists.
    if isdirectory(g:mule_templates_path)
        execute ':' . a:command . ' ' . g:mule_templates_path
    else
        echo 'Templates directory not found.'
    endif
endfunction!

command! DjangoSwitch :call DjangoSwitch()
command! DjangoSettings :call DjangoSettings()
command! -nargs=1 -complete=custom,DjangoManageCompletor DjangoManage :call DjangoManage(<f-args>)
command! -nargs=1 -complete=custom,DjangoJumpCompletor DjangoViews :call DjangoJump('views', <f-args>)
command! -nargs=1 -complete=custom,DjangoJumpCompletor DjangoModels :call DjangoJump('models', <f-args>)
command! -nargs=1 -complete=custom,DjangoJumpCompletor DjangoForms :call DjangoJump('forms', <f-args>)
command! -nargs=1 -complete=custom,DjangoJumpCompletor DjangoAdmin :call DjangoJump('admin', <f-args>)
command! -nargs=1 -complete=custom,DjangoJumpCompletor DjangoUrls :call DjangoJump('urls', <f-args>)
command! -nargs=1 -complete=custom,DjangoJumpCompletor DjangoTests :call DjangoJump('tests', <f-args>)

" Check CtrlP or FzF is installed.
" And user is allowed to use it.
if g:mule_use_ctrlp_or_fzf != 0
    if exists(':CtrlP')
        command! DjangoTemplates :call DjangoTemplates("CtrlP")
    elseif exists(':Files')
        command! DjangoTemplates :call DjangoTemplates("Files")
    endif
endif


" If user allow auto mappings.
if g:mule_no_hotkeys != 1
    autocmd FileType python nmap <silent> <F4> :DjangoSwitch<CR>
    autocmd FileType python nmap <silent> <F6> :DjangoTemplates<CR>
    autocmd FileType python nmap <silent> <F8> :DjangoSettings<CR>

    " Keep the space at the end of the command
    " to provide quick argument typing
    autocmd FileType python nmap <F9> :DjangoManage 
endif

