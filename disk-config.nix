{ lib, ... }:
{
  disko.devices = {
    disk.disk1 = {
      device = "/dev/disk/by-id/nvme-Corsair_MP600_MINI_A66HB33003UWXW"; # 1tb ssd
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            name = "boot";
            size = "1M";
            type = "EF02";
          };
          esp = {
            name = "ESP";
            size = "500M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          luks = {
            name = "root";
            size = "100%";
            content = {
              type = "luks";
              name = "nixos-encrypted";
              extraOpenArgs = [];
              settings = {
                allowDiscards = true;
                # Not specifying a passwordFile lets me interactively enter a password
              };
              content = {
                type = "lvm_pv";
                vg = "pool";
              };
            };
          };
        };
      };
    };

    lvm_vg = {
      pool = {
        type = "lvm_vg";
        lvs = {
          root = {
            size = "100%"; # expand later if needed
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              mountOptions = [
                "defaults"
              ];
            };
          };
        };
      };
    };
  };
}
