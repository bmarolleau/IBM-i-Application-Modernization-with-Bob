# Lab 5: Building an Ansible Assistant for PTF Management on IBM i Power Systems with Bob

**Duration:** 20 minutes  
**Difficulty:** Intermediate

## Introduction

This lab guides you through creating an automated assistant to manage Program Temporary Fixes (PTFs) on IBM i systems using Ansible with Bob AI assistant integration. You'll learn to leverage Bob's AI capabilities to streamline PTF currency checks, automate compliance reporting, and manage system updates efficiently.

**Objectives:**
- Configure Bob with specialized Ansible for IBM i knowledge
- Create playbooks to query and report PTF status
- Automate PTF currency compliance checking
- Generate formatted reports for system administrators
- Explore advanced automation scenarios for IBM i environments

## Prerequisites

### IBM i System Requirements
- IBM i 7.3 or higher
- SSH daemon running (`STRTCPSVR SERVER(*SSHD)`)
- User profile with *ALLOBJ or appropriate PTF management authorities
- Python 3.6+ installed via yum (`yum install python3`)
- IBM i Open Source Package Management configured

### Bob Workstation Requirements
- Ansible 2.9+ installed (`pip install ansible`)
- Python 3.8+ with pip
- IBM i Ansible collections:
  ```bash
  ansible-galaxy collection install ibm.power_ibmi
  ansible-galaxy collection install ibm.power_hmc
  ```
- SSH key-based authentication configured to IBM i system
- Bob AI assistant installed and configured
- Network connectivity to IBM i system (port 22)

### Verify Setup
```bash
# Test SSH connectivity
ssh user@ibmi-system.example.com

# Verify Ansible installation
ansible --version

# Check IBM i collection
ansible-galaxy collection list | grep ibm.power_ibmi
```

## Custom Mode Configuration

Create a specialized Bob mode for Ansible IBM i automation at `~/.bobmodes`:

```yaml
ansible_for_i:
  name: "Ansible for IBM i"
  description: "Specialized mode for IBM i automation with Ansible"
  context: |
    You are an expert in IBM i system administration and Ansible automation.
    Focus on:
    - IBM i-specific Ansible modules (ibm.power_ibmi collection)
    - PTF management and system currency
    - YAML playbook best practices
    - IBM i object authorities and security
    - Power Systems hardware management
    - High availability configurations
  commands:
    - ansible-playbook
    - ansible-inventory
    - ansible-doc
  knowledge_areas:
    - IBM i operating system concepts
    - PTF lifecycle and management
    - Ansible playbook development
    - Jinja2 templating
    - IBM i Ansible modules: ibmi_fix, ibmi_sql_query, ibmi_object_authority
    - Power HMC integration
    - PowerHA SystemMirror automation
```

**Activate the mode:**

Option 1 - Using Bob Shell:
```bash
bob mode ansible_for_i
```

Option 2 - Using Bob IDE (VS Code):
- Open Command Palette (Cmd/Ctrl+Shift+P)
- Type "Bob: Switch Mode"
- Select "ansible_for_i" from the list

## First Playbook Creation

### Part 1: Using Bob to Generate the Playbook

Now that you've configured the specialized `ansible_for_i` mode, let's use Bob to generate the complete playbook structure and automation code.

**Step 1: Switch to the Ansible for IBM i mode**

Option 1 - Using Bob Shell:
```bash
bob mode ansible_for_i
```

Option 2 - Using Bob IDE (VS Code):
- Open Command Palette (Cmd/Ctrl+Shift+P)
- Type "Bob: Switch Mode"
- Select "ansible_for_i" from the list
- Verify mode indicator shows "Ansible for IBM i"

**Step 2: Ask Bob to create the PTF currency check automation**

In your Bob IDE or terminal, provide this prompt:

```
Create an Ansible automation project for IBM i PTF management with the following:

1. Directory structure: ~/ansible with subdirectories for inventories/development, playbooks, and templates
2. A playbook called check_ptf_currency.yml that:
   - Queries IBM i system information using ibmi_sql_query
   - Checks PTF group levels (SF99740, SF99738) using ibmi_fix_group_check
   - Lists installed PTFs from QSYS2.PTF_INFO
   - Compares against missing critical PTFs
   - Calculates compliance statistics
   - Generates an HTML report using a Jinja2 template
3. An inventory file for development environment with ibmi_systems group
4. A Jinja2 template for the PTF currency report with system info, PTF group status, missing PTFs, and compliance metrics

Use IBM i Ansible collection modules (ibm.power_ibmi) and follow best practices.
```

**Step 3: Review Bob's generated files**

