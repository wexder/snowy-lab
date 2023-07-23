{
  description = "Vpn raspberry pi";
  inputs.pihole.url = "github:mindsbackyard/pihole-flake";
  outputs = { self, nixpkgs, config, pihole }: {
    modules = [
      "./default.nix"
    ];
  };
}

