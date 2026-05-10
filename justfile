edit-sub:
    sudo GNUPGHOME=/var/lib/sops sops secrets/sub.yaml

lock:
    guix describe -f channels > channels.lock

upgrade:
    sudo guix time-machine -C channels.lock --  system reconfigure mods/zfc/system/art.scm -L mods

update-nix:
    nix profile upgrade config

update:
    guix pull -C channels.scm
    just lock

rollback:
    sudo guix system roll-back
