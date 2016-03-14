# Git Patch

Git-patch provides a set of commands to manipulate commits as if they were a
stack of patches, similar to stacked-git. The key difference is that git-patch
is intended to interoperate with **git**.

## Usage
See the man page for a fuller description, the supported commands are:
```
git patch series
git patch pop commit-ish
git patch push commit-ish
git patch float commit-ish
```

## Installation
### From tarball
```
./configure
make
make install
```

### From repository
```
autoreconf -fvi
./configure
make
make install
```

## Without man page
```
./configure
make git-patch
make install-exec
```
