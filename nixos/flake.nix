{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
    fonts.url = "file://home/samuelhernandes/dotfiles/nixos/fonts";
  };

  outputs = {self, nixpkgs, ...} @inputs: {
    nixosConfigurations = {
      samuelhernandes-nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [ ./configuration.nix ];
      };
    };
  };
}
