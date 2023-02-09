Cheatsheet - vi
===

Configure vi to work nicely with yaml files
```
$ cat << EOF > ~/.vimrc
set nu
set ts=2
set sw=2
set et
set ai
syntax on
set ruler
EOF
```

Editor commands

| Char| Description                                            |
|-----|--------------------------------------------------------|
| H   | Move the cursor to the top of the screen               |
| M   | Move the cursor to the middle of the screen            |
| L   | Move the cursor to the bottom of the screen            |
| w   | move cursor to next word                               |
| b   | Move cursor to previous word                           |
| $   | Move cursor to the end of the line                     |
| ^   | Move cursor to the start of the line                   |
| :nn | Move the cursor to line number (nn should be a number) |
| u   | undo                                                   |
| yy  | copy                                                   |
| p   | paste below the current position                       |
| P   | paste above the current position                       |
| dd  | delete the current line                                |
| D   | delete from the current position                       |
| x   | delete the current character                           |
| i   | Insert mode (allow write text)                         |
| :s  | Replace text :s/oldvalue/newvalue/g                    |

