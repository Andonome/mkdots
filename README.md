Track your dotfiles with makefiles.

Your `~/.bashrc` gets a hard-link in `mkdots/home/bashrc`.  It lives in both
places at the same time, so every change you make to `~/.bashrc` is also a
change to this repo's `mkdots/home/bashrc` file.

`mkdots` is laid out like a shadow of your home directory, without the dots:

```tree
├── Makefile
├── config
│   ├── aerc
│   │   ├── aerc.conf           <-- This links to ~/.config/aerc/aerc.conf
│   │   └── binds.conf          <-- This links to ~/.config/aerc/binds.conf
│   ├── procps
│   │   └── toprc               <-- This links to ~/.config/procps/toprc
├── home
│   ├── bashrc                  <-- This links to ~/.bashrc
│   ├── gitconfig               <-- This links to ~/.gitconfig
│   └── vim
│       └── vimrc               <-- This links to ~/.vim/vimrc
├── extra
│   ├── cron
│   │   ├── backup
│   │   └── tab
│   └── cron.mk
└── scripts
    ├── mkdots                   <-- This links to ~/.local/bin/mkdots
    └── wifi_qr.sh               <-- This links to ~/.local/bin/wifi_qr.sh

```

Hardlinks are magical.  They make one file exist in multiple places at the
same time.  That means you can delete this repo at any time, and your files
will still be where you left them.

Extras
------

Every file in `extras/` which ends in `*.mk` will be pulled into the makefile.
Additional makefiles help set up special items,  such as secret configs which
you can't commit.

Usage
=====

`make`

1. Just run `make` and the repo will set itself up.
1. The setup also adds the `mkdots` script to `~/.local/bin/mkdots`.
1. Run `mkdots` to commit new changes, and push out new hard-link files.
1. Track new files by just copying them without the `.` prefix.

`cp ~/.visidatarc mkdots/home/visidatarc`

---

    This message will self destruct.
