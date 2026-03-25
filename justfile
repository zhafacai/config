update:
    sudo guix system reconfigure /home/zfc/dots/zfc/system/art.scm -L /home/zfc/dots

edit-sub:
    sudo GNUPGHOME=/var/lib/sops sops secrets/sub.yaml
