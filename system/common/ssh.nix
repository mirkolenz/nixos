{...}: {
  # update: ssh-keyscan -t ed25519 URL_OR_IP
  programs.ssh.knownHosts = {
    "github.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
    "gitlab.com".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf";
    "gitlab.rlp.net".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMqZhJQejjLLmvCk0wEgSDN5+6oCgp3ggKw0MBl5VDXI";
    "136.199.130.136".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFjEIHTnzAhYtFJhcXrWm7OuzWli/YUNMsq9xmlEjUfE";
    "10.16.2.22".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP5n2KpAU3E8iHy56vNURjh7E3l0EjkZ6BX450Z44hiH";
    "10.16.2.23".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGR8BCsN02425GzSv1PQNhUGx0rm8D4aKSZh8ut5OJ6/";
  };
}
