#!/QOpenSys/pkgs/bin/bash
# =============================================================================
# Build SAMCO
# 1.Simulate source in SAMSRC lib by copying workspace source to SAMSRC
# 2.Build project with Tobi (workspace) to build lib SAMCO , populate db
# 3.Copy SAMCO lib n times for isolating lab practicionners.
# NOTE JUNE 2026 : 2 errors in Build ART400 and related SRVPGM...to be investigated
# =============================================================================


./1_deploy_samco_src_to_qsys.sh --library SAMSRC
./2_buildSAMCO.sh
./3_copy_lib_n_times.sh --from SAMCO --range 1 20