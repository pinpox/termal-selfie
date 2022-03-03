
```
Back of Printer (DB25)
  (Epson TM-T88II)

       _
     _/ │
    /   │13
 25│    │                            ┌───────────────────────────────┐
   │    │12                          │          MAX3232 Board        │
 24│    │                            │                               │
   │    │11                          │       o                       │          
 23│    │                            │   o                 VCC  o ───┼──────────
   │    │10                          │       o                       │          
 22│    │                            │   o                 RXD  o ───┼──────────
   │    │9                           │       o───────┐               │          
 21│    │                            │   o           │     TXD  o ───┼──────────
   │    │8                           │       o───┐   │               │          
 20│    │                            │   o       │   │     GND  o ───┼─────┬────
   │    │7──────────────────┐        │       o   │   │               │     │    
 19│    │                   │        │           │   │               │     │
   │    │6                  │        └───────────┼───┼───────────────┘     │
 18│    │                   │                    │   │                     │
   │    │5                  │                    │   │                     │
 17│    │                   │                    │   │                     │
   │    │4                  └─────────────────── ├───┼─────────────────────┘
 16│    │                                        │   │
   │    │3 ───────────────────────────────────── │ ──┘
 15│    │                                        │
   │    │2 ──────────────────────────────────────┘
 14│    │
    \_  │1
      \_│
```

# Take photo and print

```bash
nix run
```

# Update config

```bash
nixos-rebuild switch --flake '.#photobooth-pi' --target-host 'root@192.168.2.5' -L
```


# Build sd-card image

```bash
nix build .#raspi-image
sudo dd if=result/sd-image/raspi-image-...-aarch64-linux.img of=/dev/sdX status=progress bs=4M oflag=sync
```
