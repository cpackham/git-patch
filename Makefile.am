bin_SCRIPTS = git-patch
man1_MANS = git-patch.1
EXTRA_DIST = $(man1_MANS)
CLEANFILES = $(bin_SCRIPTS) $(man1_MANS)

if ENABLE_BASH_COMPLETION
bashcompletiondir = $(BASH_COMPLETION_DIR)
dist_bashcompletion_DATA = git-patch-completion
endif

AM_V_SED = $(am__v_SED_@AM_V@)
am__v_SED_ = $(am__v_SED_@AM_DEFAULT_V@)
am__v_SED_0 = @echo "  SED     " $@;

AM_V_A2X = $(am__v_A2X_@AM_V@)
am__v_A2X_ = $(am__v_A2X_@AM_DEFAULT_V@)
am__v_A2X_0 = @echo "  A2X     " $@;

%: %.sh
	$(AM_V_SED)$(SED) \
		-e "s/[@]PACKAGE[@]/$(PACKAGE)/g" \
		-e "s/[@]VERSION[@]/$(VERSION)/g" \
		<$^ >$@

%.1: %.1.txt
	$(AM_V_A2X)$(A2X) -L -f manpage $^
