{ config, ... }: {
  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  sops.secrets = {
    hashedPassword = { neededForUsers = true; };
    "gh/hosts.yml" = {
      owner = config.users.users.ben.name;
      group = config.users.users.ben.group;
    };
  };
}
