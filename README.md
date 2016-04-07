# Git Patch

Git-patch provides a set of commands to manipulate commits as if they were a
stack of patches, similar to stacked-git. The key difference is that git-patch
is intended to interoperate with **git**. Git-patch should work with any
version of git from 1.8.0 onwards.

## Usage
See the man page for a fuller description, the supported commands are:
```
git patch series
git patch pop commit-ish
git patch push commit-ish
git patch float commit-ish
```

## Installation
```
autoreconf -fvi
./configure
make
make install
```

### Without man page
```
autoreconf -fvi
./configure
make git-patch
make install-exec
```
