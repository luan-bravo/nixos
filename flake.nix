{
    description = "Nixos config flake";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

    };


    outputs = { self, nixpkgs, nixos-wsl, ... }@inputs:
    let
        system = "x86_64-linux";
        timezone = "Brazil/East";
        locale = "en_US.UTF-8";
    in {
        nixosConfigurations = {
            ## TODO: generate a default config w/o the wsl crap
            default = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                specialArgs = {
                    inherit inputs;
                    inherit system;
                    inherit timezone;
                    inherit locale;
                };
                modules = [
                    inputs.home-manager.nixosModules.default
                    ./hosts/default/configuration.nix
                ];
            };
            wsl_x380 = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                specialArgs = {
                    inherit inputs;
                    inherit system;
                    inherit timezone;
                    inherit locale;
                };
                modules = [
                    nixos-wsl.nixosModules.default
                    ./hosts/wsl_x380/configuration.nix
                    {
                        system.stateVersion = "24.05";
                        wsl.enable = true;
                    }
                ];
            };
            wsl_a320m = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                specialArgs = {
                    inherit inputs;
                    inherit system;
                    inherit timezone;
                    inherit locale;
                };
                modules = [
                    nixos-wsl.nixosModules.default
                    ./hosts/wsl_a320m/configuration.nix
                    {
                        system.stateVersion = "24.05";
                        wsl.enable = true;
                    }
                ];
            };
        };
    };
}
