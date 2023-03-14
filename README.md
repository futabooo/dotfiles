# futabooo's dotfiles
dotfiles, managed by [twpayne/chezmoi](https://github.com/twpayne/chezmoi):house_with_garden:. 

## install

```
$ sh -c "$(curl -fsLS get.chezmoi.io)" --init --apply futabooo
```

### VSCode Dev Containers

Need to add settings to settings.json to use dotfiles.


```
{
  "dotfiles.repository": "your-github-id/your-dotfiles-repo",
  "dotfiles.targetPath": "~/dotfiles",
  "dotfiles.installCommand": "~/dotfiles/install.sh"
}
```
>[Personalizing with dotfile repositories](https://code.visualstudio.com/docs/devcontainers/containers#_personalizing-with-dotfile-repositories)
