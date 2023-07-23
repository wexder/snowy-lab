{
  description = "Vpn raspberry pi";
  inputs.pihole.url = "github:mindsbackyard/pihole-flake";
  outputs = { self, pihole }: {
    system = "aarch64-linux";
    modules = [
      ({ system, ... }: {
        modules = [
          pihole.nixosModules.${system}.default
        ];
      })
      ./default.nix
    ];
  };
}
