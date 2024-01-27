{
  description = "Machine images configurations";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    config = {
      url = "github:wexder/snowy-lab";
    };
  };
  outputs = { self, nixpkgs, config }: {
    nixosConfigurations = config.nixosConfigurations;
  };
}
