# futabooo's dotfiles

![test](https://github.com/futabooo/dotfiles/actions/workflows/test.yaml/badge.svg)

dotfiles, managed by [twpayne/chezmoi](https://github.com/twpayne/chezmoi):house_with_garden:

## install

```
$ sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply futabooo
```

### VSCode Dev Containers

use `postCreateCommand` in devcontainer.json

```
  "postCreateCommand": "sh -c \"$(curl -fsLS get.chezmoi.io)\" -- init --apply futabooo",
```