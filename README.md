Track your dotfiles with makefiles.

Clone this directory to somewhere convenient like `~/.dots`, then start with a dry-run
to check the setup commands:

```bash
make -n
make
```

This will:

1. Copy your `~/.bashrc` to `.dots/home/bashrc`
2. Make a *hard* link back to your `~/.bashrc`.

Hard links mean you can check out different branches without disturbing the
current OS, and just run `make` again to re-link the files.

Just add other files, and they'll start to link automatically.

*Example:* place the file `.dots/home/vim/vimrc`, then run `make`;  this will
create `~/.vim/`, then make a hard link to `~/.vim/vimrc`.

## Exceptions

Anything which the `Makefile` cannot handle needs another makefile in `extra/`.
An example is provided for ssh, since `.ssh/config` needs secure permissions to
run.

---

    This message will self destruct.
