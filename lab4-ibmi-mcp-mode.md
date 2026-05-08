# Lab 101-4: IBM i modes, IBM i MCP, Bob Shell - 15 Minute Hands-On Lab

**Duration**: 15 minutes  
**Level**: Intermediate  
**Prerequisites**: 
- IBM Bob installed and running
- Access to an IBM i system with Mapepire server running (port 8076)
- Basic familiarity with command line
**Version:** version 2 updated on April 1, 2026

## Lab Overview

In this hands-on lab, you'll configure IBM Bob to work with IBM i systems using the Model Context Protocol (MCP). You'll set up custom modes, connect to your IBM i system, and execute your first queries using Bob's AI-powered interface. 

The *IBM Bob premium package for IBM i* available at GA will bring standard IBM i modes and tools that will differ from the ones used in this tutorial. 

## What You'll Learn

- How to configure Bob for IBM i development with MCP and modes
- How to use IBM i-specific AI agent modes
- How to query IBM i systems using natural language
- How to leverage pre-built IBM i tools

## Prerequisites (15 minutes)

An IBM i VM is necessary for this lab, with 8076 port open for Mapepire server (use tunneling if using Power Virtual Server/TechZone). You'll find hereunder a few options to get an IBM i virtual machine, and instructions to start the Mapepire server on IBM i that is requried for this lab.

### How to get an IBM i virtul machine (aka LPAR)? 

