{ config, lib, pkgs, inputs, ... }:

{
    imports = [
        ## Flake input
        inputs.nixos-wsl.nixosModules.default
        inputs.home-manager.nixosModules.default
       ./hardware-configuration.nix
    ];
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    ## WSL
    wsl.enable = true;
    wsl.defaultUser = "lul";
    system.stateVersion = "24.05";

    environment.systemPackages = with pkgs; [
        ## System
        wslu
        # writeShellScriptBin
        home-manager
        ## Shell env
        # onwsl alacritty
        zsh
        tmux
        git
        github-cli
        neovim
        vim
        ## System others
        networkmanager
        iwd
        pipewire
        ## GUI
        # onwsl i3
        # onwsl dwm
        ## CLI
        htop
        wget
        clang
        lldb
    ];

    environment.variables = {
        EDITOR = "${pkgs.neovim}/bin/nvim";
        SUDO_EDITOR = "${pkgs.neovim}/bin/nvim";
    };

    ## Programs
    programs.neovim = {
        enable = true;
        defaultEditor = true;
    };
    programs.zsh.enable = true;

    ## Users
    users.users.lul = {
       isNormalUser = true;
       home = "/home/lul";
       shell = pkgs.zsh;
       extraGroups = [ "networkmanager" "wheel" ];
    };
    home-manager = {
        extraSpecialArgs = { inherit inputs; };
        users = {
            "lul" = import ./home.nix;
        };
    };
}
