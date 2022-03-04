
```
Back of Printer (DB25)
  (Epson TM-T88II)

       _
     _/ │
    /   │13
 25│    │
   │    │12            ┌─────────────────────────────┐
 24│    │              │        MAX3232 Board        │
   │    │11   ┌────────┼───────o                     │
 23│    │     │        │   o               VCC  o ───┼─────┐
   │    │10   │        │       o                     │     │
 22│    │     │        │   o               RXD  o ───┼───────────┐
   │    │9    │        │       o                     │     │     │
 21│    │     │        │   o               TXD  o ───┼─────────┐ │
   │    │8    │  ┌─────┼───────o                     │     │   │ │
 20│    │     │  │     │   o               GND  o ───┼───────┐ │ │
   │    │7 ───┘  │  ┌──┼───────o                     │     │ │ │ │
 19│    │        │  │  │                             │     │ │ │ │  ┌──────┐
   │    │6       │  │  └─────────────────────────────┘     │ │ │ │  │Button│
 18│    │        │  │                                      │ │ │ │  └──────┘
   │    │5       │  │                                      │ │ │ │    │  │
 17│    │        │  │          ┌───────────5V──────────────┘ │ │ │    │  │
   │    │4       │  │          │ ┌─────────GND───────────────┘ │ │    │  │
 16│    │        │  │          │ │ ┌───────GPIO14 (UART TX)────┘ │    │  │
   │    │3 ──────┘  │          │ │ │ ┌─────GPIO15 (UART RX)──────┘    │  │
 15│    │           │          │ │ │ │ ┌───GPIO18─────────────────────┘  │
   │    │2 ─────────┘          │ │ │ │ │ ┌ GND───────────────────────────┘
 14│    │                ┌─────┼─┼─┼─┼─┼─┼─────────────────────────────────────
    \_  │1               │   o o o o o o o o o o o o o o o o o o o o
      \_│                │   o o o o o o o o o o o o o o o o o o o o
                         │            Raspberry Pi 3B+
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
