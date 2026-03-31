(use-modules (guix channels))

(list (channel
        (name 'guix)
        (url "https://mirror.sjtu.edu.cn/git/guix.git")
        (branch "master")
        (introduction
         (make-channel-introduction
          "9edb3f66fd807b096b48283debdcddccfea34bad"
          (openpgp-fingerprint
           "BBB0 2DDF 2CEA F6A8 0D1D  E643 A2A0 6DF2 A33A 54FA"))))
      (channel
        (name 'nonguix)
        (url "https://gitlab.com/nonguix/nonguix")
        (branch "master")
        (introduction
         (make-channel-introduction
          "897c1a470da759236cc11798f4e0a5f7d4d59fbc"
          (openpgp-fingerprint
           "2A39 3FFF 68F4 EF7A 3D29  12AF 6F51 20A0 22FB B2D5"))))
      (channel
        (name 'bluebox)
        (branch "main")
        (url "https://codeberg.org/lapislazuli/bluebox")
        (introduction
         (make-channel-introduction
          "63350484aaacc362aea28fb14236019fced4050f"
          (openpgp-fingerprint
           "5132 3571 CEED 988F 52FC 467C 6F98 DBF3 EA7F 4B37"))))
      (channel
        (name 'rosenthal)
        (url "https://codeberg.org/hako/rosenthal.git")
        (branch "trunk")
        (introduction
         (make-channel-introduction
          "7677db76330121a901604dfbad19077893865f35"
          (openpgp-fingerprint
           "13E7 6CD6 E649 C28C 3385  4DF5 5E5A A665 6149 17F7"))))
      (channel
        (name 'sops-guix)
        (url "https://github.com/fishinthecalculator/sops-guix.git")
        (branch "main")
        (introduction
         (make-channel-introduction
          "0bbaf1fdd25266c7df790f65640aaa01e6d2dbc9"
          (openpgp-fingerprint
           "8D10 60B9 6BB8 292E 829B  7249 AED4 1CC1 93B7 01E2"))))
      (channel
        (name 'guixcn)
        (url "https://codeberg.org/guixcn/guix-channel.git")
        (branch "master")
        (introduction
         (make-channel-introduction
          "993d200265630e9c408028a022f32f34acacdf29"
          (openpgp-fingerprint
           "7EBE A494 60CE 5E2C 0875  7FDB 3B5A A993 E1A2 DFF0")))))
