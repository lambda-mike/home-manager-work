# Cloudflare Tunnel

## Instructions

1. Add `cloudflared` to system programs and enable service.
1. `cloudflared tunnel login`
1. `sudo mkdir -p /val/lib/cloudflared`
1. `sudo cp ~/.cloudflared/cert.pem /var/lib/cloudflared/`
1. `sudo chown root:root /var/lib/cloudflared/cert.pem`
1. `sudo chmod 600 /var/lib/cloudflared/cert.pem`
1. `cloudflared tunnel create rpi-nixos`
1. note UUID
1. `sudo mv ~/.cloudflared/*.json /var/lib/cloudflared/`
1. `sudo chown root:root /var/lib/cloudflared/*.json`
1. `sudo chmod 600 /var/lib/cloudflared/*.json`
1. `sudo ln -s /var/lib/cloudflared/{uuid}.json /var/lib/cloudflared/creds.json`
1. Add cloudflared config to configuration.nix and rebuild NixOS
