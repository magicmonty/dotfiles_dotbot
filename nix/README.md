# Bootstrap nix

```bash
# Fetch and execute `nix` install script
curl -L https://nixos.org/nix/install | sh

# The install script asks you to do the following (this might be different based on the OS you use)
echo ". /home/<USERNAME>/.nix-profile/etc/profile.d/nix.sh" >> ~/.profile
```

# Bootstrap Home-Manager

```bash
nix-channel --add https://github.com/rycee/home-manager/archive/master.tar.gz home-manager
nix-channel --update
nix-shell '<home-manager>' -A install
```

# Install Configs and tools
```bash
# Install `git` so that we can fetch dotfiles from the web
nix-env -i git
git clone https://github.com/magicmonty/dotfiles_dotbot.git ~/.dotfiles

# Remove git (will be installed by home-manager later)
nix-env -e git

# Remove default created `home.nix` configuration and replace with fetched one
ln -s ~/.dotfiles/nix/machines/<MACHINE_NAME>/home.nix /.config/nixpkgs/home.nix

# Install everything as specified in config
home-manager switch
```

# Post-Install

```bash
echo '/home/${USER}/.nix-profile/bin/zsh; exit' >> ~/.profile
```
