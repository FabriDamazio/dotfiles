# How to version Gnome config

## Dumping Gnome configuration

To dump all gnome config, use this command:

```bash
dconf dump / > ~/dotfiles/gnome/gnome-config.ini
```

## Restoring configuration

To apply previous saved configuration:

```bash
dconf load / < gnome-config.ini
```
