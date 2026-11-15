# Data disks, kept on reinstall (only the system NVMe is formatted).
{ pkgs, ... }:
{
  boot.swraid = {
    enable = true;
    # Events go to the journal: `journalctl -t mdadm-event`. PROGRAM takes no arguments, hence the script.
    mdadmConf = ''
      ARRAY /dev/md0 metadata=1.2 UUID=1510749b:ccdd7236:58d93b2b:ccd60c84
      PROGRAM ${pkgs.writeShellScript "mdadm-event" ''${pkgs.util-linux}/bin/logger -p warning -t mdadm-event "$@"''}
    '';
  };

  fileSystems."/mnt/DataDrive" = {
    device = "/dev/disk/by-uuid/2eb312ad-93fc-4592-b427-2e9504a99f04"; # md0
    fsType = "ext4";
    options = [ "nofail" ];
  };

  fileSystems."/mnt/host" = {
    device = "/dev/disk/by-uuid/33e48f5a-4c40-4f37-b424-000d76b86f30";
    fsType = "ext4";
    options = [ "nofail" ];
  };

  fileSystems."/home/oliver/Documents" = {
    device = "/dev/disk/by-uuid/68ba48ec-12a3-4471-8dd0-e9e770a5dfd9";
    fsType = "ext4";
  };

  boot.tmp.useTmpfs = true;
}
