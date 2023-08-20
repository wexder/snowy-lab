# Catalog defines the systems & services on my network.
{ system }: {
  nodes = {
    snowy-deck = {
      config = ./hosts/snowyDeck.nix;
      hw = ./hw/snowyDeck.nix;
      system = system.x86_64-linux;
    };

    pivpn = {
      ip = "10.1.1.231";
      config = ./hosts/pivpn.nix;
      hw = ./hw/pivpn.nix;
      system = system.aarch64-linux;
    };
  };
}
