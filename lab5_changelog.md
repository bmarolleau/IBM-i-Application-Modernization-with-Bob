
# Lab 5 Changelog

## 2026-05-28

### Session Summary
- Created initial Ansible project structure for Lab 5.
- Added inventory, playbook, and HTML template for PTF currency report.
- Added custom mode `ansible-for-i` in `.bob/custom_modes.yaml`.
- Updated playbook so `critical_ptfs` is optional (empty by default).
- Updated report template to show `N/A` compliance when no baseline PTF list is configured.

### Current Status
- Branch state reported by user: `main` up to date and clean.
- Inventory configured in `ansible/inventories/development/hosts.yml`:
  - host: `AXDES400C`
  - user: `FRANJPOL`
- Main blocker: WSL installation pending due to prior `Error catastrófico` during setup.

### Next Step (Resume Point)
Run in PowerShell as Administrator:
1. `wsl --update`
2. `wsl --status`
3. `wsl --install -d Ubuntu`

### Expected Outcome
- Ubuntu available in WSL.
- Then install Ansible and IBM i collections in WSL and run:
`ansible-playbook -i ansible/inventories/development/hosts.yml ansible/playbooks/check_ptf_currency.yml`

### Plan B If WSL Fails Again
- Try inbox install: `wsl --install --inbox`
- Verify BIOS virtualization (Intel VT-x / AMD SVM enabled).

## 2026-05-29

### Resume Validation
- Reviewed and validated existing Lab 5 automation artifacts:
  - `ansible/inventories/development/hosts.yml`
  - `ansible/playbooks/check_ptf_currency.yml`
  - `ansible/templates/ptf_currency_report.j2`
- Confirmed no editor-reported errors in these files.
- Confirmed previous blocker remains the same: WSL installation/setup on workstation.

### Current Resume Point
1. Complete WSL setup in elevated PowerShell:
  - `wsl --update`
  - `wsl --status`
  - `wsl --install -d Ubuntu`
2. Inside Ubuntu (WSL), install Ansible and IBM i collections:
  - `python3 -m pip install --upgrade pip`
  - `pip install ansible`
  - `ansible-galaxy collection install ibm.power_ibmi`
  - `ansible-galaxy collection install ibm.power_hmc`
3. Run a Lab 5 smoke test:
  - `ansible-inventory -i ansible/inventories/development/hosts.yml --list`
  - `ansible-playbook -i ansible/inventories/development/hosts.yml ansible/playbooks/check_ptf_currency.yml`

### Success Criteria
- Playbook completes without fatal errors.
- HTML report generated under `ansible/reports/`.
- Report includes system snapshot, PTF group output, and compliance section (N/A or percentage depending on baseline).

### Next Enhancement After First Successful Run
- Add optional baseline file support (for critical PTF list) to avoid passing long `-e` values.
- Add summary task to print compliance and missing count directly in console output.

### New Blocker Observed (2026-05-29)
- Command executed in elevated PowerShell: `wsl --update`
- Result: `Forbidden (403)`
- Error code: `Wsl/UpdatePackage/0x80190193`

### Recovery Path For 403 Update Error
1. Check if proxy/firewall policy is blocking Microsoft Store/WSL package endpoints.
2. Attempt inbox installation path (bypasses Store update flow):
  - `wsl --install --inbox`
3. If WSL feature is already present, force required Windows features then reboot:
  - `dism /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart`
  - `dism /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart`
4. After reboot, verify state:
  - `wsl --status`
5. Install Ubuntu from inbox path if needed:
  - `wsl --install -d Ubuntu --inbox`

### Follow-up Observation (2026-05-29)
- Command attempted: `wsl --install --inbox`
- Result: `Argumento de línea de comandos no válido: --inbox`
- Error code: `Wsl/E_INVALIDARG`
- Interpretation: local WSL CLI version does not support `--inbox`.

### Compatible Fallback (No --inbox support)
1. Enable required Windows features in elevated PowerShell:
  - `dism /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart`
  - `dism /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart`
2. Reboot Windows.
3. Install distro with classic command:
  - `wsl --install -d Ubuntu`
4. If Store/network policy still blocks installation, use manual distro import path:
  - Download Ubuntu rootfs/appx from a trusted source approved by IT
  - `wsl --import Ubuntu C:\WSL\Ubuntu <path_to_rootfs.tar> --version 2`
5. Validate state:
  - `wsl --status`
  - `wsl -l -v`
