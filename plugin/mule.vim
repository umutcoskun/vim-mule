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

    let s:choice = confirm('[' . s:app_name . '] Go to related file:', "&views\n&models\n&forms\n&admin\n&urls\n&tests")

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
        \ '6': 'tests.py'
        \ }

    let s:target_name = s:choices[s:choice]
    let s:target_path = s:app_path . '/' . s:target_name
    execute ':silent! edit ' . s:target_path

    " Highlight selected file in NERDTree,
    " If the plugin is installed.
    if exists(':NERDTreFind')
        execute ':NERDTreeFind'
    endif
endfunction


" Opens closest settings.py to the project root.
function! DjangoSettings()
    execute 'edit ' . g:mule_settings_filename
endfunction

" Runs manage.py with the given arguments.
function! DjangoManage(command)
    execute '!' . g:mule_python_command . ' ' . g:mule_manage_filename . ' ' . a:command
endfunction
" Command line completor for DjangoManage function.
function! DjangoManageCompletor(arg, line, pos)
    let s:items = [
        \'check', 'compilemessages', 'createcachetable', 'dbshell', 'dumpdata',
        \'diffmessages', 'flush', 'inspectdb', 'loaddata', 'makemigrations', 'test', 'testserver',
        \'makemessages', 'migrate', 'runserver', 'startapp', 'startproject', 'showmigrations', 'sendtestmail', 'shell',
        \'sqlflush', 'sqlmigrate', 'sqlsequencereset', 'squashmigrations'
    \]
    for item in s:items
        " Check item is starts with argument.
        if item =~ '^' . a:arg
            return item
        endif
    endfor
endfunction

command! DjangoSwitch :call DjangoSwitch()
command! DjangoSettings :call DjangoSettings()
command! -nargs=1 -complete=custom,DjangoManageCompletor DjangoManage :call DjangoManage(<f-args>)

if !exists('g:mule_no_hotkeys')
    autocmd FileType python nmap <silent> <F4> :DjangoSwitch<CR>
    autocmd FileType python nmap <silent> <F8> :DjangoSettings<CR>

    " Keep the space at the end of the command
    " to provide quick argument typing
    autocmd FileType python nmap <F9> :DjangoManage 
endif

