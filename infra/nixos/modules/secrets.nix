{ ... }:
{
  age.secrets = {
    postgres-env = {
      file = ../secrets/postgres.env.age;
      path = "/run/secrets/postgres.env";
    };
    umami-env = {
      file = ../secrets/umami.env.age;
      path = "/run/secrets/umami.env";
    };
    kcet-env = {
      file = ../secrets/kcet.env.age;
      path = "/run/secrets/kcet.env";
    };
  };
}
