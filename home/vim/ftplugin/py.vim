set tabstop=4 softtabstop=4 expandtab shiftwidth=4 backspace=indent,eol,start
map ,p :wa <Enter> :!clear;./main.py <Enter>
map ,m :w <Enter> :!clear;python3 -i main.py <Enter>
map ,e :w <Enter> :!clear;python3 -i % <Enter>
