![vim-mule](http://oi67.tinypic.com/2qixz0z.jpg)


## Features
_You can change default key mappings. See customization section._

* `:DjangoSwitch` Switch to related application file by pressing F4.

  ![django-switch](http://oi67.tinypic.com/4jx6x1.jpg)

* `:DjangoSettings` Open project settings by pressing F8.

* `:DjangoManage` You can run manage.py commands anywhere in the project  with TAB completion. By pressing F9.

  _Example: r{TAB} turns into runserver, m{TAB} turns into makemigrations and mi{TAB} turns into migrate._

  More: https://docs.djangoproject.com/en/1.10/ref/django-admin/#available-commands

* **Virtual Environment Support:** When you run a `:DjangoManage` command and if you are not in a virtual environment, vim-mule activates projects virtual environment (usually, in the parent directory of the project root) just for the command. Then you will no suprised with ImportError.

* `:DjangoTemplates` Lists all the templates in the project in a quick fix window. By pressing F6. Requires [kien/ctrlp.vim](https://github.com/kien/ctrlp.vim).



### Quick Jump Commands
Jump commands are goes to commonly used files in spesific applications.

_You can auto complete application name with TAB._

* `:DjangoViews [app]` Jumps to app's views.py
* `:DjangoModels [app]` Jumps to app's models.py
* `:DjangoForms [app]` Jumps to app's forms.py
* `:DjangoAdmin [app]` Jumps to app's admin.py
* `:DjangoUrls [app]` Jumps to urls.py
* `:DjangoTests [app]` Jumps to tests.py


## Installation
* Install using **vim-plug**:

    `Plug 'umutcoskun/vim-mule'`

* Install using **Vundle**:

    `Plugin 'umutcoskun/vim-mule'`

* Install using **Pathogen**:

    `cd ~/.vim/bundle && git clone https://github.com/umutcoskun/vim-mule.git`


## Customization
Here is the defeault options that you can change:

```viml
" Selected interpreter to run commands.
let g:mule_python_command = 'python3'

" Auto enable virtual environment.
" If you don't want, set it to 0 (zero).
let g:mule_auto_env = 1

" Only set if you don't want auto hotkey mappings.
" Hotkeys will mapped for only python filetype.
let g:mule_no_hotkeys = 1

" Uses CtrlP to list templates.
let g:mule_use_ctrlp = 1
```

Here is the default mappings if auto hotkeys enabled:

```viml
nmap <silent> <F4> :DjangoSwitch<CR>
nmap <silent> <F4> :DjangoTemplates<CR>
nmap <silent> <F8> :DjangoSettings<CR>
nmap <F9> :DjangoManage 
```


**Pull requests are welcome!**
