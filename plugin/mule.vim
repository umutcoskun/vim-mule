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

function! DjangoRunServer()
python << EOF

import os
import vim

filename = vim.current.buffer.name
directory = os.path.dirname(filename)

# Only search parent 3 directories.
for i in [1, 2, 3]:
    manager = os.path.join(directory, 'manage.py')
    if os.path.isfile(manager):
        vim.command('!python manage.py runserver')
    directory = os.path.dirname(directory)
else:
    print('manage.py not found.')

EOF
endfunction

command DjangoSwitch :call DjangoSwitch()
command DjangoRunServer :call DjangoRunServer()

if !exists('g:mule_no_hotkeys')
    nmap <silent> <F4> :DjangoSwitch<CR>
    nmap <silent> <F9> :DjangoRunServer<CR>
endif

