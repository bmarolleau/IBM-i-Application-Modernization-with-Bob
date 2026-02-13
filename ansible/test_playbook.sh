#!/bin/bash
# Script to test the PTF currency check playbook
# This script helps validate the playbook setup before running

set -e

echo "=========================================="
echo "Ansible Playbook Test Script"
echo "=========================================="
echo ""

# Check if Ansible is installed
echo "1. Checking Ansible installation..."
if command -v ansible-playbook &> /dev/null; then
    ansible_version=$(ansible-playbook --version | head -n 1)
    echo "   ✓ Ansible found: $ansible_version"
else
    echo "   ✗ Ansible not found. Please install: pip install ansible"
    exit 1
fi

# Check if IBM i collection is installed
echo ""
echo "2. Checking IBM Power IBM i collection..."
if ansible-galaxy collection list | grep -q "ibm.power_ibmi"; then
    collection_version=$(ansible-galaxy collection list | grep "ibm.power_ibmi" | awk '{print $2}')
    echo "   ✓ IBM Power IBM i collection found: $collection_version"
else
    echo "   ✗ IBM Power IBM i collection not found"
    echo "   Installing now..."
    ansible-galaxy collection install ibm.power_ibmi
fi

# Check inventory file
echo ""
echo "3. Checking inventory file..."
if [ -f "inventories/development/hosts" ]; then
    echo "   ✓ Inventory file exists"
    
    # Check if it's still using placeholder values
    if grep -q "your-ibmi-system.example.com" inventories/development/hosts; then
        echo "   ⚠ WARNING: Inventory file contains placeholder values"
        echo "   Please edit inventories/development/hosts with your IBM i details"
        echo ""
        echo "   Required changes:"
        echo "   - Replace 'your-ibmi-system.example.com' with your IBM i hostname"
        echo "   - Replace 'your_ibmi_user' with your user profile"
        echo "   - Replace 'your_password' with your password (or use SSH keys)"
        echo ""
        read -p "   Have you updated the inventory file? (y/n) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "   Please update the inventory file and run this script again"
            exit 1
        fi
    fi
else
    echo "   ✗ Inventory file not found"
    exit 1
fi

# Validate playbook syntax
echo ""
echo "4. Validating playbook syntax..."
if ansible-playbook playbooks/check_ptf_currency.yml --syntax-check; then
    echo "   ✓ Playbook syntax is valid"
else
    echo "   ✗ Playbook syntax check failed"
    exit 1
fi

# Test connectivity to IBM i
echo ""
echo "5. Testing connectivity to IBM i..."
echo "   Running: ansible ibmi -i inventories/development/hosts -m ping"
echo ""
if ansible ibmi -i inventories/development/hosts -m ping; then
    echo ""
    echo "   ✓ Successfully connected to IBM i system"
else
    echo ""
    echo "   ✗ Failed to connect to IBM i system"
    echo ""
    echo "   Troubleshooting tips:"
    echo "   - Verify hostname/IP is correct in inventory file"
    echo "   - Check SSH access: ssh user@hostname"
    echo "   - Verify Python 3 is installed on IBM i: /QOpenSys/pkgs/bin/python3 --version"
    echo "   - Check firewall settings"
    exit 1
fi

# Run the playbook in check mode (dry run)
echo ""
echo "6. Running playbook in check mode (dry run)..."
echo "   This will simulate the playbook without making changes"
echo ""
read -p "   Continue with dry run? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    ansible-playbook -i inventories/development/hosts playbooks/check_ptf_currency.yml --check
    echo ""
    echo "   ✓ Dry run completed"
fi

# Offer to run the actual playbook
echo ""
echo "=========================================="
echo "All checks passed!"
echo "=========================================="
echo ""
echo "Ready to run the playbook for real?"
echo ""
echo "Command to execute:"
echo "  ansible-playbook -i inventories/development/hosts playbooks/check_ptf_currency.yml"
echo ""
read -p "Run playbook now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo "=========================================="
    echo "Executing PTF Currency Check Playbook"
    echo "=========================================="
    echo ""
    ansible-playbook -i inventories/development/hosts playbooks/check_ptf_currency.yml
    
    echo ""
    echo "=========================================="
    echo "Playbook execution completed!"
    echo "=========================================="
    echo ""
    echo "Check the generated report in /tmp/"
    ls -lht /tmp/ptf_currency_report_*.txt 2>/dev/null | head -n 1 || echo "No report file found"
else
    echo ""
    echo "Playbook not executed. Run manually when ready:"
    echo "  cd ansible"
    echo "  ansible-playbook -i inventories/development/hosts playbooks/check_ptf_currency.yml"
fi

echo ""
echo "=========================================="
echo "Test script completed"
echo "=========================================="

# Made with Bob
