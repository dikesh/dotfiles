# Config

<https://github.com/user-attachments/assets/44ed8579-98bb-4c41-8a83-58ada4922a3f>

  - Compositor: niri
  - Terminal: kitty
  - Shell: nushell

### Tools / Fonts

* Build / Manually Install
  - paru
  - mise
  - uv
  - aws-cli-v2
  - Google Sans Code
* Pacman
  - bat
  - bluez-utils 
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
  - kitty
  - lazygit
  - less
  - ly
  - mako
  - mpv mpv-mpris
  - nautilus
  - neovim
  - niri
  - noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra
  - nushell
  - nwg-look
  - pacman-contrib
  - papirus-icon-theme
  - pipewire-alsa pipewire-audio pipewire-pulse
  - playerctl
  - postgresql - [Setup](https://gist.github.com/NickMcSweeney/3444ce99209ee9bd9393ae6ab48599d8)
  - ripgrep
  - rofi-wayland - [Launchers - Only install fonts with `setup.sh`](https://github.com/adi1090x/rofi)
  - stow
  - swaybg
  - terraform
  - transmission-cli
  - ttf-hack-nerd
  - udisks2
  - unzip
  - wl-clipboard
  - xwayland-satellite
  - yazi ffmpegthumbnailer unarchiver
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
