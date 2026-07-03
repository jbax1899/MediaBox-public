const path = require("node:path");

const repoRoot = path.resolve(__dirname, "..", "..");

module.exports = {
  apps: [
    {
      name: "opencode",
      cwd: repoRoot,
      script: "ops/opencode/start-opencode-web.sh",
      interpreter: "bash",
      env: {
        OPENCODE_HOSTNAME: "0.0.0.0",
        OPENCODE_PORT: "4096",
      },
      autorestart: true,
      restart_delay: 5000,
      max_restarts: 10,
      kill_timeout: 10000,
      time: true,
      merge_logs: true,
    },
  ],
};
