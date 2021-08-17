UUID = desk-changer@eric.gach.gmail.com
VERSION = 31

ifeq ($(strip $(DESTDIR)),)
	INSTALLBASE = $(HOME)/.local/share/gnome-shell/extensions
else
	INSTALLBASE = $(DESTDIR)/usr/share/gnome-shell/extensions
endif

all: compile-resources compile-schemas

compile-resources:
	glib-compile-resources --target=./$(UUID)/resources/org.gnome.Shell.Extensions.DeskChanger.gresource --sourcedir=./resources ./resources/org.gnome.Shell.Extensions.DeskChanger.gresource.xml

compile-schemas:
	glib-compile-schemas ./$(UUID)/schemas/

install: update-translation
	mkdir -p $(INSTALLBASE)
	cp -R $(UUID)/ $(INSTALLBASE)/
	echo done

pot:
	xgettext --package-name=DeskChanger --package-version=$(VERSION) -k --keyword=_ -o ./po/desk-changer.pot -D ./$(UUID)/ _deskchanger.js convenience.js extension.js prefs.js resources/ui/prefs.ui service.js common/utils.js daemon/interface.js daemon/profile.js daemon/server.js daemon/timer.js ui/control.js ui/panelMenu.js ui/popupMenu.js

update-translation: all
	cd po; \
	./compile.sh ../desk-changer@eric.gach.gmail.com/locale;

zipfile: all
	cd ./$(UUID)/; \
	zip -r ../$(UUID)-$(VERSION).zip . -x 'resources/ui/*' -x 'resources/icons/*' -x 'resources/*.xml' -x 'resources/*.in'
