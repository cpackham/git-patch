bin_SCRIPTS = git-patch
man1_MANS = git-patch.1
EXTRA_DIST = $(man1_MANS) $(top_srcdir)/.version
CLEANFILES = $(bin_SCRIPTS) $(man1_MANS)
BUILT_SOURCES = $(top_srcdir)/.version

if ENABLE_BASH_COMPLETION
bashcompletiondir = $(BASH_COMPLETION_DIR)
dist_bashcompletion_DATA = git-patch-completion
endif

$(top_srcdir)/.version:
	$(AM_V_GEN)echo $(VERSION) > $@
dist-hook:
	$(AM_V_GEN)echo $(VERSION) > $(distdir)/.tarball-version

AM_V_SED = $(am__v_SED_@AM_V@)
am__v_SED_ = $(am__v_SED_@AM_DEFAULT_V@)
am__v_SED_0 = @echo "  SED     " $@;

AM_V_A2X = $(am__v_A2X_@AM_V@)
am__v_A2X_ = $(am__v_A2X_@AM_DEFAULT_V@)
am__v_A2X_0 = @echo "  A2X     " $@;

SUFFIXES = .sh .txt
.sh:
	$(AM_V_SED)$(SED) \
		-e "s/[@]PACKAGE[@]/$(PACKAGE)/g" \
		-e "s/[@]VERSION[@]/$(VERSION)/g" \
		<$< >$@

.txt:
	$(AM_V_A2X)$(A2X) -L -f manpage $<
