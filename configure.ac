AC_INIT([git-patch],
	[m4_esyscmd_s([git describe --always --dirty])],
	[judge.packham@gmail.com])
AM_INIT_AUTOMAKE([-Wall foreign])
AC_CHECK_PROGS([ASCIIDOC],[asciidoc],[$srcdir/missing asciidoc])
AC_CHECK_PROGS([A2X],[a2x],[$srcdir/missing a2x])
AC_CONFIG_FILES([
	Makefile
	git-patch:git-patch.sh
])
AC_OUTPUT
