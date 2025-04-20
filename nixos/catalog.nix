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

    snowplow = {
      config = ./hosts/snowplow.nix;
      hw = ./hw/snowplow.nix;
      home = ./home/snowplow.nix;
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

    walrus = {
      config = ./hosts/walrus.nix;
      hw = ./hw/walrus.nix;
      home = ./home/walrus.nix;
      system = system.x86_64-linux;
    };
    #
    # test-server = {
    #   config = ./hosts/test-server.nix;
    #   hw = ./hw/test-server.nix;
    #   home = ./home/test-server.nix;
    #   system = system.x86_64-linux;
    # };
  };
}
