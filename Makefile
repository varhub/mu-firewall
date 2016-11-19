# Copyright (c) 2016
# Author: Victor Arribas <v.arribas.urjc@gmail.com>
# License: GPLv3 <http://www.gnu.org/licenses/gpl-3.0.html>
#
# Manpages:
# http://makepp.sourceforge.net/1.19/makepp_tutorial.html
# http://nuclear.mutantstargoat.com/articles/make/#writing-install-uninstall-rules


.PHONY: install
install: install-core install-rc install-desktop

.PHONY: uninstall
uninstall: uninstall-desktop uninstall-rc uninstall-core 

.PHONY: reinstall
reinstall: uninstall install


install-core:
	mkdir -p -m 0755 $(DESTDIR)/etc/firewall
	mkdir -p -m 0755 $(DESTDIR)/etc/default
	mkdir -p -m 0750 $(DESTDIR)/etc/sudoers.d

	install -m 0644 etc/firewall/*.bash $(DESTDIR)/etc/firewall
	install -m 0755 etc/firewall/firewall.bash $(DESTDIR)/etc/firewall
	install -m 0644 etc/default/firewall $(DESTDIR)/etc/default/firewall
	install -m 0440 etc/sudoers.d/firewall $(DESTDIR)/etc/sudoers.d/firewall

uninstall-core:
	find "$(DESTDIR)/etc/firewall" -delete
	rm -f "$(DESTDIR)/etc/default/firewall"
	rm -f "$(DESTDIR)/etc/sudoers.d/firewall"


install-rc:
	ln -f -s $(DESTDIR)/etc/firewall/firewall.bash $(DESTDIR)/etc/init.d/firewall
	update-rc.d firewall defaults

uninstall-rc:
	rm -f "$(DESTDIR)/etc/init.d/firewall"
	update-rc.d -f firewall remove


install-desktop:
	mkdir -p -m 0755 $(DESTDIR)/etc/firewall/icons
	install -m 644 etc/firewall/icons/*.png $(DESTDIR)/etc/firewall/icons
	mkdir -p -m 0755 $(DESTDIR)/usr/local/share/applications/
	install -m 644 desktop/*.desktop $(DESTDIR)/usr/local/share/applications/

uninstall-desktop:
	find "$(DESTDIR)/etc/firewall/icons" -delete
	find "$(DESTDIR)/usr/local/share/applications/" -name 'mu-firewall*.desktop' -delete
	
