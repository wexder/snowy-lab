# Fun with flakes ❄️

Repo base around playing with nixos, nix and flakes. Trying to build my lab partially in nixos and maybe with more.

# VPN 🕸️
Currently I can build my raspberry pi that acts as gateway into the overlay network made with [netmaker](https://github.com/gravitl/netmaker).
The sd image is done in a way where the whole config is also transferred and can then be iterated on.
This has the advantage of having fully configured sd image right away.
To build the image
```bash
make build-rpivpn
```
