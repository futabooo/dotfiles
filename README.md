# futabooo's dotfiles

![test](https://github.com/futabooo/dotfiles/actions/workflows/test.yaml/badge.svg)

dotfiles, managed by [twpayne/chezmoi](https://github.com/twpayne/chezmoi):house_with_garden:

## install

```
$ sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply futabooo
```

### VSCode Dev Containers

can also use `postCreateCommand` in your devcontainer.json instead manually.

```
  "postCreateCommand": "sh -c \"$(curl -fsLS get.chezmoi.io)\" -- init --apply futabooo",
```