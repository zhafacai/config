edit-sub:
    sudo GNUPGHOME=/var/lib/sops sops secrets/sub.yaml

lock:
    guix describe -f channels > channels.lock

upgrade:
    sudo guix time-machine -C channels.lock --  system reconfigure /home/zfc/dots/zfc/system/art.scm -L /home/zfc/dots

update-nix:
    nix profile upgrade dots

update:
    guix pull -C channels.scm
    just lock

rollback:
    sudo guix system roll-back
