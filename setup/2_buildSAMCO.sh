#!/QOpenSys/pkgs/bin/bash
# =============================================================================
# Build with Tobi
# =============================================================================

/QOpenSys/pkgs/bin/yum install tobi
/QOpenSys/pkgs/bin/yum install python39
system "CRTLIB LIB(SAMCO) TEXT('SAMCO Application')"
cd ../SAMCO
export lib1=SAMCO
system "addlible SAMCO"
/QOpenSys/pkgs/bin/makei build
system "RUNSQLSTM SRCSTMF('../SAMCO/POPULATE_SAMCO_TABLES.sql') COMMIT(*NONE)"