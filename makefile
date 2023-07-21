build-rpivpn:
	nix --extra-experimental-features nix-command --extra-experimental-features flakes build .#nixosConfigurations.pivpnIso.config.system.build.sdImage
