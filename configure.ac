AC_INIT([git-patch],
	[m4_esyscmd_s([build-aux/git-version-gen .tarball-version])],
	[judge.packham@gmail.com])
AM_INIT_AUTOMAKE([-Wall foreign])
AM_SILENT_RULES([yes])

AC_PROG_SED
AC_CHECK_PROGS([ASCIIDOC],[asciidoc],[$srcdir/missing asciidoc])
AC_CHECK_PROGS([A2X],[a2x],[$srcdir/missing a2x])

AC_ARG_WITH([bash-completion-dir],
	AS_HELP_STRING([--with-bash-completion-dir[=PATH]],
		[Install the bash auto-completion script in this directory. @<:@default=yes@:>@]),
	[],
	[with_bash_completion_dir=yes])

if test "x$with_bash_completion_dir" = "xyes"; then
	PKG_CHECK_MODULES([BASH_COMPLETION], [bash-completion >= 2.0],
		[BASH_COMPLETION_DIR="`$PKG_CONFIG --variable=completionsdir bash-completion`"],
		[BASH_COMPLETION_DIR="$datadir/bash-completion/completions"])
else
	BASH_COMPLETION_DIR="$with_bash_completion_dir"
fi

AC_SUBST([BASH_COMPLETION_DIR])
AM_CONDITIONAL([ENABLE_BASH_COMPLETION],[test "x$with_bash_completion_dir" != "xno"])

AC_CONFIG_FILES([
	Makefile
])
AC_OUTPUT
