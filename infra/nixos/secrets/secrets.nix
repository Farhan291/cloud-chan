let
  me = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBT9k5Xs55jgP9TfndMA8hGhZyec0lQeJY+oDlBYfeuW agenix secrets key";
  server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFsGHxVmg2CpCJLZpwX/Dnqbk/lAKWGM1Z2sf7A4gQIV root@nixchan";
  all = [
    me
    server
  ];
in
{
  "postgres.env.age".publicKeys = all;
  "umami.env.age".publicKeys = all;
  "kcet.env.age".publicKeys = all;
  "hermes.env.age".publicKeys = all;
}
