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


## Customization
If you dont want to use default hotkeys, define this variable in your .vimrc file:

    let g:mule_no_hotkeys = 1


Here is the default mappings:

    nmap <silent> <F4> :DjangoSwitch<CR>
    nmap <silent> <F8> :DjangoSettings<CR>
    nmap <silent> <F9> :DjangoManage 


:)
