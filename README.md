# vim-mule
Simple productivity plugin for django.

![vim-mule](http://oi63.tinypic.com/30byzdi.jpg)

## Installation
Install using vim-plug:

    Plug 'umutcoskun/vim-mule'


## Features
* Switch to related application file by pressing F4.

![django-switch](http://oi67.tinypic.com/4jx6x1.jpg)

* Run test server by pressing F9.

* Open project settings by pressing F8.


## Customization
If you dont want to use default hotkeys, define this variable in your .vimrc file:

    let g:mule_no_hotkeys = 1


Here is the default mappings:

    nmap <silent> <F4> :DjangoSwitch<CR>
    nmap <silent> <F8> :DjangoSettings<CR>
    nmap <silent> <F9> :DjangoRunServer<CR>


:)
