{
  description = "Vpn raspberry pi";
  inputs = {
    # TODO move to something better
    pihole = {
      url = "github:mindsbackyard/pihole-flake";
    };
    linger = {
      url = "github:mindsbackyard/linger-flake";
    };
  };
  outputs = { self, pihole, linger }: {
    system = "aarch64-linux";
    modules = [
      linger.nixosModules."aarch64-linux".default
      pihole.nixosModules."aarch64-linux".default
      ./default.nix
    ];
  };
}
