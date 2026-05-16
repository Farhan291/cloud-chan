let
  me = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBT9k5Xs55jgP9TfndMA8hGhZyec0lQeJY+oDlBYfeuW agenix secrets key";

in
{
  "postgres.env.age".publicKeys = [ me ];
  "umami.env.age".publicKeys = [ me ];
  "kcet.env.age".publicKeys = [ me ];
}