Bob will create:
- `~/ansible/inventories/development/hosts` - Inventory configuration
- `~/ansible/playbooks/check_ptf_currency.yml` - Main playbook
- `~/ansible/templates/ptf_currency_report.j2` - Report template

**Step 4: Customize the generated inventory**

Update the inventory file with your actual IBM i system details:
```ini
[ibmi_systems]
ibmi-prod ansible_host=YOUR_IBMI_IP ansible_user=YOUR_USER
```

### Part 2: Understanding the Generated Playbook

After Bob generates the automation, review the PTF currency check playbook structure at `~/ansible/playbooks/check_ptf_currency.yml`:

```yaml
---
- name: Check PTF Currency on IBM i Systems
  hosts: ibmi_systems
  gather_facts: no
  
  vars:
    report_path: "/tmp/ptf_currency_report_{{ ansible_date_time.date }}.html"
    
  tasks:
    - name: Gather system information
      ibm.power_ibmi.ibmi_sql_query:
        sql: "SELECT * FROM SYSIBMADM.ENV_SYS_INFO"
      register: system_info
      
    - name: Get current PTF group level
      ibm.power_ibmi.ibmi_fix_group_check:
        groups:
          - "SF99740"  # Technology Refresh group
          - "SF99738"  # Cumulative PTF package
      register: ptf_groups
      
    - name: Query installed PTFs
      ibm.power_ibmi.ibmi_sql_query:
        sql: |
          SELECT PTF_PRODUCT_ID, PTF_IDENTIFIER, PTF_LOADED_STATUS,
                 PTF_SAVE_FILE, PTF_IPL_ACTION, PTF_STATUS_TIMESTAMP
          FROM QSYS2.PTF_INFO
          WHERE PTF_LOADED_STATUS IN ('LOADED', 'APPLIED', 'APPLIED PERMANENT')
          ORDER BY PTF_STATUS_TIMESTAMP DESC
      register: installed_ptfs
      
    - name: Check for missing critical PTFs
      ibm.power_ibmi.ibmi_fix_compare:
        groups: "{{ ptf_groups.group_info }}"
      register: missing_ptfs
      
    - name: Get system compliance status
      ibm.power_ibmi.ibmi_sql_query:
        sql: |
          SELECT COUNT(*) as TOTAL_PTFS,
                 SUM(CASE WHEN PTF_LOADED_STATUS = 'APPLIED PERMANENT' THEN 1 ELSE 0 END) as PERMANENT_PTFS,
                 SUM(CASE WHEN PTF_IPL_ACTION = '*IMMED' THEN 1 ELSE 0 END) as IMMEDIATE_PTFS
          FROM QSYS2.PTF_INFO
      register: compliance_stats
      
    - name: Generate PTF currency report
      template:
        src: ~/ansible/templates/ptf_currency_report.j2
        dest: "{{ report_path }}"
      delegate_to: localhost
      
    - name: Display report location
      debug:
        msg: "PTF Currency Report generated at {{ report_path }}"
```

**Create inventory file** at `~/ansible/inventories/development/hosts`:

