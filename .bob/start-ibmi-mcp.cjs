const fs = require('fs');
const path = require('path');
const { spawn } = require('child_process');

function writeLog(message) {
  try {
    const workspaceRoot = process.cwd();
    const logsDir = path.join(workspaceRoot, '.bob', 'logs');
    const logPath = path.join(logsDir, 'ibmi-mcp-launcher.log');
    fs.mkdirSync(logsDir, { recursive: true });
    const line = `[${new Date().toISOString()}] ${message}\n`;
    fs.appendFileSync(logPath, line, 'utf8');
  } catch (err) {
    process.stderr.write(`ibmi-mcp launcher: failed to write log (${err.message}).\n`);
  }
}

function loadDotEnv(dotEnvPath) {
  if (!fs.existsSync(dotEnvPath)) {
    return;
  }

  const content = fs.readFileSync(dotEnvPath, 'utf8');
  const lines = content.split(/\r?\n/);

  for (const rawLine of lines) {
    const line = rawLine.trim();
    if (!line || line.startsWith('#')) {
      continue;
    }

    const idx = line.indexOf('=');
    if (idx <= 0) {
      continue;
    }

    const key = line.slice(0, idx).trim();
    let value = line.slice(idx + 1).trim();

    if ((value.startsWith('"') && value.endsWith('"')) || (value.startsWith("'") && value.endsWith("'"))) {
      value = value.slice(1, -1);
    }

    if (!process.env[key]) {
      process.env[key] = value;
    }
  }
}

const workspaceRoot = process.cwd();
const dotEnvPath = path.join(workspaceRoot, '.env');
const toolsPath = path.join(workspaceRoot, '.bob', 'tools', 'health-tools.yaml');
const localServerEntrypoint = path.join(
  workspaceRoot,
  'node_modules',
  '@ibm',
  'ibmi-mcp-server',
  'dist',
  'index.js'
);

loadDotEnv(dotEnvPath);

// LAUNCHER v2.1: Capturing stderr/stdout for diagnostics
writeLog(`launcher_version=2.3 stdio_bridge_fix=true`);
writeLog(`cwd=${workspaceRoot}`);
writeLog(`node=${process.execPath}`);
writeLog(`dotEnvExists=${fs.existsSync(dotEnvPath)}`);
writeLog(`toolsPath=${toolsPath}`);
writeLog(`localServerEntrypoint=${localServerEntrypoint}`);

if (!fs.existsSync(toolsPath)) {
  writeLog('tools file not found');
  process.stderr.write('ibmi-mcp launcher: tools file not found.\n');
  process.exit(1);
}

const requiredKeys = ['DB2i_HOST', 'DB2i_USER', 'DB2i_PASS', 'DB2i_PORT'];
for (const key of requiredKeys) {
  if (!process.env[key]) {
    writeLog(`missing env var ${key}`);
    process.stderr.write(`ibmi-mcp launcher: missing env var ${key}.\n`);
    process.exit(1);
  }
}

writeLog('required env vars present');

const env = {
  ...process.env,
  MCP_TRANSPORT_TYPE: process.env.MCP_TRANSPORT_TYPE || 'stdio',
  NODE_OPTIONS: process.env.NODE_OPTIONS || '--no-deprecation --no-warnings',
  YAML_ALLOW_DUPLICATE_SOURCES: process.env.YAML_ALLOW_DUPLICATE_SOURCES || 'true'
};

let child;
try {
  if (process.platform === 'win32') {
    if (fs.existsSync(localServerEntrypoint)) {
      writeLog(`spawn command=${process.execPath} ${localServerEntrypoint} --tools ${toolsPath}`);
      child = spawn(process.execPath, [localServerEntrypoint, '--tools', toolsPath], {
        cwd: workspaceRoot,
        env,
        stdio: ['pipe', 'pipe', 'pipe'],
        shell: false
      });
    } else {
      const npxCmd = path.join(path.dirname(process.execPath), 'npx.cmd');
      writeLog(`resolved npxCmd=${npxCmd}`);
      writeLog(`spawn command=${npxCmd} -y @ibm/ibmi-mcp-server@latest --tools ${toolsPath}`);
      child = spawn(npxCmd, ['-y', '@ibm/ibmi-mcp-server@latest', '--tools', toolsPath], {
        cwd: workspaceRoot,
        env,
        stdio: ['pipe', 'pipe', 'pipe'],
        shell: false
      });
    }
    // Bridge MCP stdio streams between VS Code host and child server.
    if (process.stdin && child.stdin) {
      process.stdin.pipe(child.stdin);
    }
    // Forward stdout to MCP client (VS Code) and keep minimal diagnostics.
    if (child.stdout) {
      child.stdout.pipe(process.stdout);
      child.stdout.on('data', (data) => {
        const msg = data.toString().trim();
        if (msg) writeLog(`server stdout=${msg.slice(0, 500)}`);
      });
    }
    if (child.stderr) {
      child.stderr.on('data', (data) => {
        const msg = data.toString().trim();
        if (msg) writeLog(`server stderr=${msg}`);
      });
    }
  } else {
    if (fs.existsSync(localServerEntrypoint)) {
      writeLog(`spawn command=${process.execPath} ${localServerEntrypoint} --tools ${toolsPath}`);
      child = spawn(process.execPath, [localServerEntrypoint, '--tools', toolsPath], {
        cwd: workspaceRoot,
        env,
        stdio: ['pipe', 'pipe', 'pipe'],
        shell: false
      });
    } else {
      writeLog(`spawn command=npx -y @ibm/ibmi-mcp-server@latest --tools ${toolsPath}`);
      child = spawn('npx', ['-y', '@ibm/ibmi-mcp-server@latest', '--tools', toolsPath], {
        cwd: workspaceRoot,
        env,
        stdio: ['pipe', 'pipe', 'pipe'],
        shell: false
      });
    }
    // Bridge MCP stdio streams between host and child.
    if (process.stdin && child.stdin) {
      process.stdin.pipe(child.stdin);
    }
    // Forward stdout to MCP client and keep minimal diagnostics.
    if (child.stdout) {
      child.stdout.pipe(process.stdout);
      child.stdout.on('data', (data) => {
        const msg = data.toString().trim();
        if (msg) writeLog(`server stdout=${msg.slice(0, 500)}`);
      });
    }
    if (child.stderr) {
      child.stderr.on('data', (data) => {
        const msg = data.toString().trim();
        if (msg) writeLog(`server stderr=${msg}`);
      });
    }
  }
} catch (err) {
  writeLog(`spawn threw=${err.message}`);
  process.exit(1);
}

writeLog(`child spawned pid=${child && child.pid ? String(child.pid) : 'unknown'}`);

process.on('SIGTERM', () => {
  writeLog('launcher received SIGTERM');
  if (child && !child.killed) {
    child.kill('SIGTERM');
  }
});

process.on('SIGINT', () => {
  writeLog('launcher received SIGINT');
  if (child && !child.killed) {
    child.kill('SIGINT');
  }
});

child.on('exit', (code) => {
  writeLog(`child exit code=${code == null ? 'null' : String(code)}`);
  process.exit(code == null ? 1 : code);
});

child.on('error', (err) => {
  writeLog(`child error=${err.message}`);
  process.exit(1);
});

process.on('uncaughtException', (err) => {
  writeLog(`uncaughtException=${err.message}`);
  process.exit(1);
});

process.on('unhandledRejection', (reason) => {
  const msg = reason instanceof Error ? reason.message : String(reason);
  writeLog(`unhandledRejection=${msg}`);
  process.exit(1);
});
