# PM2 log rotation

The host uses logrotate to check PM2 logs every five minutes:

| Logs | Size trigger | Retained rotations |
| --- | --- | --- |
| Application | 10 MB | 7 (compressed) |
| Daemon | 100 MB | 3 |

Keep the policy at `/etc/logrotate.d/mediabox-pm2` host-specific so it matches both PM2 homes. Install the service and timer under `/etc/systemd/system`, reload systemd, and enable `mediabox-pm2-logrotate.timer`. Check the policy with `logrotate -d` and test rotation on disposable logs before deploying it.

The size limits are checked periodically, not enforced continuously. To remove an app permanently, run `pm2 delete <app>` and `pm2 save` in the appropriate manager's user context without stopping its other apps.
