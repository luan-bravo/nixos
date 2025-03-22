{ config, pkgs, ... }:

{
    home.username = "lul";
    home.homeDirectory = "/home/lul";

    home.packages = with pkgs; [
        ## Shell
        oh-my-zsh
        github-cli
        ripgrep
        ## Programming
            ### JS/TS
            nodejs
            pnpm
            typescript
            ### python
            python3
            ### C
            clang
            lldb
            # gcc # error: collision between `/nix/store/gj9lra51hwhxnhz05jqk5lh03wipamv0-gcc-wrapper-14-20241116/bin/ld' and `/nix/store/rdrbyalncimqir1gjdjwfns370zwi0bf-clang-wrapper-19.1.7/bin/ld'
            # gdb
            ### rust
            rustup
            ### go
            go
            ### zig
            zig
        ## WSL
        wslu
        ## Misc
        aoc-cli
        fortune
        cowsay
        lolcat
        # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })
        # (pkgs.writeShellScriptBin "my-hello" ''
        #   echo "Hello, ${config.home.username}!"
        # '')
    ];

    programs.zsh = {
        enable = true;
        enableCompletion = true;
        syntaxHighlighting.enable = true;
        # zsh-autosuggestions.enable = true;
        oh-my-zsh = {
            enable = true;
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
            del = "mv -t='${config.home.homeDirectory}/.trash";
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
        initExtra = ''
            [[ -f "${config.home.homeDirectory}/.nix-profile/etc/profile.d/hm-session-vars.sh" && source "${config.home.homeDirectory}/.nix-profile/etc/profile.d/hm-session-vars.sh"
        '';
    };

    programs.neovim = {
        enable = true;
        defaultEditor = true;
        plugins = with pkgs.vimPlugins; [
            nvim-lspconfig
            plenary-nvim
            gruvbox-material
        ];
    };

    home.file = {
        # ".zshenv".source = .zshenv;
        # # symlink to the Nix store copy.
        # ".screenrc".source = dotfiles/screenrc;
        # # You can also set the file content immediately.
        # ".gradle/gradle.properties".text = ''
        #   org.gradle.console=verbose
        #   org.gradle.daemon.idletimeout=3600000
        # '';
    };

    home.sessionVariables = {
        nixconfig = "/etc/nixos/configuration.nix";
        IDF_PATH = "/opt/esp-idf";
        GIT_CONFIG_GLOBAL = "${config.home.homeDirectory}/.config/git/.gitconfig";
        BUN_INSTALL = "${config.home.homeDirectory}/.bun";
        ANDROID_HOME = "${config.home.homeDirectory}/Android/sdk";
        FLYCTL_INSTALL = "${config.home.homeDirectory}/.fly";
        PNPM_HOME = "${config.home.homeDirectory}/.local/share/pnpm";
        # "${config.home.homeDirectory}/.bun/_bun"
        # "$IDF_PATH/export.sh"
    };
    home.sessionPath = [
        "${config.home.homeDirectory}/.local/share/adb-fastboot/platform-tools"
        "${config.home.sessionVariables.ANDROID_HOME}/platform-tools"
        "${config.home.sessionVariables.ANDROID_HOME}/emulator"
        "${config.home.sessionVariables.FLYCTL_INSTALL}/bin"
        "${config.home.homeDirectory}/.turso"
    ];

    home.stateVersion = "24.05";
    programs.home-manager.enable = true;
}
