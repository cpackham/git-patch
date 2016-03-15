bin_SCRIPTS = git-patch
man1_MANS = git-patch.1
EXTRA_DIST = $(man1_MANS)
CLEANFILES = $(bin_SCRIPTS) $(man1_MANS)

if ENABLE_BASH_COMPLETION
bashcompletiondir = $(BASH_COMPLETION_DIR)
dist_bashcompletion_DATA = git-patch-completion
endif

%: %.sh
	$(AM_V_GEN)$(SED) \
		-e "s/[@]PACKAGE[@]/$(PACKAGE)/g" \
		-e "s/[@]VERSION[@]/$(VERSION)/g" \
		<$^ >$@

%.1: %.1.txt
	$(AM_V_GEN)$(A2X) -L -f manpage $^
