# Catalog defines the systems & services on my network.
{ system }: {
  nodes = {
    snowy-deck = {
      config = ./hosts/snowyDeck.nix;
      hw = ./hw/snowyDeck.nix;
      home = ./home/snowyDeck.nix;
      system = system.x86_64-linux;
    };

    snowball = {
      config = ./hosts/snowball.nix;
      hw = ./hw/snowball.nix;
      home = ./home/snowball.nix;
      system = system.x86_64-linux;
    };

    polar-bear = {
      config = ./hosts/polarBear.nix;
      hw = ./hw/polarBear.nix;
      home = ./home/polarBear.nix;
      system = system.x86_64-linux;
    };

    polar-fox = {
      config = ./hosts/polarFox.nix;
      hw = ./hw/polarFox.nix;
      home = ./home/polarFox.nix;
      system = system.x86_64-linux;
    };

    pivpn = {
      ip = "10.1.1.231";
      config = ./hosts/pivpn.nix;
      hw = ./hw/pivpn.nix;
      home = ./home/pivpn.nix;
      system = system.aarch64-linux;
    };
  };
}
