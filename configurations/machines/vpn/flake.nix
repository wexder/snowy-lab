{
  description = "Vpn raspberry pi";
  inputs = { };
  outputs = { self }: {
    system = "aarch64-linux";
    modules = [
      ./default.nix
    ];
  };
}
