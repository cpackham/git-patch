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
git patch [options] series [commit-ish]
git patch [options] pop commit-ish
git patch [options] push [commit-ish]
git patch [options] float commit-ish
git patch [options] delete commit-ish
git patch [options] fixup commit-ish [file] [...]

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
		git --version
		say "@PACKAGE@ version @VERSION@"
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

sha1_to_ref()
{
	git for-each-ref $patchrefs | grep "$1" | cut -f2 | head -n1
}

top_ref()
{
	git for-each-ref \
		--sort=refname \
		--format="%(refname)" $patchrefs \
	| tail -n1
}

augment_name()
{
	existing=$(top_ref)

	num="0001"
	if test -n "$existing"; then
		existing="${existing##*/}"
		num="${existing%%--*}"
		num="$(printf %04d $(($num+1)))"
	fi

	echo "$num--$1"
}

do_series()
{
	revs="@{u}..HEAD"
	has_upstream || revs="HEAD"
	test $# -gt 0 && revs="$1..HEAD"

	git --no-pager log --oneline --decorate "$revs"
	git --no-pager for-each-ref \
		--sort=-refname \
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
	name=$(augment_name "$name")
	git rev-parse -q --verify "$patchrefs/$name" >/dev/null && \
		die "fatal: $patchrefs/$name already exists"
	git update-ref "$patchrefs/$name" "$sha1" || die

	# Remove the patch from the current stack
	git rebase --onto "$1"^ "$1" "$branch"
}

do_push()
{
	if test $# -eq 0; then
		rev=$(top_ref)
	elif test $# -eq 1; then
		rev="$1"
	else
		die "fatal: expected at most 1 argument."
	fi

	# Verify that we have a valid object
	sha1="$(git rev-parse --verify $rev)" || exit $?
	# Figure out the ref that we used
	ref="$(sha1_to_ref $sha1)"

	git cherry-pick "$sha1" || die
	test -n "$ref" && git update-ref -d "$ref"
}

do_float()
{
	test $# -eq 1 || die "fatal: expected 1 argument."

	# Verify that we have a valid object
	sha1=$(git rev-parse --verify "$1") || exit $?

	# No point in floating HEAD
	test "$sha1" = "$(git rev-parse --verify HEAD)" && exit 0

	if has_upstream
	then
		git merge-base --is-ancestor "$sha1" "@{upstream}" && \
			die "fatal: attempt to modify published commit"
	fi

	# Create a temporary reference to the commit
	name="$(git rev-list --pretty='%f' $sha1 -1 | tail -n1)"
	git update-ref "$patchrefs/$name" "$sha1" || die

	# Remove the patch from the current stack
	git rebase --onto "$1"^ "$1" "$branch" || die

	# Re-apply the commit and clean up
	git cherry-pick "$1" || die
	git update-ref -d "$patchrefs/$name"
}

do_delete()
{
	test $# -eq 1 || die "fatal: expected 1 argument."

	sha1=$(git rev-parse --verify "$1") || exit $?
	ref="$(sha1_to_ref $sha1)"

	test -n "$ref" && git update-ref -d "$ref" || \
		die "warning: no patch deleted."
	git gc --auto
}

do_fixup()
{
	test $# -ge 1 || die "fatal: expected at least 1 argument."

	sha1=$(git rev-parse --verify "$1") || exit $?
	headsha1=$(git rev-parse HEAD)

	if has_upstream
	then
		git merge-base --is-ancestor "$sha1" "@{upstream}" && \
			die "fatal: attempt to modify published commit"
	fi

	if test $# -ge 2
	then
		shift
		git add "$@" || die
	fi

	if test $sha1 = $headsha1
	then
		git commit --amend
	else
		git commit --fixup="$sha1" || die
		git rebase -i --autosquash "$sha1^"
	fi
}

case "$1" in
	series|pop|push|float|delete|fixup)
		command="$1"
		shift
		;;
	'')
		command="series"
		;;
	*)
		die "fatal: Unknown command $1, try git patch -h"
		;;
esac

# Invoke helper function
do_"${command}" $@
