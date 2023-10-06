{ config, pkgs, lib, username, ... }:
{

  imports = [
    ./hooks.nix
  ];
  
  config = {

    # Ref: https://nixos.wiki/wiki/NixOps/Virtualization

    boot = {
      kernelModules = [ "kvm-intel" "vfio" "vfio_iommu_type1" "vfio_pci" "vfio_virqfd" ];
      kernelParams = [ "intel_iommu=on" "iommu=pt" ];
      # extraModprobeConfig = "options vfio-pci ids=8086:1901,10de:1b81,10de:10f0";
    };
    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        ovmf.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
        swtpm.enable = true;
        runAsRoot = false;
      };
    };

    # tpm
    security.tpm2 = {
      pkcs11.enable = true; # expose /run/current-system/sw/lib/libtpm2_pkcs11.so
      enable = true;
      tctiEnvironment.enable = true; # TPM2TOOLS_TCTI and TPM2_PKCS11_TCTI env variables
    };

    # Ref: https://nixos.wiki/wiki/Virt-manager

    environment.systemPackages = with pkgs; [
      virt-manager
      virglrenderer
      #virt-manager-qt
    ];

    users.users.${username}.extraGroups = lib.mkIf config.virtualisation.libvirtd.enable [ "libvirtd" "tss" ];
  };
}
