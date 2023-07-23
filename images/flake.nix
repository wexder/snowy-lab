{
  description = "Example";
  inputs.nixpkgs.url = "github:wexder/nixpkgs/netclient";
  inputs.config.url = "github:wexder/snowy-lab/configurations";
  outputs = { self, nixpkgs, config }@attrs: {
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
            "${config}/configurations/machines/vpn/default.nix"
            ({ pkgs, ... }: {
              sdImage.compressImage = false;
            })
          ];
        };
        pivpn = nixpkgs.lib.nixosSystem {
          inherit (baseRpi) system;
          modules = baseRpi.modules ++ [
            "${config}/configurations/machines/vpn/default.nix"
          ];
        };
      };
  };
}

