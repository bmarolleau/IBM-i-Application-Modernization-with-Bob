# Ansible for IBM i - PTF Currency Check

This directory contains Ansible playbooks and configurations for managing IBM i systems, with a focus on PTF (Program Temporary Fix) currency monitoring.

## Directory Structure

```
ansible/
├── playbooks/
│   └── check_ptf_currency.yml    # Main playbook for PTF currency checks
├── templates/
│   └── ptf_currency_report.j2    # Report template
├── inventories/
│   └── development/
│       └── hosts                  # Inventory file for development systems
└── README.md                      # This file
```

## Prerequisites

### 1. Install Ansible
```bash
pip install ansible
```

### 2. Install IBM Power IBM i Collection
```bash
ansible-galaxy collection install ibm.power_ibmi
```

### 3. Configure IBM i System
Ensure your IBM i system has:
- SSH access enabled
- Python 3 installed in `/QOpenSys/pkgs/bin/python3`
- User profile with appropriate authorities to query system information

## Configuration

### 1. Update Inventory File

Edit [`ansible/inventories/development/hosts`](ansible/inventories/development/hosts:1) and replace:
- `your-ibmi-system.example.com` with your IBM i hostname or IP address
- `your_ibmi_user` with your IBM i user profile
- `your_password` with your password (or use SSH keys - recommended)

Example:
```ini
[ibmi]
demo-ibmi.company.com

[ibmi:vars]
ansible_connection=ibmi
ansible_user=MYUSER
ansible_ssh_pass=MyPassword123
ansible_python_interpreter=/QOpenSys/pkgs/bin/python3
```

### 2. Secure Credentials (Recommended)

Instead of storing passwords in plain text, use Ansible Vault:

```bash
# Create encrypted password file
ansible-vault create ansible/group_vars/all/vault.yml

# Add this content:
vault_ibmi_password: YourActualPassword

# Update inventory to use vault variable:
ansible_ssh_pass: "{{ vault_ibmi_password }}"
```

## Usage

### Basic Usage

Run the PTF currency check playbook:

```bash
cd ansible
ansible-playbook -i inventories/development/hosts playbooks/check_ptf_currency.yml
```

### With Vault Password

If using Ansible Vault:

```bash
ansible-playbook -i inventories/development/hosts playbooks/check_ptf_currency.yml --ask-vault-pass
```

### Custom Parameters

You can override default variables:

```bash
# Check only groups with updates available
ansible-playbook -i inventories/development/hosts playbooks/check_ptf_currency.yml \
  -e "currency_filter='UPDATE AVAILABLE'"

# Set critical threshold to 5 levels
ansible-playbook -i inventories/development/hosts playbooks/check_ptf_currency.yml \
  -e "critical_threshold=5"

# Custom report location
ansible-playbook -i inventories/development/hosts playbooks/check_ptf_currency.yml \
  -e "report_file=/tmp/my_ptf_report.txt"
```

### Run Specific Tags

Execute only specific sections of the playbook:

```bash
# Only show summary
ansible-playbook -i inventories/development/hosts playbooks/check_ptf_currency.yml --tags summary

# Show critical groups only
ansible-playbook -i inventories/development/hosts playbooks/check_ptf_currency.yml --tags critical

# Generate report only
ansible-playbook -i inventories/development/hosts playbooks/check_ptf_currency.yml --tags report
```

## Playbook Variables

The [`check_ptf_currency.yml`](ansible/playbooks/check_ptf_currency.yml:1) playbook supports these variables:

| Variable | Default | Description |
|----------|---------|-------------|
| `currency_filter` | `*ALL` | Filter PTF groups: `*ALL`, `UPDATE AVAILABLE`, or `CURRENT` |
| `critical_threshold` | `3` | Number of levels behind to consider critical |
| `report_file` | `/tmp/ptf_currency_report_<timestamp>.txt` | Output report file location |

## Output

The playbook provides:

1. **Console Output**: Real-time display of PTF currency status with color-coded messages
2. **Detailed Report**: Text file with comprehensive PTF information saved to `report_file` location

### Sample Output

```
TASK [Display PTF currency summary] ************************************
ok: [demo-ibmi] => {
    "msg": [
        "",
        "==========================================",
        "PTF CURRENCY SUMMARY",
        "==========================================",
        "Total PTF Groups: 16",
        "Current Groups: 9 (56.3%)",
        "Groups with Updates: 7 (43.8%)",
        "Critical Updates (3+ levels): 1",
        "=========================================="
    ]
}
```

## Troubleshooting

### Connection Issues

If you encounter connection problems:

1. Verify SSH access:
   ```bash
   ssh your_user@your-ibmi-system.example.com
   ```

2. Check Python installation on IBM i:
   ```bash
   ssh your_user@your-ibmi-system.example.com "/QOpenSys/pkgs/bin/python3 --version"
   ```

3. Test Ansible connectivity:
   ```bash
   ansible ibmi -i inventories/development/hosts -m ping
   ```

### Permission Issues

If you get authority errors:

1. Ensure your user profile has access to `SYSTOOLS.GROUP_PTF_CURRENCY`
2. Consider using `become` settings in inventory:
   ```ini
   ansible_become=yes
   ansible_become_user=QSECOFR
   ```

### Module Not Found

If `ibmi_sql_query` module is not found:

```bash
# Verify collection is installed
ansible-galaxy collection list | grep ibm.power_ibmi

# Reinstall if needed
ansible-galaxy collection install ibm.power_ibmi --force
```

## Scheduling Automated Checks

### Using Cron

Add to your crontab to run daily at 6 AM:

```bash
0 6 * * * cd /path/to/ansible && ansible-playbook -i inventories/development/hosts playbooks/check_ptf_currency.yml >> /var/log/ptf_check.log 2>&1
```

### Using Ansible Tower/AWX

1. Import this playbook into your Tower/AWX instance
2. Create a job template
3. Schedule regular execution
4. Configure email notifications for critical updates

## Best Practices

1. **Regular Monitoring**: Run PTF currency checks weekly or bi-weekly
2. **Secure Credentials**: Always use Ansible Vault for production systems
3. **Review Reports**: Analyze generated reports before applying PTFs
4. **Test First**: Apply PTFs to test systems before production
5. **Maintenance Windows**: Schedule PTF applications during planned maintenance
6. **Backup First**: Always backup your system before applying PTFs
7. **Document Changes**: Keep records of PTF applications and system changes

## Additional Resources

- [IBM Power IBM i Collection Documentation](https://galaxy.ansible.com/ui/repo/published/ibm/power_ibmi/docs/)
- [IBM i PTF Guide](https://www.ibm.com/support/pages/ibm-i-ptf-guide)
- [IBM Fix Central](https://www.ibm.com/support/fixcentral/)
- [Ansible Documentation](https://docs.ansible.com/)

## Support

For issues or questions:
- IBM i Ansible Collection: [GitHub Issues](https://github.com/IBM/ansible-for-i/issues)
- IBM Support: [IBM Support Portal](https://www.ibm.com/support/)