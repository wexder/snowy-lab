{
  description = "Vpn raspberry pi";
  inputs.pihole.url = "github:mindsbackyard/pihole-flake";
  outputs = { self, pihole }: {
    modules = [
      "${self}/default.nix"
    ];
  };
}

