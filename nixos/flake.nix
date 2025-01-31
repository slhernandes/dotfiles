{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
  };

  outputs = {self, nixpkgs, ...}: {
    nixosConfigurations = {
      samuelhernandes-nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./configuration.nix ];
      };
    };
  };
}
