{
    description = "Nixos config flake";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        nixos-wsl.url = "github:nix-community/NixOS-WSL/main";

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };
    outputs = { self, nixpkgs, nixos-wsl, ... }@inputs: {
        nixosConfigurations = {
            ## TODO: generate a default config w/o the wsl crap
            default = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                specialArgs = {inherit inputs;};
                modules = [
                    inputs.home-manager.nixosModules.default
                    ./hosts/default/configuration.nix
                ];
            };
            wsl = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                specialArgs = {inherit inputs;};
                modules = [
                    inputs.home-manager.nixosModules.default
                    nixos-wsl.nixosModules.default
                    ./hosts/wsl/configuration.nix
                    {
                        system.stateVersion = "25.05";
                        wsl.enable = true;
                    }
                ];
            };
        };
    };
}
