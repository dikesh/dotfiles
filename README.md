# Config

<https://github.com/user-attachments/assets/a8b79aa8-3e4a-491e-9b49-f0f1d881d806>

  - Compositor: niri
  - Terminal: kitty
  - Shell: nushell

### Tools / Fonts

* Build / Manually Install
  - mise
  - uv
  - aws-cli-v2
  - Google Sans Code
* Pacman
  - bat
  - btop
  - dart-sass
  - docker docker-buildx
  - fd
  - feh imagemagick
  - fzf
  - git
  - gnome-bluetooth-3.0
  - grim slurp satty
  - gum
  - intel-media-driver
  - iwd
  - kitty
  - lazygit
  - less
  - ly
  - mako
  - mpv mpv-mpris
  - neovim
  - niri
  - noto-fonts noto-fonts-emoji noto-fonts-cjk noto-fonts-extra
  - nushell
  - nwg-look
  - pacman-contrib
  - papirus-icon-theme
  - playerctl
  - postgresql - [Setup](https://gist.github.com/NickMcSweeney/3444ce99209ee9bd9393ae6ab48599d8)
  - ripgrep
  - rofi - [Launchers - Only install fonts with `setup.sh`](https://github.com/adi1090x/rofi)
  - stow
  - swaybg
  - terraform
  - transmission-cli
  - ttf-hack-nerd
  - wl-clipboard
  - xwayland-satellite
  - yazi ffmpegthumbnailer unarchiver
  - zip unzip
  - zoxide
* Paru
  - appflowy-bin
  - awsvpnclient
  - brave-bin
  - bun-bin
  - carapace-bin
  - google-chrome
  - google-cloud-cli
  - ignis
  - localsend-bin
  - mongodb-bin mongosh-bin
  - slack-desktop
  - swaylock-effects
  - wl-screenrec
- UV tools
  - pynvim
  - yt-dlp[default,curl-cffi]

___


### Paru Installation

```
sudo pacman -S --needed base-devel
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
```

___


### System backups

  - ~/.aws
  - ~/.keys
  - ~/.ssh
  - Dotfiles
  - Codes + code scripts + .env + test files
  - Terraform states and variables
  - API Testing repo + vars.env files
  - Appflowy data
  - Scripts
  - Brave bookmarks
  - Shell History
  - Clipboards
  - Documents
  - Downloads
  - Music
  - Pictures
  - Videos

___

### Post Arch Installation Steps

  - Install `git`, `stow`, `ly`, `niri`
  - Enable `ly.service` and restart
  - Clone dotfiles from git and sync using stow
  - Install rest of the packages
  - Set Icon themes to Papirus Dark using GTK Settings i.e. nwg-look
