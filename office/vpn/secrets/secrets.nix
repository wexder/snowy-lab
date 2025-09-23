let
  wexder = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMkKyMS0O7nzToTh/3LCrwJB++zc29R8U6UlzfzT0xV9";
  users = [ wexder ];

  vpn1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA3OgKxomxS9PuAYStLsO5moeoJAPL+HXgPlFvlupMtk";
  vpn2 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDxnZHGFD2U/if6GvFyYyATcQN8rVFKFkQx2xO7eJBmM";
  machines = [ vpn1 vpn2 ];
in
{
  "oudaddy.age".publicKeys = users ++ machines ++ [ ];
}
