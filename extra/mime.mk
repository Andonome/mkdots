### Ucomment to use the makefile.
default += $(HOME)/.local/share/mime

checklist += xdg-mime
default += $(HOME)/.local/share/mime/packages
default += $(HOME)/.local/share/applications/mimeapps.list

repo_mimetype_files = $(wildcard home/local/share/applications/*.desktop)
local_mimetype_files = $(patsubst home/%,$(HOME)/.%,$(repo_mimetype_files))

$(local_mimetype_files): $(repo_mimetype_files)

$(HOME)/.local/share/applications/mimeapps.list: $(HOME)/.config/mimeapps.list
	@mkdir -p $(@D)
	ln -sf $< $@

$(HOME)/.config/mimeapps.list: $(local_mimetype_files)
	xdg-mime default vim.desktop text/plain
	xdg-mime default vim.desktop text/x-tex
	xdg-mime default vim.desktop text/x-makefile
	xdg-mime default mat.desktop text/markdown
	xdg-mime default sc-im.desktop application/x-sc
	xdg-mime default mpv.desktop audio/mpeg
	xdg-mime default mpv.desktop audio/*
	xdg-mime default mpv.desktop audio/x-m4a
	xdg-mime default mpv.desktop audio/x-wav
	xdg-mime default mpv.desktop video/x-matroska
	xdg-mime default mpv.desktop image/gif
	xdg-mime default mpv.desktop video/*
	xdg-mime default mpv.desktop video/webm
	xdg-mime default mpv.desktop video/quicktime
	xdg-mime default mpv.desktop video/mp4
	xdg-mime default org.fontforge.FontForge.desktop font/sfnt
	xdg-mime default org.gnome.font-viewer.desktop application/vnd.ms-opentype
	xdg-mime default org.gnome.font-viewer.desktop font/sfnt
	xdg-mime default org.inkscape.Inkscape.desktop image/svg+xml
	xdg-mime default org.pwmt.zathura.desktop application/pdf
	xdg-mime default sxiv.desktop image/jpeg
	xdg-mime default sxiv.desktop image/jpg
	xdg-mime default sxiv.desktop image/webp
	xdg-mime default sxiv.desktop image/png
	xdg-settings set default-web-browser org.qutebrowser.desktop
	xdg-mime default amfora.desktop x-scheme-handler/gemini
	xdg-mime default aerc.desktop x-scheme-handler/mailto

$(HOME)/.local/share/mime/packages: $(HOME)/.config/mimeapps.list
	mkdir -p $@
	update-mime-database $(@D)

