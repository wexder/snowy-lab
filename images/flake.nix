{
  description = "Machine images configurations";
  inputs.nixpkgs.url = "github:wexder/nixpkgs/netclient";
  inputs.config.url = "github:wexder/snowy-lab";
  inputs.vpn.url = "github:wexder/snowy-lab?dir=configurations/machines/vpn";
  outputs = { self, nixpkgs, config, vpn }@attrs: {
    nixosConfigurations =
      let
        # Shared base configuration.
        base = {
          modules = [
            ({ pkgs, ... }: {
              nix.settings.experimental-features = [ "nix-command" "flakes" ];
            })
          ];

        };
        baseRpi = {
          system = "aarch64-linux";
          specialArgs = attrs;
          modules = [ ];
        };
      in
      {
        pivpnIso = nixpkgs.lib.nixosSystem {
          inherit (baseRpi) system;
          modules = vpn.module ++ base.modules ++ baseRpi.modules ++ [
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64-installer.nix"
            "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
            ./boot.nix
            ({ pkgs, ... }: {
              sdImage.compressImage = false;
            })
          ];
        };
        pivpn = nixpkgs.lib.nixosSystem {
          inherit (baseRpi) system;
          modules = vpn.module ++ base.modules ++ baseRpi.modules ++ [
            "${config}/configurations/machines/vpn/default.nix"
          ];
        };
      };
  };
}

