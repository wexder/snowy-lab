{
  description = "Example";
  inputs.nixpkgs.url = "github:wexder/nixpkgs/netclient";
  outputs = { self, nixpkgs }@attrs: {
    nixosConfigurations =
      let
        # Shared base configuration.
        baseRpi = {
          system = "aarch64-linux";
          specialArgs = attrs;
          modules = [
            ({ pkgs, ... }: {
              nix.settings.experimental-features = [ "nix-command" "flakes" ];
            })
          ];

        };
      in
      {
        pivpnIso = nixpkgs.lib.nixosSystem {
          inherit (baseRpi) system;
          modules = baseRpi.modules ++ [
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64-installer.nix"
            "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
            ./machines/vpn/default.nix
            ({ pkgs, ... }: {
              sdImage.compressImage = false;
            })
          ];
        };
        pivpn = nixpkgs.lib.nixosSystem {
          inherit (baseRpi) system;
          modules = baseRpi.modules ++ [
            ./machines/vpn/default.nix
          ];
        };
      };
  };
}

