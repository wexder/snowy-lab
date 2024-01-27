#######################################################
#                                                     #
#   o-o                              o          o     #
#  |                                 |          |     #
#   o-o  o-o  o-o o   o   o o  o     |      oo  O-o   #
#      | |  | | |  \ / \ /  |  |     |     / |  |  |  #
#  o--o  o  o o-o   o   o   o--O     O---o o-o- o-o   #
#                              |                      #
#                           o--o                      #
#                                                     #
#######################################################

{ config, pkgs, ... }:

{
  imports = [ ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
