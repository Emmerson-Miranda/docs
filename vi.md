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

| CMD | Description                                            |
|-----|--------------------------------------------------------|
| H   | Move the cursor to the top of the screen               |
| M   | Move the cursor to the middle of the screen            |
| L   | Move the cursor to the bottom of the screen            |
| w   | move cursor to next word                               |
| b   | Move cursor to previous word                           |
| $   | Move cursor to the end of the line                     |
| ^   | Move cursor to the start of the line                   |
| :nn | Move the cursor to line number (nn should be a number) |
| u   | Undo                                                   |
| yy  | Copy                                                   |
| p   | Paste below the current position                       |
| P   | Paste above the current position                       |
| dd  | Delete the current line                                |
| D   | Delete from the current position                       |
| x   | Delete the current character                           |
| i   | Insert mode (allow write text)                         |
| :s  | Replace text :s/oldvalue/newvalue/g                    |

