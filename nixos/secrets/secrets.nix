let
  wexder = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMkKyMS0O7nzToTh/3LCrwJB++zc29R8U6UlzfzT0xV9";
  users = [ wexder ];

  altostratus = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDViCLCy9aIqaiTlKaHPlPPyJ+PPHZmKYbWMdTVg8pkv";
  polar-fox = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGBTlyCifL26ThYrCF+gx0VP+Fe5eKzc+E3F0NoOf9sD";
  polar-bear = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFUiqS1ZGBpYEdV4D8TSE8/A94tnxLF9YYlUOU3yQHaa";
  snowball = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID6W1y/Xu1VfR6FKxl7yF1XcU3yNFlMDSdFvTrlXfcGu";

  machines = [ altostratus polar-fox polar-bear snowball ];
in
{
  "tailscale.age".publicKeys = users ++ machines;
  "netclient.age".publicKeys = users ++ machines;
  "altostratus_wg_pk.age".publicKeys = users ++ machines;
  "altostratus_wg_pub.age".publicKeys = users ++ machines;
  "transmission_wg_pk.age".publicKeys = users ++ machines;
  "transmission_wg_pub.age".publicKeys = users ++ machines;
}
