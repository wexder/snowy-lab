{
  description = "Machine images configurations";
  inputs = {
    nixpkgs.url = "github:wexder/nixpkgs/netclient";
    config.url = "github:wexder/snowy-lab";
    vpn = {
      url = "github:wexder/snowy-lab/5d0ff077?dir=configurations/machines/vpn";
    };
  };
  outputs = { self, nixpkgs, config, vpn }: {
    nixosConfigurations =
      let
        # Shared base configuration.
        base = {
          modules = [
            ({ pkgs, ... }: {
              nix.settings.experimental-features = [ "nix-command" "flakes" ];
              time.timeZone = "Europe/Prague";
            })
          ];

        };
      in
      {
        pivpnIso = nixpkgs.lib.nixosSystem {
          inherit (vpn) system;
          modules = vpn.modules ++ base.modules ++ [
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64-installer.nix"
            "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
            ./boot.nix
            ({ pkgs, ... }: {
              sdImage.compressImage = false;
            })
          ];
        };
        pivpn = nixpkgs.lib.nixosSystem {
          inherit (vpn) system;
          modules = vpn.modules ++ base.modules ++ [
          ];
        };
      };
  };
}
