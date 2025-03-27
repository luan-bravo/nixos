{ config, pkgs, inputs, ... }:

{
    imports = [
        ## Flake input
        inputs.nixos-wsl.nixosModules.default
        ./hardware-configuration.nix
    ];
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    ## WSL
    wsl.enable = true;
    wsl.defaultUser = "lul";
    system.stateVersion = "24.05";

    environment.systemPackages = with pkgs; [
        ## Host specific
        wslu
        ## CLI
        htop
        btop
        bat
        wget
        clang
        lldb
        gcc
        gdb
        gnumake
        ## Shell env
        # onwsl alacritty
        eza
        tmux
        zsh
            oh-my-zsh
            ripgrep
            fzf
            zoxide
        git
        github-cli
        vim
        neovim
            luarocks
            lua5_1
            unzip
            openssl
        ## Hardware
        networkmanager
        iwd
        pipewire
        ## GUI
        # onwsl i3
        # onwsl dwm
        ## Programming
            ### JS/TS
            nodejs
            pnpm
            typescript
            ### python
            python3
            ### C
            # gcc # error: collision between `/nix/store/gj9lra51hwhxnhz05jqk5lh03wipamv0-gcc-wrapper-14-20241116/bin/ld' and `/nix/store/rdrbyalncimqir1gjdjwfns370zwi0bf-clang-wrapper-19.1.7/bin/ld'
            # gdb
            ### rust
            rustup
            ### go
            go
            ### zig
            zig
        ## Misc
        aoc-cli
        fortune
        cowsay
        lolcat
        neofetch
        # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
        # (pkgs.writeShellScriptBin "my-hello" ''
        #   echo "Hello, ${config.home.username}!"
        # '')
    ];

    environment.variables = {
        nixconfig = "/etc/nixos/";

        EDITOR = "${pkgs.neovim}/bin/nvim";
        SUDO_EDITOR = "${pkgs.neovim}/bin/nvim";

        FZF_BASE = "${pkgs.fzf}/bin/fzf";
        OPENSSL_DIR = "${pkgs.openssl}/bin/openssl";

        IDF_PATH = "/opt/esp-idf";
        GIT_CONFIG_GLOBAL = "${config.users.users.lul.home}/.config/git/.gitconfig";
        BUN_INSTALL = "${config.users.users.lul.home}/.bun";
        ANDROID_HOME = "${config.users.users.lul.home}/Android/sdk";
        FLYCTL_INSTALL = "${config.users.users.lul.home}/.fly";
        PNPM_HOME = "${config.users.users.lul.home}/.local/share/pnpm";
        # TODO: figure out why 'builtins.concatStrings' didn't work
        # PATH = "$PATH:${environment.variables.ANDROID_HOME}/platform-tool:${environment.variables.ANDROID_HOME}/emulato:${environment.variables.FLYCTL_INSTALL}/bin:${config.users.users.lul.home}/.local/share/adb-fastboot/platform-tools:${config.users.users.lul.home}/.turso";
        # "${config.home.homeDirectory}/.bun/_bun"
        # "$IDF_PATH/export.sh"
    };

    ## Programs
    programs.neovim = {
        enable = true;
        defaultEditor = true;
    };

    programs.zsh = {
        enable = true;
        enableCompletion = true;
        syntaxHighlighting.enable = true;

        ohMyZsh = {
            enable = true;
            custom = "/etc/nixos/modules/programs/zsh/custom";
            theme = "gruvbox";
            plugins = [
                "git"
                "zoxide"
                "fzf"
                "man"
                "tldr"
                "gh"
                "archlinux"
                "arduino-cli"
                "npm"
                "bun"
                "tmux"
                "rust"
                "python"
            ];
        };

        shellAliases = {
            ## System
            c = "clear"; ## Clean your room
            q = "exit";
            stdn = "sudo shutdown now";
            reboot = "sudo shutdown --reboot now";
            rebt = "sudo shutdown --reboot now";
            il = "i3lock";
            ## Programs
            nv = "nvim";
            v = "nvim";
            py = "python";
            # hx = "helix"; ## not that great. nvim ftw
            ino = "arduino-cli";
            del = "mv -t='${config.users.users.lul.home}/.trash";
            ## Git
            gaa = "git add -A";
            gap = "git add -p";
            gs = "git status";
            gc = "git commit";
            gcm = "git commit -m";
            gcam = "git commit -am";
            gp = "git push";
            gcl= "git clone";
            gclr= "git clone --recurse-submodules";
            gsync = "git add -p && git commit -v && git push";
            ## Eza
            x = "eza -l -h -n -s='type' --icons";
            xa = "x -a";
            xt = "x -T";
            xta = "xa -T";
            ## Fix overscan (when using old HDMI TV as monitor)
            osfix = "xrandr --output HDMI-A-0 --set underscan on & xrandr --output HDMI-A-0 --set 'underscan hborder' 80 --set 'underscan vborder' 40";
            ## IWD wifi manager aliases;
            iwpower = "rfkill unblock all && iwctl device wlan0 set-property Powered on";
            iwshow = "iwctl station wlan0 show";
            iwscan = "iwctl station wlan0 get-networks";
            ## Keyboard layouts;
            huebr = "setxkbmap br";
            merica = "setxkbmap us";
            inter = "setxkbmap -layout us -variant intl";
        };

        shellInit = /*bash*/ ''
            ## Personal paths and variables
            export DOTDIR="$HOME/.config"
            export DOTFILES="$HOME/.config"
            export GH="https://github.com"
            export NOTES="$HOME/notes"
            export TODOFILE="$NOTES/todo.md"

            ## Colors
            export nc=$'\033[0m' # no coloring
            export black=$'\033[0;30m'
            export white=$'\033[1;37m'
            export dark_gray=$'\033[0;30m'
            export gray=$'\033[0;37m'
            export red=$'\033[1;31m'
            export yellow=$'\033[1;33m'
            export green=$'\033[1;32m'
            export blue=$'\033[1;34m'
            export purple=$'\033[1;35m'
            export cyan=$'\033[1;36m'
            export dark_red=$'\033[0;31m'
            export dark_green=$'\033[0;32m'
            export _brownorange=$'\033[0;33m'
            export dark_blue=$'\033[0;34m'
            export dark_purple=$'\033[0;35m'
            export dark_cyan=$'\033[0;36m'

            export PATH="$PATH:${config.users.users.lul.home}/.local/share/adb-fastboot/platform-tools"
            export PATH="$PATH:${config.users.users.lul.home}/.turso"
            export PATH="$PATH:${config.environment.variables.ANDROID_HOME}/platform-tools"
            export PATH="$PATH:${config.environment.variables.ANDROID_HOME}/emulator"
            export PATH="$PATH:${config.environment.variables.FLYCTL_INSTALL}/bin"
        '';
    };

    programs.bash = {
        shellAliases = config.programs.zsh.shellAliases;
    };

    ## Users
    users.users.lul = {
        isNormalUser = true;
        uid = 1000;
        home = "/home/lul";
        shell = pkgs.zsh;
        extraGroups = [ "networkmanager" "wheel" ];
    };
    users.users.root.shell = pkgs.zsh;
    systemd.user.services.dbus.enable = true;
}
