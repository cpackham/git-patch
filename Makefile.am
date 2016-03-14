bin_SCRIPTS = git-patch
man1_MANS = git-patch.1
EXTRA_DIST = $(man1_MANS)
CLEANFILES = $(bin_SCRIPTS) $(man1_MANS)

%: %.sh
	$(AM_V_GEN)$(SED) \
		-e "s/@PACKAGE_@/$(PACKAGE)/g" \
		-e "s/@VERSION_@/$(VERSION)/g" \
		<$^ >$@

%.1: %.1.txt
	$(AM_V_GEN)$(A2X) -L -f manpage $^
