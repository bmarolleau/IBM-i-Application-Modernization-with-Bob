#!/QOpenSys/pkgs/bin/bash
# =============================================================================
# clone_srclib.sh
# =============================================================================
# PURPOSE
#   Clone a source library into one or more numbered copies.
#   Provide a source library, a numeric range m..n, and the script will
#   create <BASENAME>m, <BASENAME>m+1, ... <BASENAME>n — each an exact copy
#   of the source, using IBM i CPYLIB.
#
#   The base name is auto-derived from the source library by stripping its
#   trailing digits (e.g. SAMSRC1 -> base SAMSRC, DEVLIB3 -> base DEVLIB).
#   Override with --base if the source has no trailing digit.
#
# USAGE
#   bash clone_srclib.sh --from <SRCLIB> --range <m> <n> [OPTIONS]
#
# OPTIONS
#   -f, --from    <LIB>    Source library to clone (required)
#   -r, --range   <m> <n>  Inclusive range of target suffixes (required)
#                          Both m and n must be positive integers, m <= n
#       --base    <NAME>   Override base name for target libraries
#                          Default: source library name with trailing digits stripped
#       --force            Overwrite existing target libraries without prompting
#   -d, --dry-run          Print actions without executing
#   -v, --verbose          Show full CL command output
#   -h, --help             Show this help message
#
# EXAMPLES
#   Clone SAMSRC1 into SAMSRC2, SAMSRC3, SAMSRC4, SAMSRC5
#     bash clone_srclib.sh --from SAMSRC1 --range 2 5
#
#   Same, skip prompt if targets already exist
#     bash clone_srclib.sh --from SAMSRC1 --range 2 5 --force
#
#   Preview what would happen (no changes)
#     bash clone_srclib.sh --from SAMSRC1 --range 2 5 --dry-run
#
#   Source has no trailing digit — specify base explicitly
#     bash clone_srclib.sh --from DEVMASTER --base DEVLIB --range 1 3
#
# NOTES
#   - CPYLIB copies ALL *FILE objects (source PFs + members) in one pass.
#   - If a target library already exists the script prompts before deleting
#     it. Use --force to suppress the prompt (useful in batch/CI).
#   - Library names on IBM i are max 10 characters. The script validates
#     that base + suffix does not exceed this limit.
#   - Requires *ALLOBJ or authority to CRTLIB, DLTLIB, and CPYLIB.
# =============================================================================

set -euo pipefail

# ---------------------------------------------------------------------------
# Defaults
# ---------------------------------------------------------------------------
FROM_LIB=""
BASE_NAME=""        # derived from FROM_LIB if not supplied
RANGE_M=""
RANGE_N=""
FORCE=false
DRY_RUN=false
VERBOSE=false

TOTAL_OK=0
TOTAL_ERR=0

# ---------------------------------------------------------------------------
# Colours (disabled when not a terminal)
# ---------------------------------------------------------------------------
if [ -t 1 ]; then
  RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
  CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'
else
  RED=''; GREEN=''; YELLOW=''; CYAN=''; BOLD=''; RESET=''
fi

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
usage() {
  sed -n '/^# USAGE/,/^# NOTES/p' "$0" | grep '^#' | sed 's/^# \?//'
  exit 0
}

# run_cl <description> <CL command>
# Returns 0 on success, 1 on failure. Never exits the script.
run_cl() {
  local desc="$1"
  local cmd="$2"
  printf "    %-50s" "${desc}"
  $VERBOSE && echo && echo -e "      ${CYAN}${cmd}${RESET}"
  if $DRY_RUN; then
    echo -e " ${YELLOW}(dry-run)${RESET}"
    return 0
  fi
  local out rc=0
  out=$(system "$cmd" 2>&1) || rc=$?
  if [ $rc -ne 0 ]; then
    echo -e " ${RED}FAILED${RESET}"
    echo -e "      ${RED}${out}${RESET}" >&2
    return 1
  fi
  echo -e " ${GREEN}OK${RESET}"
  $VERBOSE && [ -n "$out" ] && echo -e "      ${out}"
  return 0
}

lib_exists() {
  # Return 0 if the library exists, 1 otherwise.
  # The explicit "|| true" prevents set -e from aborting the script when this
  # function is used in compound expressions like: lib_exists X && do_something
  system "QSYS/CHKOBJ OBJ(QSYS/${1}) OBJTYPE(*LIB)" > /dev/null 2>&1 || return 1
}