Please adapt the hostnames according to your environment.
`ànsible_host` should be the IP address or hostname of your IBM i system.
`ànsible_user` should be the user with sufficient privileges to run the PTF checks.
`ànsible_python_interpreter` should point to the Python 3 interpreter on your IBM i system.
Please also ensure that public ssh key authentication is set up for the user and that the prerequisites are installed on the IBM i system (https://github.com/IBM/ansible-for-i: 5733SC1 Base and Option 1, 5770DG1, python3, python3-itoolkit, python3-ibm_db)

```ini
[ibmi_systems]
ibmi-prod ansible_host=192.168.1.100 ansible_user=qsecofr
ibmi-dev ansible_host=192.168.1.101 ansible_user=qsecofr

[ibmi_systems:vars]
ansible_python_interpreter=/QOpenSys/pkgs/bin/python3
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
```

## Template Development

Create Jinja2 template at `~/ansible/templates/ptf_currency_report.j2`:

```jinja2
<!DOCTYPE html>
<html>
<head><title>PTF Currency Report - {{ ansible_date_time.date }}</title>
<style>body{font-family:Arial;margin:20px}table{border-collapse:collapse;width:100%}th,td{border:1px solid #ddd;padding:8px;text-align:left}th{background:#4CAF50;color:white}.warning{color:orange}.critical{color:red}.ok{color:green}</style>
</head>
<body>
<h1>PTF Currency Report</h1>
<h2>System: {{ system_info.row[0].HOST_NAME }} ({{ system_info.row[0].OS_VERSION }})</h2>
<h3>PTF Group Status</h3>
<table><tr><th>Group</th><th>Current Level</th><th>Latest Level</th><th>Status</th></tr>
{% for group in ptf_groups.group_info %}<tr><td>{{ group.ptf_group_number }}</td><td>{{ group.ptf_group_level }}</td><td>{{ group.ptf_group_target_release }}</td><td class="{% if group.ptf_group_status == 'CURRENT' %}ok{% else %}warning{% endif %}">{{ group.ptf_group_status }}</td></tr>{% endfor %}</table>
<h3>Missing Critical PTFs: {{ missing_ptfs.missing_fixes | length }}</h3>
<h3>Compliance: {{ compliance_stats.row[0].PERMANENT_PTFS }}/{{ compliance_stats.row[0].TOTAL_PTFS }} PTFs permanently applied</h3>
</body></html>
```

## Playbook Execution

**Run the playbook:**
```bash
cd ~/ansible
ansible-playbook -i inventories/development/hosts playbooks/check_ptf_currency.yml
```

**With Bob assistance:**
```bash
bob "Run the PTF currency check playbook and explain any errors"
```

**Review output:**
- Check PLAY RECAP for success/failure status
- Examine task output for PTF details
- Open generated HTML report in browser
- Review missing PTFs and compliance percentage

**Common troubleshooting:**
- SSH authentication failures: Verify key-based auth setup
- Module not found: Reinstall `ibm.power_ibmi` collection
- Permission denied: Check user authorities on IBM i
- Connection timeout: Verify firewall rules and network connectivity

## Additional Use Cases

### 1. Automated PTF Application
```yaml
- name: Apply PTF package
  ibm.power_ibmi.ibmi_fix:
    product_id: "5770SS1"
    fix_list: ["SI12345", "SI67890"]
    operation: "apply"
```

### 2. System Health Monitoring
```yaml
- name: Monitor system resources
  ibm.power_ibmi.ibmi_sql_query:
    sql: "SELECT * FROM QSYS2.SYSTEM_STATUS_INFO"
  register: health_metrics
```

### 3. Backup Automation
```yaml
- name: Save system configuration
  ibm.power_ibmi.ibmi_save:
    objects: ["*ALL"]
    savefile: "QGPL/SYSBACKUP"
    parameters: "UPDHST(*YES)"
```

### 4. User Authority Management
```yaml
- name: Grant object authority
  ibm.power_ibmi.ibmi_object_authority:
    object_name: "MYLIB/MYFILE"
    user: "APPUSER"
    authority: "*CHANGE"
```

### 5. Performance Monitoring
```yaml
- name: Collect performance data
  ibm.power_ibmi.ibmi_sql_query:
    sql: "SELECT * FROM QSYS2.SYSTEM_ACTIVITY_INFO"
```

### 6. PowerHA Orchestration
```yaml
- name: Check cluster status
  ibm.power_ibmi.ibmi_cl_command:
    cmd: "DSPCLU CLUSTER(MYCLUSTER)"
  register: cluster_status
```

### 7. Power HMC Integration
```yaml
- name: Provision LPAR
  ibm.power_hmc.lpar:
    hmc_host: "hmc.example.com"
    system_name: "POWER9-SYS"
    name: "NEW_LPAR"
    state: "present"
```

### 8. Software Installation
```yaml
- name: Install licensed program
  ibm.power_ibmi.ibmi_install_product:
    product: "5770DG1"
    option: "*BASE"
```

### 9. Security Audit
```yaml
- name: Audit user profiles
  ibm.power_ibmi.ibmi_sql_query:
    sql: "SELECT * FROM QSYS2.USER_INFO WHERE STATUS = '*ENABLED'"
```

### 10. ServiceNow Integration
```yaml
- name: Create change request
  servicenow.itsm.change_request:
    instance: "{{ snow_instance }}"
    short_description: "PTF Application - {{ ansible_date_time.date }}"
    description: "Applying PTFs: {{ missing_ptfs.missing_fixes | join(', ') }}"
    state: "new"
```

## Conclusion

You've successfully created an Ansible-based PTF management assistant with Bob AI integration. This automation framework provides:
- Automated PTF currency checking and compliance reporting
- Streamlined system administration workflows
- Integration capabilities with enterprise ITSM tools
- Foundation for comprehensive IBM i automation

**Next Steps:**
- Expand playbooks for automated PTF application
- Integrate with CI/CD pipelines
- Create scheduled jobs for regular compliance checks
- Explore PowerHA and HMC automation scenarios

**Resources:**
- IBM i Ansible Collection: https://galaxy.ansible.com/ibm/power_ibmi
- Power HMC Collection: https://galaxy.ansible.com/ibm/power_hmc
- IBM i PTF Management: https://www.ibm.com/support/pages/fix-management