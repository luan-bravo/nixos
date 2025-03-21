# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

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

    system.stateVersion = "25.05";

    environment.systemPackages = with pkgs; [
        ## Shell env
        # onwsl alacritty
        zsh
        tmux
        git
        github-cli
        neovim
        vim

        ## Other shell pkgs
        wget

        ## System
        networkmanager
        iwd
        pipewire

        ## GUI
        # onwsl i3
        # onwsl dwm

        ## Other pkgs
        htop
        home-manager
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
