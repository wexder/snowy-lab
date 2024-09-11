let
  wexder = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMkKyMS0O7nzToTh/3LCrwJB++zc29R8U6UlzfzT0xV9";
  users = [ wexder ];

  polar-fox = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGBTlyCifL26ThYrCF+gx0VP+Fe5eKzc+E3F0NoOf9sD";
  polar-bear = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFUiqS1ZGBpYEdV4D8TSE8/A94tnxLF9YYlUOU3yQHaa";
  snowball = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID6W1y/Xu1VfR6FKxl7yF1XcU3yNFlMDSdFvTrlXfcGu";

  machines = [ polar-fox polar-bear snowball ];
in
{
  "tailscale.age".publicKeys = users ++ machines;
  "netclient.age".publicKeys = users ++ machines;
  "transmission_wg_pk.age".publicKeys = users ++ machines;
  "transmission_wg_pub.age".publicKeys = users ++ machines;

  "mcc_openvpn.age".publicKeys = users ++ machines;
  "mcc_openvpn_auth.age".publicKeys = users ++ machines;

  "polar_fox_cg_wg_pk.age".publicKeys = users ++ machines;
  "polar_fox_cg_wg_servers_pub.age".publicKeys = users ++ machines;
}
