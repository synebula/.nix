{ config, pkgs, hostname, ... }: {
  networking = {
    hostId = "5def12be";
    hostName = "${hostname}";

    wireless.enable = false; # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    networkmanager = {
      enable = true;
    };

    enableIPv6 = true;

    # Set up bridge network
    interfaces.eno1 = {
      useDHCP = false;
    };

    bridges = {
      br0 = { interfaces = [ "eno1" ]; };
    };

    interfaces.br0 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "10.7.43.20";
          prefixLength = 32;
        }
      ];
    };
    defaultGateway = {
      address = "10.7.43.1";
      interface = "br0";
    };
    nameservers = [ "119.29.29.29" "223.5.5.5" ];
  };
}
