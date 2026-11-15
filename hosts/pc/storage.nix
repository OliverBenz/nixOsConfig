# Disks as on the Manjaro install this config replaces. Only the system NVMe gets formatted on install;
# these keep their data and are mounted by UUID.
{ pkgs, ... }:
{
  # Data: RAID 1 over sdb1 + sdc1, assembled by its array UUID.
  boot.swraid = {
    enable = true;
    mdadmConf = ''
      ARRAY /dev/md0 metadata=1.2 UUID=1510749b:ccdd7236:58d93b2b:ccd60c84
      # RAID events (e.g. a failed disk) go to the journal: `journalctl -t mdadm-event`. No mail server here.
      # mdadm takes a program without arguments, hence the wrapper script.
      PROGRAM ${pkgs.writeShellScript "mdadm-event" ''${pkgs.util-linux}/bin/logger -p warning -t mdadm-event "$@"''}
    '';
  };

  fileSystems."/mnt/DataDrive" = {
    device = "/dev/disk/by-uuid/2eb312ad-93fc-4592-b427-2e9504a99f04"; # ext4 on md0
    fsType = "ext4";
    options = [ "nofail" ]; # A missing data disk must not stop the PC from booting.
  };

  # Server configs and container data (Gitea, Caddy, Nextcloud, ...).
  fileSystems."/mnt/host" = {
    device = "/dev/disk/by-uuid/33e48f5a-4c40-4f37-b424-000d76b86f30";
    fsType = "ext4";
    options = [ "nofail" ];
  };

  # Second NVMe.
  fileSystems."/home/oliver/Documents" = {
    device = "/dev/disk/by-uuid/68ba48ec-12a3-4471-8dd0-e9e770a5dfd9";
    fsType = "ext4";
  };

  boot.tmp.useTmpfs = true;
}
