#!/bin/sh
#
# Git equivalent of some useful stgit commands
#
# Copyright (c) 2013, Chris Packham
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

SUBDIRECTORY_OK="yes"
OPTIONS_KEEPDASHDASH=
OPTIONS_SPEC="\
git patch [options] series [commitish]
git patch [options] pop commitish
git patch [options] push commitish
git patch [options] float commitish

Options:
--
version      Print @PACKAGE@ version information
h,help       Print this help message and exit
"

. $(git --exec-path)/git-sh-setup

# Option handling. Nothing at the moment
while test $# -ne 0
do
	case "$1" in
	--version)
		say "@PACKAGE@ @VERSION@"
		exit 0
		;;
	--)
		shift
		break
		;;
	*)
		usage
		;;
	esac
	shift
done

branch="$(git rev-parse --symbolic-full-name HEAD | sed 's|.*/||g')"
patchrefs="refs/git-patch/$branch"

has_upstream()
{
	git rev-parse -q --verify @{u} >/dev/null 2>&1
}

do_series()
{
	revs="@{u}..HEAD"
	has_upstream || revs="HEAD"
	test $# -gt 0 && revs="$1..HEAD"

	git --no-pager log --oneline --decorate "$revs"
	git --no-pager for-each-ref \
		--format='- %(objectname:short) %(subject) (%(refname))' \
		"$patchrefs"
}

do_pop()
{
	test $# -eq 1 || die "fatal: expected 1 argument."

	# Verify that we have a valid object
	sha1="$(git rev-parse --verify $1)" || exit $?

	# Save the patch
	name="$(git rev-list --pretty='%f' $sha1 -1 | tail -n1)"
	git update-ref "$patchrefs/$name" "$sha1" || die

	# Remove the patch from the current stack
	git rebase --onto "$1"^ "$1" "$branch"
}

do_push()
{
	test $# -eq 1 || die "fatal: expected 1 argument."

	# Verify that we have a valid object
	sha1="$(git rev-parse --verify $1)" || exit $?
	# Figure out the ref that we used
	ref="$(git for-each-ref $patchrefs | grep $sha1 | cut -f2)"

	git cherry-pick "$sha1" || die
	git update-ref -d "$ref"
}

do_float()
{
	test $# -eq 1 || die "fatal: expected 1 argument."

	# Verify that we have a valid object
	sha1=$(git rev-parse --verify "$1") || exit $?

	# Create a temporary reference to the commit
	name="$(git rev-list --pretty='%f' $sha1 -1 | tail -n1)"
	git update-ref "$patchrefs/$name" "$sha1" || die

	# Remove the patch from the current stack
	git rebase --onto "$1"^ "$1" "$branch" || die

	# Re-apply the commit and clean up
	git cherry-pick "$1" || die
	git update-ref -d "$patchrefs/$name"
}

case "$1" in
	series|pop|push|float)
		command="$1"
		shift
		;;
	*)
		die "fatal: Unknown command $1, try git patch -h"
		;;
esac

# Invoke helper function
do_"${command}" $@
