" Check plugin is already loaded.
if exists('g:mule_loaded')
    finish
endif

let g:mule_loaded = 1

" Check python is available.
if !has('python')
    echo "Error: Required vim compiled with +python."
    finish
endif

function! DjangoSwitch()
python << EOF

import os
import vim

filename = vim.current.buffer.name
directory = os.path.dirname(filename)
app = os.path.basename(directory)

if app:
    # Check, working directory has an init file?
    # To determine its a python applicetion.
    if os.path.isfile(os.path.join(directory, '__init__.py')):
        menu = ['&views', '&models', '&forms', '&admin', '&urls', '&tests']
        choice = vim.eval('confirm("[{}] Go to related file:", "{}")'.format(
            app,
            '\n'.join(menu)
        ))
        choices = {
            '1': 'views.py',
            '2': 'models.py',
            '3': 'forms.py',
            '4': 'admin.py',
            '5': 'urls.py',
            '6': 'tests.py',
        }

        if choice in choices.keys():
            selected = choices.get(choice)
            target = os.path.join(directory, selected)
            vim.command('edit {}'.format(target))
        else:
            print('Option {} is not exists.'.format(choice))
    else:
        print('You are not in an application.')

EOF
endfunction


function! DjangoSettings()
python << EOF

import os
import vim

filename = vim.current.buffer.name
directory = os.path.dirname(filename)
ignored = ['static', 'media', 'env', 'venv', '.git']

# Only search parent 3 directories.
for i in [1, 2, 3]:
    found = False

    # Break if there is no open file in the current buffer.
    if not directory:
        break


    # Ignore blacklisted directory names.
    directories = [
        x for x in os.listdir(directory)
        if x not in ignored and os.path.isdir(x)
    ]

    for path in directories:
        settings = os.path.join(path, 'settings.py')
        if os.path.isfile(settings):
            vim.command('edit {}'.format(settings))
            found = True
            break

    if found:
        break

    directory = os.path.dirname(directory)


EOF
endfunction

" Runs manage.py functions, anywhere in the project.
" Parameter is the argument that given by the user.
function! DjangoManage(command)
python << EOF

import os
import vim

filename = vim.current.buffer.name
directory = os.path.dirname(filename)

# Only search parent 3 directories.
for i in [1, 2, 3]:
    manager = os.path.join(directory, 'manage.py')
    if os.path.isfile(manager):
        command = vim.eval('a:command')
        vim.command('!python manage.py {}'.format(command))
        break
    directory = os.path.dirname(directory)
else:
    print('manage.py not found.')

EOF
endfunction
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

command DjangoSwitch :call DjangoSwitch()
command DjangoSettings :call DjangoSettings()
command -nargs=1 -complete=custom,DjangoManageCompletor DjangoManage :call DjangoManage(<f-args>)

if !exists('g:mule_no_hotkeys')
    nmap <silent> <F4> :DjangoSwitch<CR>
    nmap <silent> <F8> :DjangoSettings<CR>

    " Keep the space at the end of the command
    " to provide quick argument typing
    nmap <F9> :DjangoManage 
endif

