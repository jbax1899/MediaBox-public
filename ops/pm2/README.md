# PM2 log rotation

The live host logrotate policy applies five-minute checks and a 10 MB trigger to PM2 application logs, retaining seven compressed rotations. PM2 daemon logs have a 100 MB trigger and three rotations. The policy file remains host-specific because it names the two PM2 homes.

The checked-in service and timer are installed under `/etc/systemd/system`; the timer is enabled and active. `systemd-analyze verify` passed, `logrotate -d` completed against the live state file, and a disposable 11 MiB fixture confirmed both PM2 application logs rotate and truncate. The timer and root-owned logrotate service survive reboot. Run the rotation fixture before installing on another host.

The two PM2 managers remain independent. Removing one app must use `pm2 delete <app>` and `pm2 save` in that manager's user context; never stop the whole PM2 daemon when changing one managed process.
