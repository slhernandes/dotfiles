{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-24.11";
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
# temporary fonts url
    fonts.url = "git+file:///home/samuelhernandes/fonts";
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