* For customer activities: 
    * use customer infrastructure (IBM on prem or in the Cloud)
    * TechZone: request an [IBM i on IBM Cloud Power Virtual Server](https://techzone.ibm.com/collection/628be988043b54001f89111f) with ssh tunneling (see instructions [here](https://cloud.ibm.com/docs/power-iaas?topic=power-iaas-connect-ibmi#ssh-tunneling) for opening ports if using a public IP. Note that no 'production' customer data is allowed when using our own IBM accounts. Please refer to the official guidelines.
    * TechZone: request a custom techZone environment for complex or more permanent showcase (prefered but not the default). 
* For IBMers/business partners activities:
    * TechZone: request a ["On-Premises IBM Power AIX, IBM i and Linux Base Images"](https://techzone.ibm.com/collection/6261d3584670d7001e3d483a) environment, for example IBM i 7.5 on Power10. IBMers must connect through the Internal intranet and Business partners must connect through a provided VPN.
    * TechZone: request a [IBM i on IBM Cloud Power Virtual Server](https://techzone.ibm.com/collection/628be988043b54001f89111f) as listed above.

### How to start the mapepire service on IBM i used by MCP ? 

Follow these [instructions](https://ibm-d95bab6e.mintlify.app/setup-mapepire#option-1-rpm-installation-recommended) and don't be scared.
In a nutshell: 
1. connect to your IBM i with [Access Client Solution](https://www.ibm.com/support/pages/ibm-i-access-client-solutions) (5250 emulator) and your user profile.
2. start SSH using the CL command `STRTCPSVR *SSHD` , 
3. Connect via SSH and execute the installation commands.

> **Note:** On PowerVS, you must use the provided private SSH key.

```bash
chmod 600 PATH/TO/pem_user_privatekey_download.pem
ssh -i PATH/TO/pem_user_privatekey_download.pem cecuser@<IBMi_IP_ADDRESS>
```

### Install and start mapepire

```bash
/QOpenSys/pkgs/bin/yum install -y mapepire-server
/QOpenSys/pkgs/bin/yum install -y service-commander
/QOpenSys/pkgs/bin/sc start mapepire
```

### Connection Options

You have two ways to connect to your IBM i system:

#### Option A: PowerVS (IBM Cloud)

- Requires an SSH tunnel (service is not directly exposed)
- Use the provided private SSH key

##### Create SSH tunnel

```bash 
ssh -i PATH/TO/pem_user_privatekey_download.pem \
-L 8076:localhost:8076 \
-o ServerAliveInterval=15 \
-o ServerAliveCountMax=3 \
cecuser@<IBMi_IP_ADDRESS>
```

Note that in the command above, port 8076 is the default **mapepire** port. If you have changed it, please update it accordingly. Replace `<myIPaddress>` with your IBM i IP address.

#### Option B: _On-Premise_ IBM i (TechZone LPAR)

- Direct access to the LPAR
- No SSH tunnel required

## Lab Setup (5 minutes)

### Step 1: Open project

Create a new directory on your laptop, Open up this new folder in a new Bob window, this is the participant working directory.

### Step 2: Configure IBM i Connection

Create a `.env` file in your project root with your IBM i credentials:

#### Option A: Using PowerVS

Since you are using an SSH tunnel, point to `localhost`:

```bash
# .env file
DB2i_HOST=localhost
DB2i_USER=cecuser
DB2i_PASS=yourpassword
DB2i_PORT=8076
```

Replace `yourpassword` by the corresponding value.

#### Option B: Using On-Premise IBM i Base image

Use the hostname or IP address of your system:

```bash
# .env file
DB2i_HOST=your-ibmi-hostname.com
DB2i_USER=cecuser
DB2i_PASS=yourpassword
DB2i_PORT=8076
```

Replace `yourpassword` by the corresponding value.

**Important**: For both options add `.env` to `.gitignore`:

```bash
echo ".env" >> .gitignore
```

### Step 3: Update MCP Configuration

Edit `.bob/mcp.json` to use the `.env` file (remove credential references in any):

```json
{
    "mcpServers": {
        "ibmi-mcp-server": {
            "command": "npx",
            "args": [
                "@ibm/ibmi-mcp-server",
                "--tools",
                "${workspaceFolder}/.bob/tools"
            ],
            "cwd": "${workspaceFolder}",
            "env": {
                "NODE_OPTIONS": "--no-deprecation --no-warnings",
                "MCP_TRANSPORT_TYPE": "stdio",
                "YAML_ALLOW_DUPLICATE_SOURCES": "true"
            },
            "disabled": false,
            "alwaysAllow": []
        },
        "ibmi-mcp-docs": {
            "type": "streamable-http",
            "url": "https://ibm-d95bab6e.mintlify.app/mcp"
        }
    }
}
```

### Step 4: Check configuration

1. Restart Bob (or reload the window using `Function` + `F1` keys then `Reload Window`  )
2. Open up Bob settings
2. Check that `IBM i Agent` and `IBM i MCP Tool Builder` appear in your modes list
3. Check that `ibmi-mcp-server` and `ibmi-mcp-docs` appear connected in your MCP list

## Exercise 1: Switch to IBM i Agent Mode (2 minutes)

**Objective**: Select the IBM i-specific AI agent.

1. Switch to IBM i Agent mode
![](./pics/select-ibmi-agent.png)

2. Ask Bob: `What can you help me with?`
   - Bob should describe its IBM i capabilities
   - You may need to reload the window to refresh the credentials for the MCP server: `CMD` `SHFT` `P`, search `Developer: Reload Window`

## Exercise 2: Query System Status (3 minutes)

**Objective**: Use Bob to check your IBM i system's performance.

1. Ask Bob: `"Show me the current system status"`
2. Bob should execute the `system_status` tool and display:
   - CPU utilization
   - Memory usage
   - I/O statistics
   - Active jobs count

**Sample Questions to Try**:
- `"What is the current CPU usage?"`
- `"How many jobs are currently active?"`
- `"Show me memory pool information"`

**✅ Success Criteria**: Bob returns formatted system performance data from your IBM i system.

## Exercise 3: Explore Database Objects (3 minutes)

**Objective**: Use Bob to explore your IBM i database.

1. Ask Bob: `"List all service categories available on IBM i"`
2. Bob should show categories like "System Administration", "Performance", "Security", etc.
3. Ask Bob: `"Search for services related to 'job' in their name"`
4. Bob should list job-related SQL services

**Sample Questions to Try**:
- `"What services are available in the Performance category?"`
- `"Show me an example of using the ACTIVE_JOB_INFO service"`
- `"List tables in the QSYS2 schema"`

**✅ Success Criteria**: Bob successfully queries and displays IBM i service information.

## Exercise 4: Security Analysis (Optional - 2 minutes)

**Objective**: Use Bob to perform a basic security check.

1. Ask Bob: `"Show me users with limited capabilities"`
2. Bob should execute the security tool and display results
3. Ask Bob: `"Are there any database files readable by any user?"`

**⚠️ Note**: These queries require appropriate security authorities on your IBM i system.

**✅ Success Criteria**: Bob executes security analysis tools and returns results (or explains permission requirements).

## Exercise 5: (optional) Using Bob Shell CLI (3 minutes)

**Objective**: Learn to use Bob from the command line for general IBM i assistance.

Bob provides a CLI, **Bob Shell** that allows you to interact with AI agents from the terminal, making it perfect for quick questions, code generation, and documentation lookup.


### Step 1: Verify Bob CLI is Available

Check if Bob CLI is installed:

```bash
bob --version
```

If not installed, follow the Bob CLI installation instructions for your platform.

### Step 2: Update MCP Configuration for CLI

Bob CLI can require a few changes in the MCP configuration. Update your `.bob/mcp.json` : 

1. **Find the full path to npx**:
```bash
which npx
# Example output: /opt/homebrew/bin/npx
```

2. **Get the full path to your project directory**:
```bash
pwd
# Example output: /Users/yourname/bob-ibmi-lab
```

3. **Update `.bob/mcp.json`** with full paths. 

There are certainly more elegant ways to do that, but for now, just update the file as follows:

```json
{
    "mcpServers": {
        "ibmi-mcp-server": {
            "command": "/opt/homebrew/bin/npx",
            "args": [
                "@ibm/ibmi-mcp-server",
                "--tools",
                "/Users/yourname/bob-ibmi-lab/.bob/tools"
            ],
            "cwd": "/Users/yourname/bob-ibmi-lab",
            "env": {
                "NODE_OPTIONS": "--no-deprecation --no-warnings",
                "MCP_TRANSPORT_TYPE": "stdio",
                "YAML_ALLOW_DUPLICATE_SOURCES": "true",
                "DB2i_HOST": "your-ibmi-hostname.com",
                "DB2i_USER": "YOURUSER",
                "DB2i_PASS": "yourpassword",
                "DB2i_PORT": "8076"
            },
             "disabled": true,
            "timeout": 120,
            "alwaysAllow": []
        },
        "ibmi-mcp-server-http": {
            "type": "streamable-http",
            "url": "http://localhost:3010/mcp"
        },
        "ibmi-mcp-docs": {
            "type": "streamable-http",
            "url": "https://ibm-d95bab6e.mintlify.app/mcp"
        }
    }
}
```
**Important**: Add `mcp.json` to `.gitignore`:

```bash
echo ".bob/mcp.json" >> .gitignore
```

**Important**: Replace `/opt/homebrew/bin/npx` and `/Users/yourname/bob-ibmi-lab` with your actual paths.

### Step 3: Check Available Modes

Verify that Bob CLI can see your custom modes:

```bash
bob mcp list
```

You should see:
- `loaded project modes [ 'ibm-i-agent', 'ibmi-mcp-tool-builder' ]`
- MCP servers listed (may show as disconnected in CLI)

### Step 4: Use Bob Shell with IBM i Agent Mode

Launch Bob shell and interact with IBM i using the custom mode:

1. **Start Bob shell**:
```bash
bob 
```
![alt text](pics/bobshell.png)


2. **Switch to advanced mode**:
```
Switch to advanced mode with   /mode advanced , press enter
```
Bob should confirm the mode switch.

3. **Run a query in advanced mode**:
```
Show me the current system status
```

Bob should execute the `system_status` tool and display comprehensive IBM i system information including CPU, memory, jobs, and storage statistics.

4. **Exit Bob shell**:
```
Exit Bob shell with Ctrl+C Ctrl+C
```

**✅ Success Criteria**:
- Bob shell launches successfully
- Successfully switch to IBM i Agent mode
- Execute queries and receive IBM i system data
- Understand the difference between shell (interactive) and CLI (one-shot) usage

### Step 5: Run Live IBM i Queries from Command Line

With the MCP server connected, you can now run live queries against your IBM i system:

```bash
# System status (MCP tools work in any mode)
bob -p "Show me the current system status" --chat-mode advanced

# Active jobs
bob -p "Show me the top 5 CPU consumers" --chat-mode advanced

# Database exploration
bob -p "List tables in the SAMPLE schema" --chat-mode advanced

# Security checks
bob -p "Show me users with limited capabilities" --chat-mode advanced
```

**Important Notes:**
- Use `--chat-mode ask` for queries and `--chat-mode code` for code generation

![alt text](pics/wrksyssts-bob.png)

### CLI Options Reference

Common Bob CLI options:
- `--chat-mode <mode>` - Specify chat mode: `plan`, `code`, `ask`, or `advanced`
- `--hide-intermediary-output` - Suppress extra output, show only final results
- `--max-coins <number>` - Set maximum cost limit (exits with code 1 if exceeded)
- `--help` - Show all available options

**✅ Success Criteria**: Successfully execute queries from the command line and understand CLI capabilities and limitations.

## Lab Completion Checklist

- [ ] Bob is configured with IBM i custom modes
- [ ] MCP servers are connected and working
- [ ] Successfully switched to IBM i Agent mode
- [ ] Retrieved system status information
- [ ] Explored IBM i services and database objects
- [ ] (Optional) Ran security analysis queries
- [ ] Used Bob CLI from the command line

## What You've Accomplished

Congratulations! You've successfully:

1. ✅ Configured IBM Bob for IBM i development
2. ✅ Connected Bob to your IBM i system via MCP
3. ✅ Used natural language to query IBM i system information
4. ✅ Explored IBM i SQL services and database objects
5. ✅ Leveraged pre-built tools for system monitoring
6. ✅ Automated IBM i queries using Bob CLI

## Next Steps   

### Create Custom Tools

Switch to IBM i MCP Tool Builder mode:

1. Ask Bob: `"Switch to IBM i MCP Tool Builder mode"`
2. Ask Bob: `"Help me create a tool to monitor job queues"`
3. Bob will guide you through creating a custom YAML tool definition

### Learn More

- [IBM i MCP Server Documentation](https://ibm-d95bab6e.mintlify.app/)
- [Mapepire Setup Guide](https://mapepire-ibmi.github.io/guides/sysadmin/)
- [SQL Tools Guide](https://ibm-d95bab6e.mintlify.app/sql-tools/overview)
- [GitHub Repository](https://github.com/IBM/ibmi-mcp-server)

## Troubleshooting

### Bob doesn't show custom modes
- Verify `.bobmodes` file is in project root
- Restart Bob completely
- Check file syntax is valid YAML

### MCP server connection fails
- Verify `.env` file has correct credentials
- Ensure Mapepire is running on IBM i (port 8076)
- Test connectivity: `ping your-ibmi-hostname`
- Check firewall allows port 8076

### Tools return errors
- Verify your IBM i user has appropriate authorities
- Check Mapepire server logs on IBM i
- Ensure QSYS2 services are available on your system

### No data returned
- Confirm you're querying existing objects/schemas
- Check SQL syntax in tool definitions
- Verify database authorities for your user profile

## Feedback

This lab is part of the IBM i MCP Server project. If you have suggestions or find issues, please contribute at [GitHub](https://github.com/IBM/ibmi-mcp-server).

---

**Lab Complete!** You're now ready to use IBM Bob for IBM i development and system administration tasks.