{ config, lib, pkgs, inputs, ... }:

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
        # autosuggestions.enable = true;
        ohMyZsh = {
            enable = true;
            theme = "funky";
            plugins = [
                "git"
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
            export DOTDIR="$HOME/.config"
            export ZDOTDIR="$DOTDIR/zsh"
            export ZSH_CUSTOM="$ZDOTDIR/custom"
            export ZSH="$ZDOTDIR/ohmyzsh"
            # export ZSH_THEME="gruvbox"
# personal paths and variables
            export GH="https://github.com"
            export NOTES="$HOME/notes"
            export TODOFILE="$NOTES/todo.md"
# colors
            export nc=$'\033[0m' # no coloring
            export red=$'\033[1;31m'
            export yellow=$'\033[1;33m'
            export green=$'\033[1;32m'
            : << 'COLORS'
            Black        0;30
            Red          0;31
            Green        0;32
            Brown/Orange 0;33
            Blue         0;34
            Purple       0;35
            Cyan         0;36
            Light Gray   0;37
            Dark Gray     0;30
            Light Red     1;31
            Light Green   1;32
            Yellow        1;33
            Light Blue    1;34
            Light Purple  1;35
            Light Cyan    1;36
            White         1;37
            COLORS
            [[ -f "${config.users.users.lul.home}/.nix-profile/etc/profile.d/hm-session-vars.sh" && source "${config.users.users.lul.home}/.nix-profile/etc/profile.d/hm-session-vars.sh"
            export ZSH_CUSTOM="/etc/nixos/modules/zsh/custom"
            export PATH="$PATH:${config.users.users.lul.home}/.local/share/adb-fastboot/platform-tools"
            export PATH="$PATH:${config.users.users.lul.home}/.turso"
            export PATH="$PATH:${config.environment.variables.ANDROID_HOME}/platform-tools"
            export PATH="$PATH:${config.environment.variables.ANDROID_HOME}/emulator"
            export PATH="$PATH:${config.environment.variables.FLYCTL_INSTALL}/bin" ];
        '';
    };

    programs.bash = {
        # enable = true;
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
    systemd.user.services.dbus.enable = true;
}