lib_stats() {
  # Print "X files, Y members" for a library.
  # Uses "|| true" on ls so set -e does not fire on an empty directory.
  local lib="$1"
  local files mbrs=0
  files=$(ls /QSYS.LIB/${lib}.LIB/*.FILE 2>/dev/null | wc -l | tr -d ' ') || true
  for pf in /QSYS.LIB/${lib}.LIB/*.FILE; do
    [[ -e "$pf" ]] || continue
    cnt=$(ls "${pf}"/*.MBR 2>/dev/null | wc -l) || true
    mbrs=$((mbrs + cnt))
  done
  echo "${files} files, ${mbrs} members"
}

is_integer() {
  [[ "$1" =~ ^[0-9]+$ ]]
}

# ---------------------------------------------------------------------------
# Parse arguments
# ---------------------------------------------------------------------------
while [[ $# -gt 0 ]]; do
  case "$1" in
    -f|--from)
      FROM_LIB=$(echo "$2" | tr '[:lower:]' '[:upper:]'); shift 2 ;;
    -r|--range)
      RANGE_M="$2"; RANGE_N="$3"; shift 3 ;;
    --base)
      BASE_NAME=$(echo "$2" | tr '[:lower:]' '[:upper:]'); shift 2 ;;
    --force)
      FORCE=true;    shift ;;
    -d|--dry-run)
      DRY_RUN=true;  shift ;;
    -v|--verbose)
      VERBOSE=true;  shift ;;
    -h|--help)
      usage ;;
    *)
      echo -e "${RED}Unknown option: $1${RESET}"; echo; usage ;;
  esac
done

# ---------------------------------------------------------------------------
# Validate inputs
# ---------------------------------------------------------------------------
errs=0

if [[ -z "$FROM_LIB" ]]; then
  echo -e "${RED}ERROR: --from <library> is required.${RESET}" >&2; errs=$((errs+1))
fi

if [[ -z "$RANGE_M" || -z "$RANGE_N" ]]; then
  echo -e "${RED}ERROR: --range <m> <n> is required.${RESET}" >&2; errs=$((errs+1))
elif ! is_integer "$RANGE_M" || ! is_integer "$RANGE_N"; then
  echo -e "${RED}ERROR: --range values must be positive integers.${RESET}" >&2; errs=$((errs+1))
elif [[ "$RANGE_M" -gt "$RANGE_N" ]]; then
  echo -e "${RED}ERROR: --range m must be <= n (got ${RANGE_M}..${RANGE_N}).${RESET}" >&2; errs=$((errs+1))
fi

[ $errs -gt 0 ] && exit 1

# Derive base name from source library if not provided:
# strip trailing digits — e.g. SAMSRC1 -> SAMSRC, DEVLIB10 -> DEVLIB
if [[ -z "$BASE_NAME" ]]; then
  BASE_NAME=$(echo "$FROM_LIB" | sed 's/[0-9]*$//')
  if [[ -z "$BASE_NAME" ]]; then
    echo -e "${RED}ERROR: Could not derive base name from '${FROM_LIB}' (all digits?).${RESET}" >&2
    echo -e "       Use --base <NAME> to supply it explicitly." >&2
    exit 1
  fi
fi

# Validate that base + largest suffix fits in 10 chars
MAX_SUFFIX_LEN=${#RANGE_N}
MAX_LIB_LEN=$(( ${#BASE_NAME} + MAX_SUFFIX_LEN ))
if [[ $MAX_LIB_LEN -gt 10 ]]; then
  echo -e "${RED}ERROR: '${BASE_NAME}${RANGE_N}' (${MAX_LIB_LEN} chars) exceeds the 10-character IBM i library name limit.${RESET}" >&2
  echo -e "       Shorten --base or use a smaller range." >&2
  exit 1
fi

# Build list of target libraries
TARGETS=()
for (( i=RANGE_M; i<=RANGE_N; i++ )); do
  TARGETS+=("${BASE_NAME}${i}")
done

# ---------------------------------------------------------------------------
# Banner
# ---------------------------------------------------------------------------
echo ""
echo -e "${BOLD}============================================================${RESET}"
echo -e "${BOLD}  IBM i Source Library Clone — Range Copy${RESET}"
echo -e "${BOLD}============================================================${RESET}"
echo -e "  Source   : ${CYAN}${FROM_LIB}${RESET}"
echo -e "  Base name: ${CYAN}${BASE_NAME}${RESET}"
echo -e "  Range    : ${CYAN}${RANGE_M} → ${RANGE_N}${RESET}  (${#TARGETS[@]} librar$([ ${#TARGETS[@]} -eq 1 ] && echo y || echo ies))"
echo -e "  Targets  : ${CYAN}${TARGETS[*]}${RESET}"
$DRY_RUN && echo -e "  Mode     : ${YELLOW}DRY RUN — no changes will be made${RESET}"
$FORCE   && echo -e "  Overwrite: ${YELLOW}--force active — existing targets will be deleted${RESET}"
echo ""

# ---------------------------------------------------------------------------
# Step 1 — Verify source library
# ---------------------------------------------------------------------------
echo -e "${BOLD}[1] Checking source library ${FROM_LIB}${RESET}"

if $DRY_RUN; then
  echo -e "  ${CYAN}(dry-run) Would verify ${FROM_LIB} exists${RESET}"
elif ! lib_exists "$FROM_LIB"; then
  echo -e "  ${RED}ERROR: Source library ${FROM_LIB} does not exist.${RESET}" >&2
  exit 1
else
  stats=$(lib_stats "$FROM_LIB")
  echo -e "  ${GREEN}Found: ${stats}${RESET}"
fi
echo ""

# ---------------------------------------------------------------------------
# Step 2 — Global overwrite confirmation (if any target exists and no --force)
# ---------------------------------------------------------------------------
if ! $FORCE && ! $DRY_RUN; then
  existing=()
  for tgt in "${TARGETS[@]}"; do
    lib_exists "$tgt" && existing+=("$tgt")
  done
  if [[ ${#existing[@]} -gt 0 ]]; then
    echo -e "${BOLD}[2] Existing target libraries detected${RESET}"
    echo -e "  ${YELLOW}The following libraries already exist and will be deleted:${RESET}"
    for lib in "${existing[@]}"; do
      echo -e "    ${YELLOW}• ${lib}${RESET}"
    done
    echo ""
    echo -en "  ${BOLD}Proceed and overwrite all listed libraries? [y/N]: ${RESET}"
    read -r answer
    if [[ ! "$answer" =~ ^[Yy]$ ]]; then
      echo -e "  ${YELLOW}Aborted — no libraries modified.${RESET}"
      exit 0
    fi
    echo ""
    # From here treat as forced for the loop
    FORCE=true
  fi
fi

# ---------------------------------------------------------------------------
# Step 3 — Clone loop
# ---------------------------------------------------------------------------
STEP=2
$FORCE && STEP=2   # skip the detection step numbering
total=${#TARGETS[@]}
idx=0

for TGT in "${TARGETS[@]}"; do
  idx=$((idx + 1))
  echo -e "${BOLD}[${STEP}/${total}] ${FROM_LIB} → ${TGT}  (${idx}/${total})${RESET}"

  # -- Delete existing target if needed ------------------------------------
  if ! $DRY_RUN && lib_exists "$TGT"; then
    if ! $FORCE; then
      echo -en "  ${YELLOW}${TGT} already exists. Delete and overwrite? [y/N]: ${RESET}"
      read -r ans
      if [[ ! "$ans" =~ ^[Yy]$ ]]; then
        echo -e "  ${YELLOW}Skipping ${TGT}${RESET}"
        echo ""
        STEP=$((STEP + 1))
        continue
      fi
    fi
    run_cl "Deleting ${TGT}..." "QSYS/DLTLIB LIB(${TGT})" || {
      TOTAL_ERR=$((TOTAL_ERR + 1))
      echo ""
      STEP=$((STEP + 1))
      continue
    }
  fi

  # -- CPYLIB --------------------------------------------------------------
  if run_cl "CPYLIB ${FROM_LIB} → ${TGT}..." \
       "QSYS/CPYLIB FROMLIB(${FROM_LIB}) TOLIB(${TGT}) CRTLIB(*YES)"; then

    if ! $DRY_RUN; then
      stats=$(lib_stats "$TGT")
      echo -e "    ${GREEN}✓ ${TGT}: ${stats}${RESET}"
    fi
    TOTAL_OK=$((TOTAL_OK + 1))
  else
    TOTAL_ERR=$((TOTAL_ERR + 1))
  fi

  echo ""
  STEP=$((STEP + 1))
done

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
echo -e "${BOLD}============================================================${RESET}"
if $DRY_RUN; then
  echo -e "  ${YELLOW}DRY RUN complete — no changes were made${RESET}"
  echo -e "  Would have cloned ${CYAN}${FROM_LIB}${RESET} into: ${CYAN}${TARGETS[*]}${RESET}"
elif [[ $TOTAL_ERR -eq 0 ]]; then
  echo -e "  ${GREEN}ALL DONE — ${TOTAL_OK}/${total} libraries cloned successfully${RESET}"
else
  echo -e "  ${YELLOW}DONE with errors — ${TOTAL_OK} succeeded, ${TOTAL_ERR} failed${RESET}"
fi
echo -e "${BOLD}============================================================${RESET}"
echo ""

exit $TOTAL_ERR
