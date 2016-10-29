# vim-mule
Simple productivity plugin for django.

![vim-mule](http://oi63.tinypic.com/30byzdi.jpg)

## Installation
Install using vim-plug:

    Plug 'umutcoskun/vim-mule'


## Features
_You can change default key mappings. See customization section._

* `:DjangoSwitch` Switch to related application file by pressing F4.

![django-switch](http://oi67.tinypic.com/4jx6x1.jpg)

* `:DjangoSettings` Open project settings by pressing F8.

* `:DjangoManage` You can run manage.py commands anywhere in the project  with TAB completion. By pressing F9.

For example: r{TAB} turns into runserver or m{TAB} to makemigrations or mi{TAB} to migrate.

More info: https://docs.djangoproject.com/es/1.10/ref/django-admin/#available-commands

* When you run a `:DjangoManage` command and if you are not in a virtual environment, vim-mule activates projects `virtual environment` (usually, in the parent directory of the project root) just for the command. Then you will no suprised with ImportError.

If you want to disable auto environment, in your .vimrc:

    let g:mule_auto_env = 0


### Quick Jump Commands
Jump commands are goes to commonly used files in spesific applications.
_You can auto complete application name with TAB._

* `:DjangoViews [app]` Jumps to app's views.py
* `:DjangoModels [app]` Jumps to app's models.py
* `:DjangoForms [app]` Jumps to app's forms.py
* `:DjangoAdmin [app]` Jumps to app's admin.py
* `:DjangoUrls [app]` Jumps to urls.py
* `:DjangoTests [app]` Jumps to tests.py


## Customization
Here is the defeault options that you can change:

    let g:mule_python_command = 'python3'

If you dont want to use default hotkeys, define this variable in your .vimrc file:

    let g:mule_no_hotkeys = 1

Hotkeys are auto mapping for only python filetype.


Here is the default mappings:

    nmap <silent> <F4> :DjangoSwitch<CR>
    nmap <silent> <F8> :DjangoSettings<CR>
    nmap <F9> :DjangoManage 


:)
